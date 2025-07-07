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
    this.enableCrop = true,
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

    // Verificar permisos
    final cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted) {
      ToastUtils.showError(
        context: context,
        message: 'Se requiere permiso de cámara',
      );
      return;
    }

    try {
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

    // Verificar permisos
    final storagePermission = await Permission.photos.request();
    if (!storagePermission.isGranted) {
      ToastUtils.showError(
        context: context,
        message: 'Se requiere permiso de galería',
      );
      return;
    }

    try {
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
