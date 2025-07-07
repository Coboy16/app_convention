import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

import '/features/posts/presentation/widgets/widgets.dart';
import '/features/posts/presentation/bloc/blocs.dart';
import '/features/profile/presentation/widgets/image_picker_bottom_sheet.dart';
import '/core/core.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postController = TextEditingController();
  final _customTagController = TextEditingController();

  bool _enableComments = true;
  bool _notifyFollowers = false;
  bool _isLoading = false;
  bool _showCustomTagInput = false;

  final List<String> _predefinedTags = [
    '#Convention2024',
    '#Networking',
    '#Innovation',
    '#Learning',
    '#Day2',
    '#Inspiring',
  ];

  final List<String> _selectedTags = [];
  final List<String> _customTags = [];
  final List<String> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _postController.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    _postController.removeListener(_updateCharacterCount);
    _postController.dispose();
    _customTagController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {});
  }

  void _addCustomTag() {
    final customTag = _customTagController.text.trim();
    if (customTag.isNotEmpty) {
      final formattedTag = customTag.startsWith('#')
          ? customTag
          : '#$customTag';
      setState(() {
        _customTags.add(formattedTag);
        _selectedTags.add(formattedTag);
        _customTagController.clear();
        _showCustomTagInput = false;
      });
    }
  }

  void _createPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) {
      ToastUtils.showError(
        context: context,
        message: 'Por favor escribe algo para publicar',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Usar el BLoC para crear el post
    context.read<FeedPostsBloc>().createPost(
      content,
      _selectedImages,
      _selectedTags,
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = _postController.text.length;
    final maxCharacters = 500;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<FeedPostsBloc, FeedPostsState>(
          // CAMBIADO
          listener: (context, state) {
            if (state is FeedPostsLoaded) {
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showSuccess(
                context: context,
                message: 'Post creado exitosamente',
              );
              Navigator.pop(context);
            } else if (state is FeedPostsError) {
              // CAMBIADO
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showError(context: context, message: state.message);
            } else if (state is FeedPostCreating) {
              // CAMBIADO
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
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        color: _isLoading
                            ? AppColors.textTertiary
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: _isLoading ? null : _createPost,
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
                      const SizedBox(height: 16),

                      // User Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.surfaceVariant,
                            child: Text(
                              'JD',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Doe',
                                style: AppTextStyles.labelMedium,
                              ),
                              Text(
                                'Publicando como Participante',
                                style: AppTextStyles.caption,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.mapPin,
                                    size: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Lima Convention Center',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Post Content Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.messageSquare,
                                size: 16,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '¿Qué está pasando en la convención?',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _postController,
                            maxLines: 6,
                            maxLength: maxCharacters,
                            decoration: InputDecoration(
                              hintText:
                                  'Comparte tus pensamientos, actualizaciones o experiencias del evento...',
                              hintStyle: AppTextStyles.body2.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            style: AppTextStyles.body1,
                          ),

                          // Character Count
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Caracteres: $characterCount/$maxCharacters',
                                style: AppTextStyles.caption.copyWith(
                                  color: characterCount > maxCharacters * 0.9
                                      ? AppColors.warning
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Add Photo Section
                      _PhotoSection(
                        selectedImages: _selectedImages,
                        onImageSelected: (imagePath) {
                          setState(() {
                            _selectedImages.add(imagePath);
                          });
                        },
                        onImageRemoved: (index) {
                          setState(() {
                            _selectedImages.removeAt(index);
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Post Options
                      _PostOptionsSection(
                        enableComments: _enableComments,
                        notifyFollowers: _notifyFollowers,
                        onCommentsChanged: (value) =>
                            setState(() => _enableComments = value),
                        onNotifyChanged: (value) =>
                            setState(() => _notifyFollowers = value),
                      ),

                      const SizedBox(height: 24),

                      // Quick Tags
                      QuickTagsWidget(
                        predefinedTags: _predefinedTags,
                        customTags: _customTags,
                        selectedTags: _selectedTags,
                        showCustomInput: _showCustomTagInput,
                        customTagController: _customTagController,
                        onTagSelected: (tag) {
                          setState(() {
                            if (_selectedTags.contains(tag)) {
                              _selectedTags.remove(tag);
                            } else {
                              _selectedTags.add(tag);
                            }
                          });
                        },
                        onCustomPressed: () {
                          setState(() {
                            _showCustomTagInput = !_showCustomTagInput;
                          });
                        },
                        onCustomTagAdded: _addCustomTag,
                      ),

                      const SizedBox(height: 24),
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
}

class _PhotoSection extends StatelessWidget {
  final List<String> selectedImages;
  final Function(String) onImageSelected;
  final Function(int) onImageRemoved;

  const _PhotoSection({
    required this.selectedImages,
    required this.onImageSelected,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.camera,
              size: 16,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text('Agregar Fotos (Opcional)', style: AppTextStyles.labelMedium),
          ],
        ),
        const SizedBox(height: 12),

        // Selected images grid
        if (selectedImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == selectedImages.length) {
                return _buildAddImageButton(context);
              }
              return _buildImageItem(index);
            },
          ),
        ] else ...[
          // Empty state
          DottedBorder(
            options: RectDottedBorderOptions(
              color: AppColors.inputBorder,
              strokeWidth: 2,
              dashPattern: const [6, 3],
            ),
            child: InkWell(
              onTap: () => _showImagePicker(context),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.camera,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toca para agregar fotos',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Camera and Gallery buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showImagePicker(context),
                icon: const Icon(LucideIcons.camera, size: 18),
                label: const Text('Desde Cámara'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showImagePicker(context),
                icon: const Icon(LucideIcons.image, size: 18),
                label: const Text('Desde Galería'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(selectedImages[index])),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onImageRemoved(index),
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

  Widget _buildAddImageButton(BuildContext context) {
    return InkWell(
      onTap: () => _showImagePicker(context),
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

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Agregar Imagen',
        onImageSelected: onImageSelected,
      ),
    );
  }
}

class _PostOptionsSection extends StatelessWidget {
  final bool enableComments;
  final bool notifyFollowers;
  final ValueChanged<bool> onCommentsChanged;
  final ValueChanged<bool> onNotifyChanged;

  const _PostOptionsSection({
    required this.enableComments,
    required this.notifyFollowers,
    required this.onCommentsChanged,
    required this.onNotifyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.settings, size: 16, color: AppColors.error),
            const SizedBox(width: 8),
            Text('Opciones del Post', style: AppTextStyles.labelMedium),
          ],
        ),
        const SizedBox(height: 16),

        // Enable Comments
        Row(
          children: [
            const Icon(
              LucideIcons.messageCircle,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Habilitar Comentarios', style: AppTextStyles.body2),
                  Text(
                    'Permitir que otros comenten',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Switch(
              value: enableComments,
              onChanged: onCommentsChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Notify Followers
        Row(
          children: [
            const Icon(
              LucideIcons.bell,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notificar Seguidores', style: AppTextStyles.body2),
                  Text(
                    'Enviar notificación a tus seguidores',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Switch(
              value: notifyFollowers,
              onChanged: onNotifyChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
