import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/features/auth/presentation/widgets/widgets.dart';
import '/core/core.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSignUp;

  const LoginForm({
    super.key,
    this.onLoginSuccess,
    this.onGoogleSignIn,
    this.onForgotPassword,
    this.onSignUp,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
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

      // Aquí irá la lógica real de autenticación con BLoC
      ToastUtils.showSuccess(
        context: context,
        message: 'Inicio de sesión exitoso',
      );

      // Navegar al home después del login exitoso
      AppRoutes.goToHome(context);
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al iniciar sesión. Inténtalo de nuevo.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // Simular llamada a Google Sign In
      await Future.delayed(const Duration(seconds: 1));

      ToastUtils.showSuccess(
        context: context,
        message: 'Inicio de sesión con Google exitoso',
      );

      // Navegar al home después del login con Google
      AppRoutes.goToHome(context);
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al iniciar sesión con Google',
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

          const SizedBox(height: 8),

          // Enlace de "Forgot Password"
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => AppRoutes.goToForgotPassword(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
            isFullWidth: true,
            type: ButtonType.primary,
          ),

          // Divider con texto
          const CustomDivider(text: 'or continue with'),

          // Botón de Google Sign In
          GoogleSignInButton(
            onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
            isLoading: _isGoogleLoading,
          ),

          const SizedBox(height: 32),

          // Enlace para crear cuenta
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => AppRoutes.goToSignUp(context),
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
        ],
      ),
    );
  }
}
