import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/data/data.dart';
import '/core/core.dart';

class ProfileInfoWidget extends StatelessWidget {
  final ProfileModel profile;

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
              AutoSizeText('About', style: AppTextStyles.h4, maxLines: 1),
            ],
          ),
          const SizedBox(height: 12),
          AutoSizeText(
            profile.about,
            style: AppTextStyles.body2,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 20),

          // Dietary Restrictions
          if (profile.dietaryRestrictions.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  LucideIcons.utensils,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                AutoSizeText(
                  'Dietary Restrictions',
                  style: AppTextStyles.labelMedium,
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.dietaryRestrictions.map((restriction) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: AutoSizeText(
                    restriction,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Location
          Row(
            children: [
              const Icon(
                LucideIcons.mapPin,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              AutoSizeText(
                'Location',
                style: AppTextStyles.labelMedium,
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                LucideIcons.mapPin,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AutoSizeText(
                  profile.location,
                  style: AppTextStyles.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
