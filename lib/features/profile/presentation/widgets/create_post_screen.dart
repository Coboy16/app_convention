import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:io';

import '/features/profile/presentation/widgets/widgets.dart';
import '/shared/bloc/blocs.dart';

import '/core/core.dart';

class CreatePostScreen extends StatefulWidget {
  final String userId;

  const CreatePostScreen({super.key, required this.userId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _descriptionController = TextEditingController();
  final List<String> _selectedImages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state is PostsLoaded) {
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showSuccess(
                context: context,
                message: 'Post creado exitosamente',
              );
              Navigator.pop(context);
            } else if (state is PostsError) {
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showError(context: context, message: state.message);
            } else if (state is PostCreating) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          child: Column(
            children: [
              // Custom AppBar
              Container(
                color: AppColors.surface,
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.horizontalPadding(context),
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Cancel button
                    TextButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(
                        LucideIcons.x,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      label: Text(
                        'Cancelar',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // Title
                    Expanded(
                      child: Text(
                        'Nuevo Post',
                        style: AppTextStyles.h4,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Post button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedImages.isNotEmpty && !_isLoading
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: _selectedImages.isNotEmpty && !_isLoading
                            ? _handleCreatePost
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        child: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.surface,
                                  ),
                                ),
                              )
                            : Text(
                                'Publicar',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    AppResponsive.horizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: '¿Qué quieres compartir?',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Images section
                      Text('Imágenes', style: AppTextStyles.h4),
                      const SizedBox(height: 16),

                      // Selected images grid
                      if (_selectedImages.isNotEmpty) ...[
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                          itemCount: _selectedImages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _selectedImages.length) {
                              return _buildAddImageButton();
                            }
                            return _buildImageItem(index);
                          },
                        ),
                      ] else ...[
                        _buildAddImageButton(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(_selectedImages[index])),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImages.removeAt(index);
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.x,
                color: AppColors.surface,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _showImagePickerModal,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.inputBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus, color: AppColors.primary, size: 32),
            SizedBox(height: 8),
            Text(
              'Agregar\nImagen',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Agregar Imagen',
        onImageSelected: (imagePath) {
          setState(() {
            _selectedImages.add(imagePath);
          });
        },
      ),
    );
  }

  void _handleCreatePost() {
    if (_selectedImages.isEmpty) {
      ToastUtils.showError(
        context: context,
        message: 'Debes agregar al menos una imagen',
      );
      return;
    }

    context.read<PostsBloc>().add(
      PostCreateRequested(
        userId: widget.userId,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        imagePaths: _selectedImages,
      ),
    );
  }
}
