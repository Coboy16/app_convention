import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/feactures.dart';
import '/shared/shared.dart';

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
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Obtener el estado de autenticación del BLoC
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoading =
          authState.status == AuthStatus.loading ||
          authState.status == AuthStatus.initial;

      // Rutas públicas (no requieren autenticación)
      final publicRoutes = [login, signup, forgotPassword];
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Si está cargando, mantener la ruta actual
      if (isLoading) {
        return null;
      }

      // Si no está autenticado y trata de acceder a ruta protegida
      if (!isAuthenticated && !isPublicRoute) {
        return login;
      }

      // Si está autenticado y trata de acceder a login/signup
      if (isAuthenticated &&
          (state.matchedLocation == login ||
              state.matchedLocation == signup ||
              state.matchedLocation == initial)) {
        return central;
      }

      return null; // No redirigir
    },
    routes: [
      // Ruta inicial
      GoRoute(
        path: initial,
        name: 'initial',
        builder: (context, state) => const AuthLoadingScreen(),
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

      // Forgot Password
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Forgot Password Screen - Por implementar')),
        ),
      ),

      // Central (Home principal)
      GoRoute(
        path: central,
        name: 'central',
        builder: (context, state) => const CentralScreen(),
      ),

      // Settings
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
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
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Ir al login'),
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
    context.go(central);
  }

  static void goToCentral(BuildContext context) {
    context.go(central);
  }

  static void goToProfile(BuildContext context) {
    context.go(profile);
  }

  static void goToSettings(BuildContext context) {
    context.go(settings);
  }

  // Método para logout y limpiar navegación
  static void logout(BuildContext context) {
    context.go(login);
  }
}
