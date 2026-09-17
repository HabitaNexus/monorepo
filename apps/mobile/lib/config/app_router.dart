import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/coworking/presentation/coworking_finder_page.dart';
import '../features/coworking/presentation/coworking_detail_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('HabitaNexus')),
        ),
      ),
      GoRoute(
        path: '/coworkings',
        name: 'coworkings',
        builder: (context, state) => const CoworkingFinderPage(),
      ),
      GoRoute(
        path: '/coworkings/:id',
        name: 'coworking-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CoworkingDetailPage(spaceId: id);
        },
      ),
    ],
  );
});
