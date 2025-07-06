import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/core.dart';

class AdminActionsWidget extends StatelessWidget {
  const AdminActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.radio,
              size: 16,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text('Acciones de Administrador', style: AppTextStyles.h4),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _ActionButton(
                title: 'Nuevo Post',
                color: AppColors.primary,
                icon: LucideIcons.pencilLine,
                onTap: () {
                  ToastUtils.showInfo(
                    context: context,
                    message: 'Función próximamente...',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                title: 'Reportes',
                color: AppColors.success,
                icon: LucideIcons.chartBar,
                onTap: () {
                  ToastUtils.showInfo(
                    context: context,
                    message: 'Función próximamente...',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                title: 'Asistentes',
                color: AppColors.info,
                icon: LucideIcons.users,
                onTap: () {
                  ToastUtils.showInfo(
                    context: context,
                    message: 'Función próximamente...',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.surface, size: 24),
            const SizedBox(height: 8),
            AutoSizeText(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
