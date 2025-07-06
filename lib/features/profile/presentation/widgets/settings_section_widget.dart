import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/core/core.dart';

class SettingsSectionWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              AutoSizeText(title, style: AppTextStyles.h4, maxLines: 1),
            ],
          ),
        ),

        // Section Content
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: Column(children: _buildChildren()),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> widgets = [];

    for (int i = 0; i < children.length; i++) {
      widgets.add(children[i]);

      // Add divider between items (except for the last one)
      if (i < children.length - 1) {
        widgets.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.inputBorder,
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }

    return widgets;
  }
}
