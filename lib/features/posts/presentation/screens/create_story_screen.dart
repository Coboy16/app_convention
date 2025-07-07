import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:io';

import '/features/profile/presentation/widgets/image_picker_bottom_sheet.dart';
import '/features/posts/presentation/bloc/blocs.dart';
import '/core/core.dart';

class CreateStoryScreen extends StatefulWidget {
  final bool isCamera;

  const CreateStoryScreen({super.key, required this.isCamera});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _captionController = TextEditingController();
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // CAMBIADO: Usar WidgetsBinding para esperar a que el widget esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage();
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // CAMBIADO: Permitir cerrar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: widget.isCamera ? 'Tomar Foto' : 'Seleccionar Imagen',
        onImageSelected: (imagePath) {
          setState(() {
            _selectedImagePath = imagePath;
          });
        },
      ),
    );
  }

  void _createStory() {
    if (_selectedImagePath == null) {
      ToastUtils.showError(
        context: context,
        message: 'Debes seleccionar una imagen',
      );
      return;
    }

    final caption = _captionController.text.trim();
    if (caption.isEmpty) {
      ToastUtils.showError(
        context: context,
        message: 'Agrega una descripción a tu historia',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    context.read<FeedPostsBloc>().createStory(_selectedImagePath!, caption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<FeedPostsBloc, FeedPostsState>(
        listener: (context, state) {
          if (state is FeedStoryCreated) {
            setState(() {
              _isLoading = false;
            });
            ToastUtils.showSuccess(
              context: context,
              message: 'Historia creada exitosamente',
            );
            Navigator.pop(context);
          } else if (state is FeedPostsError) {
            setState(() {
              _isLoading = false;
            });
            ToastUtils.showError(context: context, message: state.message);
          } else if (state is FeedStoryCreating) {
            setState(() {
              _isLoading = true;
            });
          }
        },
        child: SafeArea(
          child: _selectedImagePath == null
              ? _buildImagePicker()
              : _buildStoryEditor(),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.camera, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            'Selecciona una imagen para tu historia',
            style: AppTextStyles.body1.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(LucideIcons.image),
            label: const Text('Seleccionar Imagen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body2.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryEditor() {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.file(
            File(_selectedImagePath!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(
                    LucideIcons.imageOff,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              );
            },
          ),
        ),

        // Dark overlay for better text visibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
        ),

        // Top bar
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, color: Colors.white, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  shape: const CircleBorder(),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Nueva Historia',
                  style: AppTextStyles.h4.copyWith(color: Colors.white),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _pickImage,
                icon: const Icon(
                  LucideIcons.image,
                  color: Colors.white,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),

        // Bottom section with caption input
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Caption input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _captionController,
                      style: AppTextStyles.body2.copyWith(color: Colors.white),
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Agrega una descripción...',
                        hintStyle: AppTextStyles.body2.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Share button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createStory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Compartir Historia'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
