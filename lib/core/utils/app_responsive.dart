import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppResponsive {
  // Breakpoints
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1200;

  // Métodos de utilidad
  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }

  static bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }

  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }

  // Obtener el ancho de la pantalla
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Obtener el alto de la pantalla
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Valores responsivos para padding
  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 32.0;
    } else {
      return 64.0;
    }
  }

  static double verticalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  // Valores responsivos para márgenes
  static double horizontalMargin(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  // Ancho máximo del contenido
  static double maxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return screenWidth(context) - (horizontalPadding(context) * 2);
    } else if (isTablet(context)) {
      return 480.0;
    } else {
      return 400.0;
    }
  }

  // Configuración de ResponsiveFramework
  static List<Breakpoint> get breakpoints => [
    const Breakpoint(start: 0, end: mobile, name: MOBILE),
    const Breakpoint(start: mobile + 1, end: tablet, name: TABLET),
    const Breakpoint(start: tablet + 1, end: desktop, name: DESKTOP),
    const Breakpoint(start: desktop + 1, end: double.infinity, name: '4K'),
  ];
}
