import 'package:flutter/material.dart';

/// Pantalla "Firma Digital BCCR" importada de Stitch para HAB-27.
///
/// Origen: proyecto `Remix of HabitaNexus PropTech Mobile App`,
/// pantalla `Firma Digital BCCR - Contrato #HN-2025-4412`
/// (`projects/1573816484783042242/screens/2bc1400a2a41421fa66d91d3423b4910`).
/// HTML y captura de referencia en `/tmp/opencode/stitch_hab27/`.
///
/// Datos estáticos de demostración; el wiring con el backend de
/// negociación/firma llega con HAB-27.
class DigitalSignaturePage extends StatefulWidget {
  const DigitalSignaturePage({super.key});

  @override
  State<DigitalSignaturePage> createState() => _DigitalSignaturePageState();
}

class _SigColors {
  static const background = Color(0xFF0D1322);
  static const surface = Color(0xFF191F2F);
  static const surfaceHigh = Color(0xFF242A3A);
  static const primary = Color(0xFF2DD4BF);
  static const onBackground = Color(0xFFDDE2F8);
  static const muted = Color(0xFFBAC6E7);
  static const warning = Color(0xFFFFB4AB);
}

class _DigitalSignaturePageState extends State<DigitalSignaturePage> {
  int _methodIndex = 0;
  int _navIndex = 2;
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _SigColors.background,
      appBar: AppBar(
        backgroundColor: _SigColors.background,
        foregroundColor: _SigColors.onBackground,
        title: const Text('HabitaNexus'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _badgesRow(),
            const SizedBox(height: 12),
            _contractCard(),
            const SizedBox(height: 12),
            _signersCard(),
            const SizedBox(height: 12),
            _financeCard(),
            const SizedBox(height: 12),
            _clausesCard(),
            const SizedBox(height: 12),
            _integrityCard(),
            const SizedBox(height: 12),
            _methodCard(),
            const SizedBox(height: 16),
            _ctaButton(),
            const SizedBox(height: 8),
            const Text(
              'Artículo 8 de la Ley 8454 — firma con equivalencia probatoria.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _SigColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _SigColors.surface,
        selectedItemColor: _SigColors.primary,
        unselectedItemColor: _SigColors.muted,
        currentIndex: _navIndex,
        onTap: (int i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handshake), label: 'Pactos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _badgesRow() {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Badge('Ley 8454 • Certificador BCCR'),
        _Badge('SOP-02'),
        _Badge('Protocolo Notarial Activo'),
      ],
    );
  }

  Widget _contractCard() {
    return _card([
      const Text(
        'Contrato #HN-2025-4412',
        style: TextStyle(
          color: _SigColors.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Altamira Sky 402, Rohrmoser • Folio Real: #1-394821',
        style: TextStyle(color: _SigColors.muted, fontSize: 13),
      ),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: const LinearProgressIndicator(
          value: 0.5,
          minHeight: 8,
          backgroundColor: _SigColors.surfaceHigh,
          valueColor: AlwaysStoppedAnimation(_SigColors.primary),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'FIRMA 1 DE 2 OK — Falta firma arrendataria',
        style: TextStyle(color: _SigColors.primary, fontSize: 12),
      ),
    ]);
  }

  Widget _signersCard() {
    return _card([
      const _SectionTitle('Firmantes'),
      const _SignerRow(
        name: 'Lic. Rodrigo Fallas Monge',
        role: 'Fiduciario BANCR-ESCROW-CR-8849-01',
        status: 'SELLADO BCCR',
        done: true,
      ),
      const Divider(color: _SigColors.surfaceHigh),
      const _SignerRow(
        name: 'Sofía Morales V. (Tú)',
        role: 'Cédula 1-1582-0492',
        status: 'PENDIENTE',
        done: false,
      ),
    ]);
  }

  Widget _financeCard() {
    return _card(const [
      _SectionTitle('Condiciones Financieras Homologadas'),
      Text('Ley 7527',
          style: TextStyle(color: _SigColors.muted, fontSize: 12)),
      SizedBox(height: 8),
      _FinanceRow('Canon Mensual', '₡485,000', 'Pagadero día 1-5 c/mes'),
      _FinanceRow(
          'Depósito en Garantía', 'Custodia Banco Promerica', 'Plazo Forzoso'),
      _FinanceRow('Plazo', '24 Meses', 'IPC fijo 0% por 12m'),
      _FinanceRow(
          'Mantenimiento', 'Incluido', 'Cuota de \$145 bonificada'),
    ]);
  }

  Widget _clausesCard() {
    return _card(const [
      _SectionTitle('Cláusulas de Cumplimiento Especial'),
      Text('3 esenciales',
          style: TextStyle(color: _SigColors.muted, fontSize: 12)),
      ExpansionTile(
        title: Text('Arbitraje CICA & Jurisdicción San José',
            style: TextStyle(color: _SigColors.onBackground, fontSize: 14)),
        iconColor: _SigColors.primary,
        collapsedIconColor: _SigColors.muted,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('Controversias ante el CICA con sede en San José.',
                style: TextStyle(color: _SigColors.muted, fontSize: 13)),
          ),
        ],
      ),
      ExpansionTile(
        title: Text('Fideicomiso & Escrow Promerica CR',
            style: TextStyle(color: _SigColors.onBackground, fontSize: 14)),
        iconColor: _SigColors.primary,
        collapsedIconColor: _SigColors.muted,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('Fondos en custodia fiduciaria durante el plazo.',
                style: TextStyle(color: _SigColors.muted, fontSize: 13)),
          ),
        ],
      ),
      ExpansionTile(
        title: Text('Acta de Entrega Digital y Códigos Físicos',
            style: TextStyle(color: _SigColors.onBackground, fontSize: 14)),
        iconColor: _SigColors.primary,
        collapsedIconColor: _SigColors.muted,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('Entrega con inventario fotográfico y códigos.',
                style: TextStyle(color: _SigColors.muted, fontSize: 13)),
          ),
        ],
      ),
    ]);
  }

  Widget _integrityCard() {
    return _card(const [
      _SectionTitle('Integridad Hash SHA-256 & Certificados'),
      Text('TLS 1.3 SECURE',
          style: TextStyle(color: _SigColors.primary, fontSize: 12)),
      SizedBox(height: 8),
      _MonoRow('DOC SHA-256:', '8f3c7a21b4e0...d9e40b12'),
      _MonoRow('ESTAMPILLADO BCCR:', '2025-05-18T14:32:09.112 UTC-6'),
      _MonoRow('AUTORIDAD EMISORA:', 'CA SINPE - Banco Central Costa Rica'),
      _MonoRow('ALGORITMO RESUMEN:', 'ECDSA P-256 / SHA-256'),
    ]);
  }

  Widget _methodCard() {
    return _card([
      const _SectionTitle('Método de Firma BCCR'),
      const Text('Selecciona tu Dispositivo Autenticador',
          style: TextStyle(color: _SigColors.muted, fontSize: 12)),
      const SizedBox(height: 8),
      _methodOption(0, Icons.sim_card, 'Gaudi Móvil', 'BCCR Token / App'),
      _methodOption(
          1, Icons.contactless, 'Tarjeta Física', 'Lector NFC / SmartCard'),
      const SizedBox(height: 8),
      TextField(
        controller: _pinController,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 8,
        style: const TextStyle(color: _SigColors.onBackground),
        decoration: const InputDecoration(
          labelText: 'PIN de Firma Digital (4 a 8 dígitos)',
          labelStyle: TextStyle(color: _SigColors.muted),
          prefixIcon: Icon(Icons.password, color: _SigColors.muted),
          suffixIcon: Icon(Icons.visibility, color: _SigColors.muted),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _SigColors.surfaceHigh),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _SigColors.primary),
          ),
        ),
      ),
      const Row(
        children: [
          Icon(Icons.fingerprint,
              color: _SigColors.primary, size: 20),
          SizedBox(width: 8),
          Text('Biometría Gaudi',
              style: TextStyle(color: _SigColors.onBackground, fontSize: 14)),
        ],
      ),
    ]);
  }

  Widget _methodOption(int index, IconData icon, String title, String sub) {
    final bool selected = _methodIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _methodIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _SigColors.surfaceHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _SigColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: _SigColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: _SigColors.onBackground,
                          fontWeight: FontWeight.w600)),
                  Text(sub,
                      style: const TextStyle(
                          color: _SigColors.muted, fontSize: 12)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: _SigColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _ctaButton() {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: _SigColors.primary,
        foregroundColor: const Color(0xFF00201C),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firma demo: el backend de firma llega con HAB-27.'),
          ),
        );
      },
      icon: const Icon(Icons.draw),
      label: const Text('EJECUTAR FIRMA DIGITAL VINCULANTE'),
    );
  }

  Widget _card(List<Widget> children) {
    // Material (no Container decorado): los ExpansionTile/ListTile
    // pintan sus ink splashes sobre el Material ancestro.
    return Material(
      color: _SigColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _SigColors.surfaceHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: _SigColors.primary, fontSize: 11),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: _SigColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SignerRow extends StatelessWidget {
  final String name;
  final String role;
  final String status;
  final bool done;
  const _SignerRow({
    required this.name,
    required this.role,
    required this.status,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.pending,
          color: done ? _SigColors.primary : _SigColors.warning,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: _SigColors.onBackground,
                      fontWeight: FontWeight.w600)),
              Text(role,
                  style:
                      const TextStyle(color: _SigColors.muted, fontSize: 12)),
            ],
          ),
        ),
        Text(
          status,
          style: TextStyle(
            color: done ? _SigColors.primary : _SigColors.warning,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FinanceRow extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  const _FinanceRow(this.label, this.value, this.note);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: _SigColors.onBackground, fontSize: 14)),
                Text(note,
                    style:
                        const TextStyle(color: _SigColors.muted, fontSize: 12)),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _SigColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonoRow extends StatelessWidget {
  final String label;
  final String value;
  const _MonoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(color: _SigColors.muted, fontSize: 11)),
          Text(
            value,
            style: const TextStyle(
              color: _SigColors.onBackground,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
