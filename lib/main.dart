import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

import '/core/core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Konecta App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: AppResponsive.breakpoints,
          );
        },
      ),
    );
  }
}
