import 'package:flutter/material.dart';
import 'package:habitanexus_ui/habitanexus_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'showcase/design_system_showcase.dart';

// Generado por build_runner
import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('HabitaNexus Design System'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Widgetbook',
                  icon: Icon(Icons.menu_book_rounded),
                ),
                Tab(
                  text: 'Showcase',
                  icon: Icon(Icons.palette_rounded),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Widgetbook.material(
                directories: directories,
                addons: [
                  MaterialThemeAddon(
                    themes: [
                      WidgetbookTheme(
                        name: 'Light',
                        data: AppTheme.lightTheme,
                      ),
                      WidgetbookTheme(
                        name: 'Dark',
                        data: AppTheme.darkTheme,
                      ),
                    ],
                  ),
                  AlignmentAddon(),
                ],
              ),
              const DesignSystemShowcase(),
            ],
          ),
        ),
      ),
    );
  }
}
