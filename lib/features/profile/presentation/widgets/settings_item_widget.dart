import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/core.dart';

class SettingsItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  const SettingsItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 20),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: AppTextStyles.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  AutoSizeText(
                    subtitle,
                    style: AppTextStyles.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(
                LucideIcons.chevronRight,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
