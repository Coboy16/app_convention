import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/features/profile/data/data.dart';
import '/core/core.dart';

class ProfileStatsWidget extends StatelessWidget {
  final ProfileStats stats;
  final VoidCallback? onPostsTap;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onFollowersTap;

  const ProfileStatsWidget({
    super.key,
    required this.stats,
    this.onPostsTap,
    this.onFollowingTap,
    this.onFollowersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.horizontalPadding(context),
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: stats.posts, label: 'Posts', onTap: onPostsTap),
          _VerticalDivider(),
          _StatItem(
            value: stats.following,
            label: 'Following',
            onTap: onFollowingTap,
          ),
          _VerticalDivider(),
          _StatItem(
            value: stats.followers,
            label: 'Followers',
            onTap: onFollowersTap,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final VoidCallback? onTap;

  const _StatItem({required this.value, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                value.toString(),
                style: AppResponsive.isMobile(context)
                    ? AppTextStyles.h3
                    : AppTextStyles.h2,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              AutoSizeText(
                label,
                style: AppResponsive.isMobile(context)
                    ? AppTextStyles.body2
                    : AppTextStyles.body1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.inputBorder,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
