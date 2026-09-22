import 'package:flutter/material.dart';
import 'package:habitanexus_ui/habitanexus_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: SpaceTypeIcon, path: '[atoms]')
Widget buildSpaceTypeIconUseCase(BuildContext context) {
  return SpaceTypeIcon(
    type: context.knobs.object.dropdown(
      label: 'Tipo de espacio',
      options: SpaceType.values,
      labelBuilder: (type) => type.name,
    ),
    size: context.knobs.double.slider(
      label: 'Size', initialValue: 40, min: 16, max: 96,
    ),
  );
}
