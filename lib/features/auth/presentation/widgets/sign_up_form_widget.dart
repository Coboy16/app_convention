import 'package:flutter/material.dart';

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

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      ToastUtils.showError(
        context: context,
        message: 'Por favor corrige los errores en el formulario',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Aquí irá la lógica real de registro con BLoC
      ToastUtils.showSuccess(
        context: context,
        message: 'Cuenta creada exitosamente',
      );

      // Navegar al home después del registro exitoso
      AppRoutes.goToHome(context);
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al crear la cuenta. Inténtalo de nuevo.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // Simular llamada a Google Sign Up
      await Future.delayed(const Duration(seconds: 1));

      ToastUtils.showSuccess(
        context: context,
        message: 'Cuenta creada con Google exitosamente',
      );

      // Navegar al home después del registro con Google
      AppRoutes.goToHome(context);
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al crear cuenta con Google',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            validator: (value) => FormValidators.validatePasswordConfirmation(
              value,
              _passwordController.text,
            ),
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
            onPressed: _isLoading ? null : _handleSignUp,
            isLoading: _isLoading,
            isFullWidth: true,
            type: ButtonType.primary,
          ),

          // Divider con texto
          const CustomDivider(text: 'or continue with'),

          // Botón de Google Sign Up
          GoogleSignInButton(
            onPressed: _isGoogleLoading ? null : _handleGoogleSignUp,
            isLoading: _isGoogleLoading,
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
                  onPressed: () => AppRoutes.goToLogin(context),
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
  }
}
