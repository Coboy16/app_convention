import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/data/data.dart';
import '/core/core.dart';

class EventOperationsWidget extends StatelessWidget {
  final List<EventOperation> operations;

  const EventOperationsWidget({super.key, required this.operations});

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
              color: AppColors.warning,
            ),
            const SizedBox(width: 8),
            Text('Operaciones del Evento', style: AppTextStyles.h4),
          ],
        ),
        const SizedBox(height: 16),

        ...operations
            .map(
              (operation) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AutoSizeText(
                            operation.title,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ...operation.details
                        .map(
                          (detail) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  _getIconForOperation(detail.icon),
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                AutoSizeText(
                                  '${detail.title}: ',
                                  style: AppTextStyles.body2.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    detail.value,
                                    style: AppTextStyles.body2,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.zap,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        AutoSizeText(
                          operation.lastUpdate,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  IconData _getIconForOperation(String iconName) {
    switch (iconName) {
      case 'app':
        return LucideIcons.smartphone;
      case 'venue':
        return LucideIcons.building;
      case 'engagement':
        return LucideIcons.chartBar;
      default:
        return LucideIcons.activity;
    }
  }
}
