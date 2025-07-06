import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/core/core.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final Color? color;
  final double? thickness;
  final EdgeInsets? padding;

  const CustomDivider({
    super.key,
    required this.text,
    this.color,
    this.thickness,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: color ?? AppColors.inputBorder,
              thickness: thickness ?? 1,
              height: 1,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AutoSizeText(
              text,
              style: AppTextStyles.body2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            child: Divider(
              color: color ?? AppColors.inputBorder,
              thickness: thickness ?? 1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
