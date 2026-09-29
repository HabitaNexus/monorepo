import 'package:flutter/material.dart';

import '../../data/terms_mapping.dart';
import '../../domain/negotiation.dart';

/// Hoja de contrapropuesta: edita los valores de las filas con DIFF
/// (las cláusulas fijas SOP no aparecen: son de solo lectura).
/// Devuelve número de fila → nuevo texto, o null si se cancela.
Future<Map<int, String>?> showCounterSheet({
  required BuildContext context,
  required List<RowComparison> diffRows,
  required String nextRoundLabel,
}) {
  final editable =
      diffRows.where((r) => !_isFixed(r.number)).toList();
  return showModalBottomSheet<Map<int, String>>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _CounterSheet(
      rows: editable,
      nextRoundLabel: nextRoundLabel,
    ),
  );
}

bool _isFixed(int number) =>
    kTermsMapping.any((m) => m.number == number && m.isFixed);

class _CounterSheet extends StatefulWidget {
  final List<RowComparison> rows;
  final String nextRoundLabel;

  const _CounterSheet({required this.rows, required this.nextRoundLabel});

  @override
  State<_CounterSheet> createState() => _CounterSheetState();
}

class _CounterSheetState extends State<_CounterSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<int, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final r in widget.rows)
        r.number: TextEditingController(text: r.current),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Contraproponer ${widget.nextRoundLabel}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                  'Ajusta los valores de tu lado; el resto viaja sin cambios.',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final r in widget.rows)
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 4),
                          child: TextFormField(
                            controller: _controllers[r.number],
                            decoration: InputDecoration(
                              labelText: _label(r.number),
                              border:
                                  const OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Valor requerido'
                                    : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  Navigator.of(context).pop({
                    for (final e in _controllers.entries)
                      e.key: e.value.text.trim(),
                  });
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Enviar contrapropuesta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _label(int number) {
    final mapping = kTermsMapping.firstWhere((m) => m.number == number);
    return '${mapping.number}. ${mapping.uiLabel}';
  }
}
