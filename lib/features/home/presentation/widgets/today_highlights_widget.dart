import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/dashboard_entity.dart';
import '/core/core.dart';

class TodayHighlightsWidget extends StatelessWidget {
  final List<TodayHighlightEntity> highlights;
  final Function(TodayHighlightEntity)? onHighlightTap;

  const TodayHighlightsWidget({
    super.key,
    required this.highlights,
    this.onHighlightTap,
  });

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
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.star,
                  color: AppColors.warning,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Lo Más Destacado de Hoy', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 16),
          ...highlights
              .take(3)
              .map((highlight) => _buildHighlightItem(highlight))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(TodayHighlightEntity highlight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onHighlightTap?.call(highlight),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(highlight.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(highlight.type),
                  color: _getTypeColor(highlight.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(highlight.title, style: AppTextStyles.labelMedium),
                    const SizedBox(height: 2),
                    Text(
                      highlight.time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                color: AppColors.textTertiary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(HighlightType type) {
    switch (type) {
      case HighlightType.session:
        return AppColors.primary;
      case HighlightType.breaki:
        return AppColors.success;
      case HighlightType.networking:
        return AppColors.info;
      case HighlightType.workshop:
        return AppColors.warning;
      case HighlightType.keynote:
        return AppColors.error;
    }
  }

  IconData _getTypeIcon(HighlightType type) {
    switch (type) {
      case HighlightType.session:
        return LucideIcons.presentation;
      case HighlightType.breaki:
        return LucideIcons.coffee;
      case HighlightType.networking:
        return LucideIcons.users;
      case HighlightType.workshop:
        return LucideIcons.wrench;
      case HighlightType.keynote:
        return LucideIcons.mic;
    }
  }
}
