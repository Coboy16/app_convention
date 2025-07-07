import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:konecta/features/profile/domain/entities/profile_entity.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/presentation/widgets/widgets.dart';
import '/core/core.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback? onEditProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onAvatarEdit;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    this.onEditProfile,
    this.onSettings,
    this.onAvatarEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.horizontalPadding(context)),
      child: Column(
        children: [
          // Avatar
          ProfileAvatarWidget(
            avatarUrl: profile.photoUrl,
            name: profile.name,
            size: AppResponsive.isMobile(context) ? 80 : 100,
            isEditable: true,
            onEditPressed: onAvatarEdit,
          ),

          SizedBox(height: AppResponsive.isMobile(context) ? 16 : 20),

          // Nombre
          AutoSizeText(
            profile.name,
            style: AppResponsive.isMobile(context)
                ? AppTextStyles.h3
                : AppTextStyles.h2,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.mail,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AutoSizeText(
                  profile.email,
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.tag, color: AppColors.primary, size: 14),
                const SizedBox(width: 4),
                AutoSizeText(
                  profile.role,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),

          SizedBox(height: AppResponsive.isMobile(context) ? 20 : 24),

          // Botones de acción
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onEditProfile,
                  icon: const Icon(LucideIcons.penLine, size: 16),
                  label: AutoSizeText(
                    'Edit Profile',
                    style: AppTextStyles.buttonSmall,
                    maxLines: 1,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: onSettings,
                  icon: const Icon(LucideIcons.settings, size: 16),
                  label: AutoSizeText(
                    'Settings',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.inputBorder),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
