import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/core/core.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int postsCount;
  final VoidCallback? onPostsTap;

  const ProfileStatsWidget({
    super.key,
    required this.postsCount,
    this.onPostsTap,
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
          _StatItem(value: postsCount, label: 'Posts', onTap: onPostsTap),
          _VerticalDivider(),
          _StatItem(value: 0, label: 'Siguiendo', onTap: () {}),
          _VerticalDivider(),
          _StatItem(value: 0, label: 'Seguidores', onTap: () {}),
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
