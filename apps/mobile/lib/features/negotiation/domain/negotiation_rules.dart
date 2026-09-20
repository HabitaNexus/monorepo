/// Reglas puras de presentación de la negociación (HAB-27).
///
/// Todo se deriva del `state` del servidor o de los documentos de términos;
/// esta capa nunca muta estado ni decide transiciones.
library;

import 'negotiation.dart';

/// Máximo de rondas del SOP (espejo de `MAX_ROUNDS` en `states.ts`).
const int kMaxRounds = 5;

/// Compara fila por fila resolviendo el texto visible de cada lado:
/// prevalece el override por fila; si no hay, el valor de la key API.
/// Hay DIFF si los valores normalizados difieren.
///
/// Recibe [specs] (número de fila + apiKey) para no acoplar el dominio a
/// la tabla de mapeo UI; la presentación los deriva de `kTermsMapping`.
List<RowComparison> compareRows(
    NegotiationDetail detail, List<RowSpec> specs) {
  return specs.map((s) {
    final a =
        detail.baseOverrides[s.number] ?? detail.baseTerms[s.apiKey] ?? '';
    final b = detail.currentOverrides[s.number] ??
        detail.currentTerms[s.apiKey] ??
        '';
    final bool isDiff =
        s.lenient ? a.isEmpty != b.isEmpty : _norm(a) != _norm(b);
    return RowComparison(
      number: s.number,
      apiKey: s.apiKey,
      base: a,
      current: b,
      isDiff: isDiff,
    );
  }).toList();
}

String _norm(String? v) => v == null ? '' : v.trim().toLowerCase();

/// Número de filas con diferencias.
int countDiffs(List<RowComparison> comparisons) =>
    comparisons.where((c) => c.isDiff).length;

/// Habilitación de acciones de ronda: solo si el servidor reporta ronda
/// abierta y el deadline no ha vencido. La última palabra la tiene el
/// servidor al rechazar la mutación.
bool canActOnRound(NegotiationState state, DateTime now) {
  if (!state.isOpenRound) return false;
  return now.isBefore(state.deadline);
}

/// Etiqueta de turno. El backend HAB-26 no expone turno: solo se afirma
/// "Tu decisión" cuando se conoce el último redactor (demo o acción local);
/// en el resto de casos se muestra texto neutral derivado del estado.
String turnLabel({
  required NegotiationState state,
  required NegotiationParty role,
  NegotiationParty? lastAuthor,
}) {
  if (!state.isOpenRound) return _statusLabel(state.status);
  if (lastAuthor != null) {
    return lastAuthor == role ? 'Turno: contraparte' : 'Turno: Tu decisión';
  }
  return 'Turno: por responder';
}

String _statusLabel(NegotiationStatus status) {
  switch (status) {
    case NegotiationStatus.propuestaEnviada:
      return 'Propuesta enviada';
    case NegotiationStatus.contrapropuesta:
      return 'Contrapropuesta';
    case NegotiationStatus.acuerdoAlcanzado:
      return 'Acuerdo alcanzado';
    case NegotiationStatus.pendienteFirma:
      return 'Pendiente de firma';
    case NegotiationStatus.rechazada:
      return 'Rechazada';
    case NegotiationStatus.expirada:
      return 'Expirada';
  }
}

/// Etiqueta pública del estado para banners.
String statusLabel(NegotiationStatus status) => _statusLabel(status);

/// Formatea el tiempo restante al deadline ("18h 42m", "2d 5h", "vencido").
String formatRemaining(DateTime deadline, DateTime now) {
  final diff = deadline.difference(now);
  if (diff.isNegative) return 'vencido';
  final days = diff.inDays;
  final hours = diff.inHours % 24;
  final minutes = diff.inMinutes % 60;
  if (days > 0) return '${days}d ${hours}h';
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

/// Extrae el monto numérico de un valor UI ("₡495,000" → 495000).
double parseMonto(String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9.]'), '');
  if (digits.isEmpty) return 0;
  return double.tryParse(digits) ?? 0;
}

/// Calculadora del slot escrow (HAB-28): canon + depósito de 1 mes +
/// comisión fiduciaria del 1.5%. La lógica definitiva vive en HAB-28;
/// este slot es integrable y usa los mismos inputs.
EscrowBreakdown computeEscrow({
  required double canon,
  double depositMonths = 1,
  double feeRate = 0.015,
}) {
  final deposito = canon * depositMonths;
  final comision = canon * feeRate;
  return EscrowBreakdown(
    canon: canon,
    deposito: deposito,
    comision: comision,
    total: canon + deposito + comision,
  );
}

/// Aviso HAB-29: visible cuando el plazo pactado es menor a 3 años (36 meses).
bool shouldShowLegalNotice(int? plazoMeses) {
  if (plazoMeses == null) return false;
  return plazoMeses < 36;
}

/// Lee el plazo en meses desde el valor UI ("12 meses forzosos" → 12).
int? parsePlazoMeses(String value) {
  final match = RegExp(r'(\d+)').firstMatch(value);
  if (match == null) return null;
  return int.tryParse(match.group(1) ?? '');
}

/// Formatea montos en colones sin decimales ("₡997,425").
String formatColones(double value) {
  final n = value.round();
  final s = n.toString();
  final buf = StringBuffer();
  var count = 0;
  for (var i = s.length - 1; i >= 0; i--) {
    buf.write(s[i]);
    count++;
    if (count % 3 == 0 && i > 0) buf.write(',');
  }
  return '₡${buf.toString().split('').reversed.join()}';
}
