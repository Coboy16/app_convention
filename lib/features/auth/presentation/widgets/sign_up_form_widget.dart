import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/auth/presentation/bloc/blocs.dart';
import '/features/auth/presentation/widgets/widgets.dart';
import '/core/core.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (!_formKey.currentState!.validate()) {
      ToastUtils.showError(
        context: context,
        message: 'Por favor corrige los errores en el formulario',
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _fullNameController.text.trim(),
      ),
    );
  }

  void _handleGoogleSignUp() {
    context.read<AuthBloc>().add(AuthGoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          ToastUtils.showSuccess(
            context: context,
            message: 'Cuenta creada exitosamente',
          );
          AppRoutes.goToHome(context);
        } else if (state.status == AuthStatus.error) {
          ToastUtils.showError(
            context: context,
            message: state.errorMessage ?? 'Error al crear la cuenta',
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
              // Campo de nombre completo
              CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _fullNameController,
                keyboardType: TextInputType.name,
                isRequired: true,
                validator: FormValidators.validateName,
                enabled: !isLoading,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),

              const SizedBox(height: 16),

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

              const SizedBox(height: 16),

              // Campo de confirmar contraseña
              CustomTextField(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                controller: _confirmPasswordController,
                isPassword: true,
                isRequired: true,
                validator: (value) =>
                    FormValidators.validatePasswordConfirmation(
                      value,
                      _passwordController.text,
                    ),
                enabled: !isLoading,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),

              const SizedBox(height: 32),

              // Botón de Sign Up
              CustomButton(
                text: 'Sign Up',
                onPressed: isLoading ? null : _handleSignUp,
                isLoading: isLoading,
                isFullWidth: true,
                type: ButtonType.primary,
              ),

              // Divider con texto
              const CustomDivider(text: 'or continue with'),

              // Botón de Google Sign Up
              GoogleSignInButton(
                onPressed: isLoading ? null : _handleGoogleSignUp,
                isLoading: isLoading,
                text: 'Continue with Google',
              ),

              const SizedBox(height: 32),

              // Enlace para iniciar sesión
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.body2,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => AppRoutes.goToLogin(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Sign In', style: AppTextStyles.link),
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
