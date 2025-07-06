import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../theme/app_colors.dart';

enum ToastType { success, error, warning, info }

class ToastUtils {
  static void show({
    required BuildContext context,
    required String message,
    required ToastType type,
    String? title,
    Duration? duration,
    Alignment? alignment,
  }) {
    final toastType = _getToastificationType(type);
    final colors = _getToastColors(type);

    toastification.show(
      context: context,
      type: toastType,
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: alignment ?? Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(8),
      showProgressBar: true,
      dragToClose: true,
      pauseOnHover: true,
      primaryColor: colors.primary,
      backgroundColor: colors.background,
      foregroundColor: colors.foreground,
      icon: _getToastIcon(type),
      showIcon: true,
      applyBlurEffect: false,
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.success,
      title: title,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.error,
      title: title,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.warning,
      title: title,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? title,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.info,
      title: title,
      duration: duration,
    );
  }

  static ToastificationType _getToastificationType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.info:
        return ToastificationType.info;
    }
  }

  static _ToastColors _getToastColors(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastColors(
          primary: AppColors.success,
          background: AppColors.success.withOpacity(0.1),
          foreground: AppColors.success,
        );
      case ToastType.error:
        return _ToastColors(
          primary: AppColors.error,
          background: AppColors.error.withOpacity(0.1),
          foreground: AppColors.error,
        );
      case ToastType.warning:
        return _ToastColors(
          primary: AppColors.warning,
          background: AppColors.warning.withOpacity(0.1),
          foreground: AppColors.warning,
        );
      case ToastType.info:
        return _ToastColors(
          primary: AppColors.info,
          background: AppColors.info.withOpacity(0.1),
          foreground: AppColors.info,
        );
    }
  }

  static Widget? _getToastIcon(ToastType type) {
    IconData iconData;
    switch (type) {
      case ToastType.success:
        iconData = Icons.check_circle;
        break;
      case ToastType.error:
        iconData = Icons.error;
        break;
      case ToastType.warning:
        iconData = Icons.warning;
        break;
      case ToastType.info:
        iconData = Icons.info;
        break;
    }

    return Icon(iconData, size: 24, color: _getToastColors(type).foreground);
  }
}

class _ToastColors {
  final Color primary;
  final Color background;
  final Color foreground;

  _ToastColors({
    required this.primary,
    required this.background,
    required this.foreground,
  });
}
