import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/core.dart';

class ProfilePostsWidget extends StatelessWidget {
  final int postsCount;

  const ProfilePostsWidget({super.key, required this.postsCount});

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
          // Posts header
          Row(
            children: [
              const Icon(
                LucideIcons.grid3x3,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              AutoSizeText('Posts', style: AppTextStyles.h4, maxLines: 1),
            ],
          ),

          // Posts grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 6, // Mock 6 posts
            itemBuilder: (context, index) {
              return _PostItem(index: index);
            },
          ),
        ],
      ),
    );
  }
}

class _PostItem extends StatelessWidget {
  final int index;

  const _PostItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: const Center(
        child: Icon(LucideIcons.image, color: AppColors.textTertiary, size: 24),
      ),
    );
  }
}
