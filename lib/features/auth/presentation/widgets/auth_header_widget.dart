import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/core/core.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ícono de la app
        if (icon != null) ...[
          Container(
            width: AppResponsive.isMobile(context) ? 64 : 80,
            height: AppResponsive.isMobile(context) ? 64 : 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: icon,
          ),
          SizedBox(height: AppResponsive.isMobile(context) ? 24 : 32),
        ],

        // Título principal
        AutoSizeText(
          title,
          style: AppResponsive.isMobile(context)
              ? AppTextStyles.h3
              : AppTextStyles.h2,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        // Subtítulo
        AutoSizeText(
          subtitle,
          style: AppResponsive.isMobile(context)
              ? AppTextStyles.body2
              : AppTextStyles.body1,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
