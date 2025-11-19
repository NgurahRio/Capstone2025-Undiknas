import 'dart:ui';

import 'package:admin_website/routes/router.dart';
import 'package:admin_website/services/auth_service.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}


void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return MaterialApp.router(
      title: 'Travora',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      routerConfig: createRouter(authService),
    );
  }
}