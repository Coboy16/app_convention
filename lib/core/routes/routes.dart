import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '/features/feactures.dart';

class AppRoutes {
  // Rutas como constantes
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String central = '/central';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Configuración del router
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true, // Para debug en desarrollo
    routes: [
      // Ruta inicial - Login
      GoRoute(
        path: initial,
        name: 'initial',
        builder: (context, state) => const LoginScreen(),
      ),

      // Login
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Sign Up
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // Forgot Password (placeholder - crear después)
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Forgot Password Screen - Por implementar')),
        ),
      ),

      GoRoute(
        path: home,
        name: 'central',
        builder: (context, state) => const CentralScreen(),
      ),

      // Home (placeholder - crear después)
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const Scaffold(
          appBar: AppBarWidget(title: 'Home'),
          body: Center(child: Text('Home Screen - Por implementar')),
        ),
      ),

      // Profile (placeholder - crear después)
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const Scaffold(
          appBar: AppBarWidget(title: 'Profile'),
          body: Center(child: Text('Profile Screen - Por implementar')),
        ),
      ),

      // Settings (placeholder - crear después)
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const Scaffold(
          appBar: AppBarWidget(title: 'Settings'),
          body: Center(child: Text('Settings Screen - Por implementar')),
        ),
      ),
    ],

    // Manejo de errores
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La ruta "${state.uri}" no existe',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.initial),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );

  // Métodos de navegación helper
  static void goToLogin(BuildContext context) {
    context.go(login);
  }

  static void goToSignUp(BuildContext context) {
    context.go(signup);
  }

  static void goToForgotPassword(BuildContext context) {
    context.go(forgotPassword);
  }

  static void goToHome(BuildContext context) {
    context.go(home);
  }

  static void goToProfile(BuildContext context) {
    context.go(profile);
  }

  static void goToSettings(BuildContext context) {
    context.go(settings);
  }

  // Métodos de navegación con push (mantiene la historia)
  static void pushLogin(BuildContext context) {
    context.push(login);
  }

  static void pushSignUp(BuildContext context) {
    context.push(signup);
  }

  static void pushForgotPassword(BuildContext context) {
    context.push(forgotPassword);
  }

  static void pushProfile(BuildContext context) {
    context.push(profile);
  }

  static void pushSettings(BuildContext context) {
    context.push(settings);
  }

  // Método para limpiar la pila y ir a una nueva ruta
  static void goAndClearStack(BuildContext context, String route) {
    while (context.canPop()) {
      context.pop();
    }
    context.go(route);
  }
}

// Widget AppBar reutilizable para las pantallas placeholder
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
