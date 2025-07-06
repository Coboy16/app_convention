import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import '/core/core.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Widget? icon;
  final IconData? iconData;
  final double? iconSize;
  final bool iconOnRight;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.padding,
    this.icon,
    this.iconData,
    this.iconSize,
    this.iconOnRight = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: _getButtonStyle(context, isEnabled),
        child: isLoading
            ? _buildLoadingIndicator()
            : _buildButtonContent(context),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context, bool isEnabled) {
    final colors = _getButtonColors(isEnabled);

    return ElevatedButton.styleFrom(
      backgroundColor: colors.backgroundColor,
      foregroundColor: colors.textColor,
      elevation: elevation ?? _getElevation(),
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        side: colors.borderSide,
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: textStyle ?? AppTextStyles.button,
    );
  }

  _ButtonColors _getButtonColors(bool isEnabled) {
    switch (type) {
      case ButtonType.primary:
        return _ButtonColors(
          backgroundColor:
              backgroundColor ??
              (isEnabled ? AppColors.primary : AppColors.textTertiary),
          textColor: textColor ?? AppColors.surface,
          borderSide: BorderSide.none,
        );

      case ButtonType.secondary:
        return _ButtonColors(
          backgroundColor:
              backgroundColor ??
              (isEnabled ? AppColors.surfaceVariant : AppColors.surfaceVariant),
          textColor:
              textColor ??
              (isEnabled ? AppColors.textPrimary : AppColors.textTertiary),
          borderSide: BorderSide.none,
        );

      case ButtonType.outline:
        return _ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor:
              textColor ??
              (isEnabled ? AppColors.primary : AppColors.textTertiary),
          borderSide: BorderSide(
            color:
                borderColor ??
                (isEnabled ? AppColors.primary : AppColors.textTertiary),
            width: 1,
          ),
        );

      case ButtonType.text:
        return _ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor:
              textColor ??
              (isEnabled ? AppColors.primary : AppColors.textTertiary),
          borderSide: BorderSide.none,
        );
    }
  }

  double _getElevation() {
    switch (type) {
      case ButtonType.primary:
        return 2;
      case ButtonType.secondary:
        return 1;
      case ButtonType.outline:
      case ButtonType.text:
        return 0;
    }
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          type == ButtonType.primary ? AppColors.surface : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final Widget textWidget = AutoSizeText(
      text,
      style:
          textStyle ??
          AppTextStyles.button.copyWith(
            color: _getButtonColors(onPressed != null).textColor,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (icon != null || iconData != null) {
      final Widget iconWidget =
          icon ??
          Icon(
            iconData,
            size: iconSize ?? 20,
            color: _getButtonColors(onPressed != null).textColor,
          );

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!iconOnRight) ...[iconWidget, const SizedBox(width: 8)],
          Flexible(child: textWidget),
          if (iconOnRight) ...[const SizedBox(width: 8), iconWidget],
        ],
      );
    }

    return textWidget;
  }
}

class _ButtonColors {
  final Color backgroundColor;
  final Color textColor;
  final BorderSide borderSide;

  _ButtonColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderSide,
  });
}
