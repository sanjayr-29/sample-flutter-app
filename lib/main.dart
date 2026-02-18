import 'package:dummy_app/pages/device_page.dart';
import 'package:dummy_app/pages/home_page.dart';
import 'package:dummy_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/device', builder: (context, state) => const DevicePage()),
  ],
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: buildTheme(context, Brightness.light),
      routerConfig: _router,
    );
  }
}
