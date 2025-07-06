import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/data/data.dart';
import '/core/core.dart';

class TodayHighlightsWidget extends StatelessWidget {
  final List<TodayHighlight> highlights;

  const TodayHighlightsWidget({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lo más destacado de hoy', style: AppTextStyles.h4),
        const SizedBox(height: 16),

        Row(
          children: highlights
              .map(
                (highlight) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right:
                          highlights.indexOf(highlight) < highlights.length - 1
                          ? 12
                          : 0,
                    ),
                    child: _HighlightCard(highlight: highlight),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final TodayHighlight highlight;

  const _HighlightCard({required this.highlight});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(highlight.color);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconData(highlight.icon),
              color: AppColors.surface,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          AutoSizeText(
            highlight.title,
            style: AppTextStyles.labelMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            highlight.time,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'microphone':
        return LucideIcons.mic;
      case 'utensils':
        return LucideIcons.utensils;
      case 'users':
        return LucideIcons.users;
      default:
        return LucideIcons.calendar;
    }
  }
}
