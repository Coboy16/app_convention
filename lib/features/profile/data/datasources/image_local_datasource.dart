import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '/core/errors/exceptions.dart';

abstract class ImageLocalDataSource {
  Future<String> pickImageFromGallery();
  Future<String> pickImageFromCamera();
  Future<String> cropImage(String imagePath);
}

class ImageLocalDataSourceImpl implements ImageLocalDataSource {
  final ImagePicker imagePicker;

  ImageLocalDataSourceImpl({required this.imagePicker});

  @override
  Future<String> pickImageFromGallery() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );

      if (image == null) {
        throw const CacheException('No se seleccionó ninguna imagen');
      }

      return image.path;
    } catch (e) {
      throw CacheException('Error al seleccionar imagen: ${e.toString()}');
    }
  }

  @override
  Future<String> pickImageFromCamera() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );

      if (image == null) {
        throw const CacheException('No se tomó ninguna foto');
      }

      return image.path;
    } catch (e) {
      throw CacheException('Error al tomar foto: ${e.toString()}');
    }
  }

  @override
  Future<String> cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Imagen',
            toolbarColor: const Color(0xFF2196F3),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Recortar Imagen',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) {
        throw const CacheException('Recorte cancelado');
      }

      return croppedFile.path;
    } catch (e) {
      throw CacheException('Error al recortar imagen: ${e.toString()}');
    }
  }
}
