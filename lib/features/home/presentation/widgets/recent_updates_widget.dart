import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/dashboard_entity.dart';
import '/core/core.dart';

class RecentUpdatesWidget extends StatelessWidget {
  final List<RecentUpdateEntity> updates;

  const RecentUpdatesWidget({super.key, required this.updates});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.bell,
                  color: AppColors.info,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Últimas Actualizaciones', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 16),
          ...updates.take(5).map((update) => _buildUpdateItem(update)).toList(),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(RecentUpdateEntity update) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: update.isImportant
            ? AppColors.warning.withOpacity(0.05)
            : AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: update.isImportant
              ? AppColors.warning.withOpacity(0.2)
              : AppColors.inputBorder.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: _getUpdateTypeColor(update.type),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (update.isImportant) ...[
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.triangleAlert,
                        color: AppColors.warning,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'IMPORTANTE',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Text(update.title, style: AppTextStyles.labelMedium),
                const SizedBox(height: 2),
                Text(
                  update.description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getTimeAgo(update.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getUpdateTypeColor(UpdateType type) {
    switch (type) {
      case UpdateType.general:
        return AppColors.textSecondary;
      case UpdateType.important:
        return AppColors.warning;
      case UpdateType.schedule:
        return AppColors.primary;
      case UpdateType.venue:
        return AppColors.info;
      case UpdateType.catering:
        return AppColors.success;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Hace un momento';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inDays}d';
    }
  }
}
