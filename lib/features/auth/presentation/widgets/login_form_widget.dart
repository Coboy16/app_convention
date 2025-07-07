import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/auth/presentation/bloc/blocs.dart';
import '/features/auth/presentation/widgets/widgets.dart';
import '/core/core.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      ToastUtils.showError(
        context: context,
        message: 'Por favor corrige los errores en el formulario',
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(AuthGoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          ToastUtils.showSuccess(
            context: context,
            message: 'Inicio de sesión exitoso',
          );
        } else if (state.status == AuthStatus.error) {
          ToastUtils.showError(
            context: context,
            message: state.errorMessage ?? 'Error al iniciar sesión',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de email
              CustomTextField(
                label: 'Email Address',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
                validator: FormValidators.validateEmail,
                enabled: !isLoading,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),

              const SizedBox(height: 16),

              // Campo de contraseña
              CustomTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                isPassword: true,
                isRequired: true,
                validator: FormValidators.validatePassword,
                enabled: !isLoading,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),

              const SizedBox(height: 8),

              // Enlace de "Forgot Password"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () => AppRoutes.goToForgotPassword(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: AutoSizeText(
                    'Forgot Password?',
                    style: AppTextStyles.link,
                    maxLines: 1,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botón de Sign In
              CustomButton(
                text: 'Sign In',
                onPressed: isLoading ? null : _handleLogin,
                isLoading: isLoading,
                isFullWidth: true,
                type: ButtonType.primary,
              ),

              // Divider con texto
              const CustomDivider(text: 'or continue with'),

              // Botón de Google Sign In
              GoogleSignInButton(
                onPressed: isLoading ? null : _handleGoogleSignIn,
                isLoading: isLoading,
              ),

              const SizedBox(height: 32),

              // Enlace para crear cuenta
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.body2,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => AppRoutes.goToSignUp(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Sign Up', style: AppTextStyles.link),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
