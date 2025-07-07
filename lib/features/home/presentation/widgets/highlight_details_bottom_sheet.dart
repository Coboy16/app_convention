import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/dashboard_entity.dart';
import '/core/core.dart';

class HighlightDetailsBottomSheet extends StatelessWidget {
  final TodayHighlightEntity highlight;

  const HighlightDetailsBottomSheet({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title and icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor(highlight.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(highlight.type),
                  color: _getTypeColor(highlight.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(highlight.title, style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text(
                      _getTypeLabel(highlight.type),
                      style: AppTextStyles.caption.copyWith(
                        color: _getTypeColor(highlight.type),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Time info
          _buildInfoRow(
            icon: LucideIcons.clock,
            label: 'Horario',
            value: '${highlight.time} (${_formatDuration()})',
          ),

          const SizedBox(height: 16),

          // Location info
          _buildInfoRow(
            icon: LucideIcons.mapPin,
            label: 'Ubicación',
            value: highlight.location,
          ),

          const SizedBox(height: 24),

          // Description
          Text('Descripción', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Text(
            highlight.description,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 32),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Entendido'),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(child: Text(value, style: AppTextStyles.body2)),
      ],
    );
  }

  String _formatDuration() {
    final duration = highlight.endTime.difference(highlight.startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    } else {
      return '${minutes}m';
    }
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

  String _getTypeLabel(HighlightType type) {
    switch (type) {
      case HighlightType.session:
        return 'SESIÓN';
      case HighlightType.breaki:
        return 'DESCANSO';
      case HighlightType.networking:
        return 'NETWORKING';
      case HighlightType.workshop:
        return 'TALLER';
      case HighlightType.keynote:
        return 'KEYNOTE';
    }
  }
}
