import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/domain/domain.dart';
import '/core/core.dart';

class ProfileInfoWidget extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileInfoWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.horizontalPadding(context),
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About section
          Row(
            children: [
              const Icon(LucideIcons.user, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              AutoSizeText('Acerca de', style: AppTextStyles.h4, maxLines: 1),
            ],
          ),
          const SizedBox(height: 12),
          AutoSizeText(
            profile.bio.isNotEmpty ? profile.bio : 'Sin información adicional',
            style: AppTextStyles.body2,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 20),

          // Role section
          Row(
            children: [
              const Icon(
                LucideIcons.briefcase,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              AutoSizeText(
                'Rol',
                style: AppTextStyles.labelMedium,
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: profile.isOrganizer
                  ? AppColors.warning.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: profile.isOrganizer
                    ? AppColors.warning.withOpacity(0.3)
                    : AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  profile.isOrganizer ? LucideIcons.crown : LucideIcons.user,
                  color: profile.isOrganizer
                      ? AppColors.warning
                      : AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                AutoSizeText(
                  profile.isOrganizer ? 'Organizador' : 'Participante',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: profile.isOrganizer
                        ? AppColors.warning
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),

          // Allergies section
          if (profile.allergies.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  LucideIcons.triangleAlert,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                AutoSizeText(
                  'Alergias',
                  style: AppTextStyles.labelMedium,
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.allergies.map((allergy) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: AutoSizeText(
                    allergy,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
