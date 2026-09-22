import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';

/// Pantalla "Firma Digital BCCR" importada de Stitch para HAB-27.
///
/// Origen: proyecto `Remix of HabitaNexus PropTech Mobile App`,
/// pantalla `Firma Digital BCCR - Contrato #HN-2025-4412`
/// (`projects/1573816484783042242/screens/2bc1400a2a41421fa66d91d3423b4910`).
/// HTML y captura de referencia en `/tmp/opencode/stitch_hab27/`.
///
/// Datos estáticos de demostración; el wiring con el backend de
/// negociación/firma llega con HAB-27.
///
/// Colores: 100% `Theme.of(context).colorScheme` (dark Stitch #0d1322/#57f1db).
/// Ruta: `/contrato` (HAB Contrato).
class DigitalSignaturePage extends StatefulWidget {
  const DigitalSignaturePage({super.key});

  @override
  State<DigitalSignaturePage> createState() => _DigitalSignaturePageState();
}

class _DigitalSignaturePageState extends State<DigitalSignaturePage> {
  int _methodIndex = 0;
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
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
            Text(
              'Artículo 8 de la Ley 8454 — firma con equivalencia probatoria.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(current: AppNavTab.contratos),
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
    final colors = Theme.of(context).colorScheme;
    return _card([
      Text(
        'Contrato #HN-2025-4412',
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'Altamira Sky 402, Rohrmoser • Folio Real: #1-394821',
        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
      ),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: 0.5,
          minHeight: 8,
          backgroundColor: colors.surfaceContainerHigh,
          valueColor:
              AlwaysStoppedAnimation(colors.primaryContainer),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'FIRMA 1 DE 2 OK — Falta firma arrendataria',
        style: TextStyle(color: colors.primaryContainer, fontSize: 12),
      ),
    ]);
  }

  Widget _signersCard() {
    final colors = Theme.of(context).colorScheme;
    return _card([
      const _SectionTitle('Firmantes'),
      const _SignerRow(
        name: 'Lic. Rodrigo Fallas Monge',
        role: 'Fiduciario BANCR-ESCROW-CR-8849-01',
        status: 'SELLADO BCCR',
        done: true,
      ),
      Divider(color: colors.surfaceContainerHigh),
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
      _MutedText('Ley 7527', 12),
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
    final colors = Theme.of(context).colorScheme;
    return _card([
      const _SectionTitle('Cláusulas de Cumplimiento Especial'),
      const _MutedText('3 esenciales', 12),
      ExpansionTile(
        title: Text('Arbitraje CICA & Jurisdicción San José',
            style: TextStyle(color: colors.onSurface, fontSize: 14)),
        iconColor: colors.primaryContainer,
        collapsedIconColor: colors.onSurfaceVariant,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('Controversias ante el CICA con sede en San José.',
                style: TextStyle(
                    color: colors.onSurfaceVariant, fontSize: 13)),
          ),
        ],
      ),
      ExpansionTile(
        title: Text('Fideicomiso & Escrow Promerica CR',
            style: TextStyle(color: colors.onSurface, fontSize: 14)),
        iconColor: colors.primaryContainer,
        collapsedIconColor: colors.onSurfaceVariant,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('Fondos en custodia fiduciaria durante el plazo.',
                style: TextStyle(
                    color: colors.onSurfaceVariant, fontSize: 13)),
          ),
        ],
      ),
      ExpansionTile(
        title: Text('Acta de Entrega Digital y Códigos Físicos',
            style: TextStyle(color: colors.onSurface, fontSize: 14)),
        iconColor: colors.primaryContainer,
        collapsedIconColor: colors.onSurfaceVariant,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('Entrega con inventario fotográfico y códigos.',
                style: TextStyle(
                    color: colors.onSurfaceVariant, fontSize: 13)),
          ),
        ],
      ),
    ]);
  }

  Widget _integrityCard() {
    final colors = Theme.of(context).colorScheme;
    return _card([
      const _SectionTitle('Integridad Hash SHA-256 & Certificados'),
      Text('TLS 1.3 SECURE',
          style: TextStyle(color: colors.primaryContainer, fontSize: 12)),
      const SizedBox(height: 8),
      const _MonoRow('DOC SHA-256:', '8f3c7a21b4e0...d9e40b12'),
      const _MonoRow('ESTAMPILLADO BCCR:', '2025-05-18T14:32:09.112 UTC-6'),
      const _MonoRow('AUTORIDAD EMISORA:', 'CA SINPE - Banco Central Costa Rica'),
      const _MonoRow('ALGORITMO RESUMEN:', 'ECDSA P-256 / SHA-256'),
    ]);
  }

  Widget _methodCard() {
    final colors = Theme.of(context).colorScheme;
    return _card([
      const _SectionTitle('Método de Firma BCCR'),
      _MutedText('Selecciona tu Dispositivo Autenticador', 12),
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
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: 'PIN de Firma Digital (4 a 8 dígitos)',
          labelStyle: TextStyle(color: colors.onSurfaceVariant),
          prefixIcon:
              Icon(Icons.password, color: colors.onSurfaceVariant),
          suffixIcon:
              Icon(Icons.visibility, color: colors.onSurfaceVariant),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.surfaceContainerHigh),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.primaryContainer),
          ),
        ),
      ),
      Row(
        children: [
          Icon(Icons.fingerprint,
              color: colors.primaryContainer, size: 20),
          const SizedBox(width: 8),
          Text('Biometría Gaudi',
              style: TextStyle(color: colors.onSurface, fontSize: 14)),
        ],
      ),
    ]);
  }

  Widget _methodOption(int index, IconData icon, String title, String sub) {
    final colors = Theme.of(context).colorScheme;
    final bool selected = _methodIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _methodIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                selected ? colors.primaryContainer : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.primaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600)),
                  Text(sub,
                      style: TextStyle(
                          color: colors.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle,
                  color: colors.primaryContainer),
          ],
        ),
      ),
    );
  }

  Widget _ctaButton() {
    final colors = Theme.of(context).colorScheme;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryFixed,
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
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainer,
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

class _MutedText extends StatelessWidget {
  final String text;
  final double size;
  const _MutedText(this.text, this.size);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: size));
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: colors.primaryContainer, fontSize: 11),
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
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
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
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.pending,
          color: done ? colors.primaryContainer : colors.error,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600)),
              Text(role,
                  style: TextStyle(
                      color: colors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
        Text(
          status,
          style: TextStyle(
            color: done ? colors.primaryContainer : colors.error,
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
    final colors = Theme.of(context).colorScheme;
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
                    style: TextStyle(
                        color: colors.onSurface, fontSize: 14)),
                Text(note,
                    style: TextStyle(
                        color: colors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.primaryContainer,
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
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: colors.onSurfaceVariant, fontSize: 11)),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
