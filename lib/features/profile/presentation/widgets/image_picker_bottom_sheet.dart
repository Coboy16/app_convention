import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import '/features/profile/domain/usecases/pick_image_usecase.dart';
import '/shared/services/service_locator.dart';
import '/core/core.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final String title;
  final Function(String) onImageSelected;
  final bool enableCrop;

  const ImagePickerBottomSheet({
    super.key,
    required this.title,
    required this.onImageSelected,
    this.enableCrop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTextStyles.h4),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PhotoOption(
                icon: LucideIcons.camera,
                label: 'Cámara',
                onTap: () => _handleCamera(context),
              ),
              _PhotoOption(
                icon: LucideIcons.image,
                label: 'Galería',
                onTap: () => _handleGallery(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _handleCamera(BuildContext context) async {
    Navigator.pop(context);

    try {
      // Verificar y solicitar permisos de cámara
      final cameraPermission = await _requestCameraPermission(context);
      if (!cameraPermission) {
        ToastUtils.showError(
          context: context,
          message: 'Se requiere permiso de cámara para tomar fotos',
        );
        return;
      }

      final pickImageUseCase = sl<PickImageUseCase>();
      final result = await pickImageUseCase.fromCamera();

      result.fold(
        (failure) =>
            ToastUtils.showError(context: context, message: failure.message),
        (imagePath) async {
          if (enableCrop) {
            final cropResult = await pickImageUseCase.cropImage(imagePath);
            cropResult.fold(
              (failure) => ToastUtils.showError(
                context: context,
                message: failure.message,
              ),
              (croppedPath) => onImageSelected(croppedPath),
            );
          } else {
            onImageSelected(imagePath);
          }
        },
      );
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al tomar foto: ${e.toString()}',
      );
    }
  }

  Future<void> _handleGallery(BuildContext context) async {
    Navigator.pop(context);

    try {
      // Verificar y solicitar permisos de galería
      final galleryPermission = await _requestGalleryPermission(context);
      if (!galleryPermission) {
        ToastUtils.showError(
          context: context,
          message: 'Se requiere permiso de galería para seleccionar fotos',
        );
        return;
      }

      final pickImageUseCase = sl<PickImageUseCase>();
      final result = await pickImageUseCase.fromGallery();

      result.fold(
        (failure) =>
            ToastUtils.showError(context: context, message: failure.message),
        (imagePath) async {
          if (enableCrop) {
            final cropResult = await pickImageUseCase.cropImage(imagePath);
            cropResult.fold(
              (failure) => ToastUtils.showError(
                context: context,
                message: failure.message,
              ),
              (croppedPath) => onImageSelected(croppedPath),
            );
          } else {
            onImageSelected(imagePath);
          }
        },
      );
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al seleccionar imagen: ${e.toString()}',
      );
    }
  }

  // Método para solicitar permisos de cámara
  Future<bool> _requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // Mostrar diálogo para abrir configuración
      _showPermissionDialog(
        context,
        'Permiso de Cámara',
        'Para tomar fotos necesitas habilitar el permiso de cámara en la configuración.',
      );
      return false;
    }

    return false;
  }

  // Método para solicitar permisos de galería
  Future<bool> _requestGalleryPermission(BuildContext context) async {
    Permission permission;

    // Usar el permiso correcto según la plataforma
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      permission = Permission.photos;
    } else {
      // Para Android - verificar versión
      permission = Permission.storage;
    }

    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // Mostrar diálogo para abrir configuración
      _showPermissionDialog(
        context,
        'Permiso de Galería',
        'Para seleccionar fotos necesitas habilitar el permiso de galería en la configuración.',
      );
      return false;
    }

    return false;
  }

  // Mostrar diálogo para permisos denegados permanentemente
  void _showPermissionDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.h4),
        content: Text(message, style: AppTextStyles.body2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(
              'Abrir Configuración',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}
