/// Bottom nav compartido — evita duplicación entre HAB-27 y HAB-18.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppNavTab { inicio, buscar, pactos, contratos }

class AppBottomNav extends StatelessWidget {
  final AppNavTab current;
  const AppBottomNav({super.key, required this.current});

  int get _index => AppNavTab.values.indexOf(current);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (i) {
        final tab = AppNavTab.values[i];
        switch (tab) {
          case AppNavTab.inicio:
            context.go('/');
            break;
          case AppNavTab.buscar:
            context.go('/');
            break;
          case AppNavTab.pactos:
            context.go('/negociacion');
            break;
          case AppNavTab.contratos:
            context.go('/contrato');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.handshake_outlined), label: 'Pactos'),
        BottomNavigationBarItem(icon: Icon(Icons.verified_user_outlined), label: 'Contratos'),
      ],
    );
  }
}
