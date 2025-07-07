import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/profile/presentation/bloc/blocs.dart';
import 'package:konecta/features/profile/presentation/widgets/widgets.dart';
import 'package:konecta/features/profile/presentation/screens/image_viewer_screen.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/widgets/widgets.dart';
import '/core/core.dart';

class EditProfileFormWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final List<String> selectedAllergies;
  final Function(List<String>) onAllergiesChanged;
  final String userRole;
  final String userId;
  final List<String> tempPostImages;
  final Function(String) onAddTempImage;
  final Function(int) onRemoveTempImage;

  const EditProfileFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.bioController,
    required this.selectedAllergies,
    required this.onAllergiesChanged,
    required this.userRole,
    required this.userId,
    required this.tempPostImages,
    required this.onAddTempImage,
    required this.onRemoveTempImage,
  });

  @override
  State<EditProfileFormWidget> createState() => _EditProfileFormWidgetState();

  // FIXED: Método estático para acceder al estado desde afuera
  static _EditProfileFormWidgetState? of(BuildContext context) {
    return context.findAncestorStateOfType<_EditProfileFormWidgetState>();
  }
}

class _EditProfileFormWidgetState extends State<EditProfileFormWidget> {
  final List<String> _availableAllergies = [
    'Nueces',
    'Mariscos',
    'Lácteos',
    'Huevos',
    'Gluten',
    'Soja',
    'Pescado',
    'Maní',
    'Sesamo',
    'Sulfitos',
  ];

  // FIXED: Lista para trackear posts a eliminar
  final Set<String> _postsToDelete = {};

  // FIXED: Getter público para obtener posts marcados para eliminar
  Set<String> get postsToDelete => _postsToDelete;

  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(PostsLoadRequested(userId: widget.userId));
    debugPrint('🔄 Cargando posts del usuario: ${widget.userId}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _SectionHeader(
                  icon: LucideIcons.pencilLine,
                  title: 'Información Básica',
                ),
                const SizedBox(height: 16),

                // Name Field
                CustomTextField(
                  label: 'Nombre',
                  hintText: 'Ingresa tu nombre completo',
                  controller: widget.nameController,
                  isRequired: true,
                  validator: FormValidators.validateName,
                  prefixIcon: const Icon(
                    LucideIcons.user,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 16),

                // Email Field (read-only)
                CustomTextField(
                  label: 'Email (solo lectura)',
                  hintText: 'Dirección de correo',
                  controller: widget.emailController,
                  enabled: false,
                  prefixIcon: Icon(
                    LucideIcons.mail,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 16),

                // Role Field (read-only)
                CustomTextField(
                  label: 'Rol (solo lectura)',
                  hintText: 'Tu rol en la aplicación',
                  controller: TextEditingController(
                    text: widget.userRole == 'organizer'
                        ? 'Organizador'
                        : 'Participante',
                  ),
                  enabled: false,
                  prefixIcon: Icon(
                    widget.userRole == 'organizer'
                        ? LucideIcons.crown
                        : LucideIcons.user,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // About You Section
                _SectionHeader(
                  icon: LucideIcons.messageSquare,
                  title: 'Acerca de Ti',
                ),

                const SizedBox(height: 16),

                // Bio Field
                _BioTextField(controller: widget.bioController),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Allergies Section
                _SectionHeader(
                  icon: LucideIcons.triangleAlert,
                  title: 'Alergias',
                ),

                const SizedBox(height: 16),
                // Allergies Selection
                _AllergiesSelection(
                  availableAllergies: _availableAllergies,
                  selectedAllergies: widget.selectedAllergies,
                  onChanged: widget.onAllergiesChanged,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Your Posts Section
        _SectionHeader(icon: LucideIcons.camera, title: 'Tus Posts'),

        const SizedBox(height: 16),

        // Posts management section
        _PostsManagementSection(
          userId: widget.userId,
          tempImages: widget.tempPostImages,
          onAddImage: widget.onAddTempImage,
          onRemoveImage: widget.onRemoveTempImage,
          postsToDelete: _postsToDelete,
          onMarkForDeletion: (postId) {
            setState(() {
              if (_postsToDelete.contains(postId)) {
                _postsToDelete.remove(postId);
              } else {
                _postsToDelete.add(postId);
              }
            });
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // FIXED: Getter para obtener posts marcados para eliminar
  // Set<String> get postsToDelete => _postsToDelete;
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [AutoSizeText(title, style: AppTextStyles.h4, maxLines: 1)],
    );
  }
}

class _BioTextField extends StatefulWidget {
  final TextEditingController controller;

  const _BioTextField({required this.controller});

  @override
  State<_BioTextField> createState() => _BioTextFieldState();
}

class _BioTextFieldState extends State<_BioTextField> {
  final int maxLength = 500;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentLength = widget.controller.text.length;
    final remainingLength = maxLength - currentLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Biografía',
          hintText: 'Cuéntanos sobre ti...',
          controller: widget.controller,
          maxLines: 4,
          validator: (value) {
            if (value != null && value.length > maxLength) {
              return 'La biografía no puede exceder $maxLength caracteres';
            }
            return null;
          },
        ),

        const SizedBox(height: 8),

        // Character count
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AutoSizeText(
              '$currentLength/$maxLength caracteres',
              style: AppTextStyles.caption.copyWith(
                color: remainingLength < 50
                    ? AppColors.warning
                    : remainingLength < 0
                    ? AppColors.error
                    : AppColors.textSecondary,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}

class _AllergiesSelection extends StatelessWidget {
  final List<String> availableAllergies;
  final List<String> selectedAllergies;
  final Function(List<String>) onChanged;

  const _AllergiesSelection({
    required this.availableAllergies,
    required this.selectedAllergies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tus alergias alimentarias:',
          style: AppTextStyles.body2,
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableAllergies.map((allergy) {
            final isSelected = selectedAllergies.contains(allergy);

            return FilterChip(
              label: Text(allergy),
              selected: isSelected,
              onSelected: (selected) {
                final updatedAllergies = List<String>.from(selectedAllergies);
                if (selected) {
                  updatedAllergies.add(allergy);
                } else {
                  updatedAllergies.remove(allergy);
                }
                onChanged(updatedAllergies);
              },
              selectedColor: AppColors.primaryDark.withOpacity(0.2),
              checkmarkColor: AppColors.primaryDark,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.grey.shade700
                    : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.inputBorder,
                width: 1,
              ),
            );
          }).toList(),
        ),

        if (selectedAllergies.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.info,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta información será utilizada para personalizar las opciones de catering en los eventos.',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// FIXED: Posts Management Section con eliminación
class _PostsManagementSection extends StatelessWidget {
  final String userId;
  final List<String> tempImages;
  final Function(String) onAddImage;
  final Function(int) onRemoveImage;
  final Set<String> postsToDelete;
  final Function(String) onMarkForDeletion;

  const _PostsManagementSection({
    required this.userId,
    required this.tempImages,
    required this.onAddImage,
    required this.onRemoveImage,
    required this.postsToDelete,
    required this.onMarkForDeletion,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current posts count
            if (state is PostsLoaded) ...[
              Text(
                'Posts actuales: ${state.posts.length}',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Posts grid - FIXED: Solo mostrar posts existentes y temporales
            _buildPostsContent(context, state),

            const SizedBox(height: 16),

            // Add image button
            _buildAddImageButton(context),

            if (tempImages.isNotEmpty || postsToDelete.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoMessage(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPostsContent(BuildContext context, PostsState state) {
    List<Widget> items = [];

    // Agregar posts existentes
    if (state is PostsLoaded) {
      for (final post in state.posts) {
        if (post.imageUrls.isNotEmpty) {
          items.add(_buildExistingPostItem(context, post));
        }
      }
    }

    // Agregar imágenes temporales
    for (int i = 0; i < tempImages.length; i++) {
      items.add(_buildTempImageItem(context, i));
    }

    // FIXED: Si no hay items, mostrar mensaje
    if (items.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: const Center(
          child: Text(
            'No tienes posts aún',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ),
      );
    }

    // FIXED: Grid dinámico basado en el contenido real
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children: items,
    );
  }

  Widget _buildExistingPostItem(BuildContext context, post) {
    final isMarkedForDeletion = postsToDelete.contains(post.id);

    return Stack(
      children: [
        // Post image with tap to view
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewerScreen(
                  imageUrls: post.imageUrls,
                  initialIndex: 0,
                  heroTag: 'edit_post_${post.id}',
                ),
              ),
            );
          },
          child: Hero(
            tag: 'edit_post_${post.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isMarkedForDeletion
                      ? AppColors.error
                      : AppColors.inputBorder,
                  width: isMarkedForDeletion ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Image.network(
                      post.imageUrls.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: Icon(
                            LucideIcons.imageOff,
                            color: AppColors.textTertiary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    // Overlay when marked for deletion
                    if (isMarkedForDeletion)
                      Container(
                        color: AppColors.error.withOpacity(0.3),
                        child: const Center(
                          child: Icon(
                            LucideIcons.trash2,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Delete button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _showDeleteConfirmation(context, post.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isMarkedForDeletion
                    ? AppColors.success
                    : AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isMarkedForDeletion ? LucideIcons.undo2 : LucideIcons.x,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),

        // Multiple images indicator
        if (post.imageUrls.length > 1)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.layers, color: Colors.white, size: 8),
                  const SizedBox(width: 2),
                  Text(
                    '${post.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTempImageItem(BuildContext context, int index) {
    return Stack(
      children: [
        // Temp image with tap to view
        GestureDetector(
          onTap: () {
            // Para imágenes temporales, mostrar en PhotoView sin hero
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewerScreen(
                  imageUrls: [tempImages[index]],
                  initialIndex: 0,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary, width: 2),
              image: DecorationImage(
                image: FileImage(File(tempImages[index])),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {
                  debugPrint('❌ Error al cargar imagen temporal: $error');
                },
              ),
            ),
          ),
        ),

        // Remove button for temp image
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveImage(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.x, color: Colors.white, size: 14),
            ),
          ),
        ),

        // "Nueva" badge
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Nueva',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.inputBorder,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Agregar Nueva Imagen',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoMessage() {
    List<String> messages = [];

    if (tempImages.isNotEmpty) {
      messages.add(
        '${tempImages.length} imagen${tempImages.length > 1 ? 'es' : ''} nueva${tempImages.length > 1 ? 's' : ''} se subirá${tempImages.length > 1 ? 'n' : ''}',
      );
    }

    if (postsToDelete.isNotEmpty) {
      messages.add(
        '${postsToDelete.length} post${postsToDelete.length > 1 ? 's' : ''} se eliminará${postsToDelete.length > 1 ? 'n' : ''}',
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.info, color: AppColors.info, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${messages.join(' y ')} cuando guardes el perfil.',
              style: AppTextStyles.caption.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    debugPrint('📷 Mostrando modal de selección de imagen');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Agregar Imagen al Post',
        enableCrop: false,
        onImageSelected: (imagePath) {
          debugPrint('✅ Imagen seleccionada: $imagePath');
          onAddImage(imagePath);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String postId) {
    final isMarked = postsToDelete.contains(postId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isMarked ? 'Restaurar Post' : 'Eliminar Post',
          style: AppTextStyles.h4,
        ),
        content: Text(
          isMarked
              ? '¿Quieres restaurar este post? No se eliminará cuando guardes.'
              : '¿Estás seguro de que quieres eliminar este post? Se eliminará cuando guardes el perfil.',
          style: AppTextStyles.body2,
        ),
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
              onMarkForDeletion(postId);
            },
            child: Text(
              isMarked ? 'Restaurar' : 'Eliminar',
              style: AppTextStyles.labelMedium.copyWith(
                color: isMarked ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
