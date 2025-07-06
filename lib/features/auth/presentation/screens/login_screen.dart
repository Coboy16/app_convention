import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '/features/auth/presentation/widgets/widgets.dart';
import '/core/core.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveScaledBox(
          width: size.width,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.horizontalPadding(context),
        vertical: AppResponsive.verticalPadding(context),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            AuthHeader(
              title: 'App Convention',
              subtitle: 'Welcome to Convention 2024',
              icon: Icon(
                Icons.calendar_today,
                color: AppColors.surface,
                size: AppResponsive.isMobile(context) ? 32 : 40,
              ),
            ),

            SizedBox(height: AppResponsive.isMobile(context) ? 40 : 48),

            // Card con el formulario de login
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: AppResponsive.maxContentWidth(context),
              ),
              padding: EdgeInsets.all(
                AppResponsive.isMobile(context) ? 24 : 32,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título del formulario DENTRO de la card
                  Column(
                    children: [
                      Text(
                        'Sign In',
                        style: AppResponsive.isMobile(context)
                            ? AppTextStyles.h4
                            : AppTextStyles.h3,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome back to the convention',
                        style: AppResponsive.isMobile(context)
                            ? AppTextStyles.body2
                            : AppTextStyles.body1,
                      ),
                    ],
                  ),

                  SizedBox(height: AppResponsive.isMobile(context) ? 24 : 32),

                  // Formulario de login
                  const LoginForm(),
                ],
              ),
            ),

            SizedBox(height: AppResponsive.isMobile(context) ? 24 : 32),

            // Footer con términos y condiciones
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'By continuing, you agree to our ',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              // Navegar a términos de servicio
              debugPrint('Terms of Service');
            },
            child: Text('Terms of Service', style: AppTextStyles.linkSmall),
          ),
          Text(' and ', style: AppTextStyles.caption),
          GestureDetector(
            onTap: () {
              // Navegar a política de privacidad
              debugPrint('Privacy Policy');
            },
            child: Text('Privacy Policy', style: AppTextStyles.linkSmall),
          ),
        ],
      ),
    );
  }
}
