import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/data/data.dart';
import '/core/core.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<RecentActivity> activities;
  final String? title;

  const RecentActivityWidget({super.key, required this.activities, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.activity,
              size: 16,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(title ?? 'Actividad Reciente', style: AppTextStyles.h4),
          ],
        ),
        const SizedBox(height: 16),

        ...activities
            .map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: _getActivityColor(activity.type),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            activity.description,
                            style: AppTextStyles.body2,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 2),
                          AutoSizeText(
                            _getTimeAgo(activity.timestamp),
                            style: AppTextStyles.caption,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.post:
        return AppColors.primary;
      case ActivityType.like:
        return AppColors.warning;
      case ActivityType.update:
        return AppColors.error;
      case ActivityType.new_event:
        return AppColors.warning;
      case ActivityType.announcement:
        return AppColors.success;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Hace ${difference.inSeconds} segundos';
    } else if (difference.inHours < 1) {
      return 'hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    }
  }
}
