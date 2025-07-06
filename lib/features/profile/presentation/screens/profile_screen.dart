import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/presentation/screens/screens.dart';
import '/features/profile/presentation/widgets/widgets.dart';
import '/features/profile/presentation/bloc/blocs.dart';
import '/core/core.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ToastUtils.showError(context: context, message: state.message);
        } else if (state is ProfileUpdated) {
          ToastUtils.showSuccess(
            context: context,
            message: 'Profile updated successfully',
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.circleAlert,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text('Error loading profile', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ProfileBloc>().loadProfile();
                  },
                  icon: const Icon(LucideIcons.refreshCw),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ProfileLoaded || state is ProfileUpdating) {
          final profile = state is ProfileLoaded
              ? state.profile
              : (state as ProfileUpdating).profile;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().refreshProfile();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Custom AppBar
                  Container(
                    color: AppColors.surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.horizontalPadding(context),
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Profile', style: AppTextStyles.h4),
                        ),
                        IconButton(
                          onPressed: () {
                            _showEditProfileModal(context, profile);
                          },
                          icon: const Icon(
                            LucideIcons.penLine,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Profile Header
                  ProfileHeaderWidget(
                    profile: profile,
                    onEditProfile: () {
                      _showEditProfileModal(context, profile);
                    },
                    onSettings: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    onAvatarEdit: () {
                      _showAvatarEditModal(context);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Stats
                  ProfileStatsWidget(
                    stats: profile.stats,
                    onPostsTap: () {
                      ToastUtils.showInfo(
                        context: context,
                        message: 'Posts view coming soon...',
                      );
                    },
                    onFollowingTap: () {
                      ToastUtils.showInfo(
                        context: context,
                        message: 'Following list coming soon...',
                      );
                    },
                    onFollowersTap: () {
                      ToastUtils.showInfo(
                        context: context,
                        message: 'Followers list coming soon...',
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Profile Info
                  ProfileInfoWidget(profile: profile),

                  const SizedBox(height: 20),

                  // Posts
                  ProfilePostsWidget(postsCount: profile.stats.posts),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }

        return Center(child: const Text('Error'));
      },
    );
  }

  void _showEditProfileModal(BuildContext context, profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );
  }

  void _showAvatarEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change Profile Picture', style: AppTextStyles.h4),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AvatarOption(
                  icon: LucideIcons.camera,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Camera feature coming soon...',
                    );
                  },
                ),
                _AvatarOption(
                  icon: LucideIcons.image,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Gallery feature coming soon...',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}
