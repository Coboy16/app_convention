import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:dotted_border/dotted_border.dart';

import '/features/posts/presentation/widgets/widgets.dart';
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

    try {
      // Simular creación de post
      await Future.delayed(const Duration(seconds: 2));

      ToastUtils.showSuccess(
        context: context,
        message: 'Post creado exitosamente',
      );

      Navigator.pop(context);
    } catch (e) {
      ToastUtils.showError(context: context, message: 'Error al crear el post');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = _postController.text.length;
    final maxCharacters = 500;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                    onPressed: () => Navigator.pop(context),
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
                            Text('John Doe', style: AppTextStyles.labelMedium),
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
                    _PhotoSection(),

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
    );
  }
}

class _PhotoSection extends StatelessWidget {
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
            Text('Agregar Foto (Opcional)', style: AppTextStyles.labelMedium),
          ],
        ),
        const SizedBox(height: 12),

        // Photo placeholder with dotted border
        DottedBorder(
          options: RectDottedBorderOptions(
            color: AppColors.inputBorder,
            strokeWidth: 2,
            dashPattern: const [6, 3],
          ),
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
                  'Toca para agregar foto',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Camera and Gallery buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ToastUtils.showInfo(
                    context: context,
                    message: 'Función de cámara próximamente...',
                  );
                },
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
                onPressed: () {
                  ToastUtils.showInfo(
                    context: context,
                    message: 'Función de galería próximamente...',
                  );
                },
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
