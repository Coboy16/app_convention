import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/features/auth/presentation/bloc/blocs.dart';
import '/core/core.dart';

class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go(AppRoutes.central);
        } else if (state.status == AuthStatus.unauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o ícono de la app
              const Icon(
                Icons.calendar_today,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text('App Convention', style: AppTextStyles.h3),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text('Verificando autenticación...', style: AppTextStyles.body2),
            ],
          ),
        ),
      ),
    );
  }
}
