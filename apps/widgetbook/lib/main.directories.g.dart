// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:habitanexus_widgetbook/use_cases/atoms/space_type_icon_use_case.dart'
    as _habitanexus_widgetbook_use_cases_atoms_space_type_icon_use_case;
import 'package:habitanexus_widgetbook/use_cases/organisms/nearby_coworkings_use_case.dart'
    as _habitanexus_widgetbook_use_cases_organisms_nearby_coworkings_use_case;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'atoms',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'SpaceTypeIcon',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _habitanexus_widgetbook_use_cases_atoms_space_type_icon_use_case
                    .buildSpaceTypeIconUseCase,
          )
        ],
      )
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'organisms',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'NearbyCoworkings',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _habitanexus_widgetbook_use_cases_organisms_nearby_coworkings_use_case
                    .buildNearbyCoworkingsUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Error',
            builder:
                _habitanexus_widgetbook_use_cases_organisms_nearby_coworkings_use_case
                    .buildNearbyCoworkingsErrorUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Loading',
            builder:
                _habitanexus_widgetbook_use_cases_organisms_nearby_coworkings_use_case
                    .buildNearbyCoworkingsLoadingUseCase,
          ),
        ],
      )
    ],
  ),
];
