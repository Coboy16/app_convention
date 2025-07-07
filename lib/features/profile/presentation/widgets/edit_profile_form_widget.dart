import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/profile/presentation/bloc/blocs.dart';
import 'package:konecta/features/profile/presentation/widgets/widgets.dart';

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
  final String userId; // ADDED: Para manejar posts

  const EditProfileFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.bioController,
    required this.selectedAllergies,
    required this.onAllergiesChanged,
    required this.userRole,
    required this.userId,
  });

  @override
  State<EditProfileFormWidget> createState() => _EditProfileFormWidgetState();
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

  // ADDED: Lista de imágenes temporales para el post
  final List<String> _tempPostImages = [];

  @override
  void initState() {
    super.initState();
    // Cargar posts del usuario para mostrar en la sección
    context.read<PostsBloc>().add(PostsLoadRequested(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
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
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.mail,
                color: AppColors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  LucideIcons.lock,
                  color: AppColors.warning,
                  size: 12,
                ),
              ),
            ],
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
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.userRole == 'organizer'
                    ? LucideIcons.crown
                    : LucideIcons.user,
                color: AppColors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  LucideIcons.info,
                  color: AppColors.info,
                  size: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // About You Section
        _SectionHeader(icon: LucideIcons.messageSquare, title: 'Acerca de Ti'),

        const SizedBox(height: 16),

        // Bio Field
        _BioTextField(controller: widget.bioController),

        const SizedBox(height: 32),

        // Allergies Section
        _SectionHeader(icon: LucideIcons.triangleAlert, title: 'Alergias'),

        const SizedBox(height: 16),

        // Allergies Selection
        _AllergiesSelection(
          availableAllergies: _availableAllergies,
          selectedAllergies: widget.selectedAllergies,
          onChanged: widget.onAllergiesChanged,
        ),

        const SizedBox(height: 32),

        // FIXED: Your Posts Section - Aquí está la UI que faltaba
        _SectionHeader(icon: LucideIcons.camera, title: 'Tus Posts'),

        const SizedBox(height: 16),

        // Posts management section
        _PostsManagementSection(
          userId: widget.userId,
          tempImages: _tempPostImages,
          onAddImage: _addTempImage,
          onRemoveImage: _removeTempImage,
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  void _addTempImage(String imagePath) {
    setState(() {
      _tempPostImages.add(imagePath);
    });
  }

  void _removeTempImage(int index) {
    setState(() {
      _tempPostImages.removeAt(index);
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        AutoSizeText(title, style: AppTextStyles.h4, maxLines: 1),
      ],
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
              selectedColor: AppColors.error.withOpacity(0.2),
              checkmarkColor: AppColors.error,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.error : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.error : AppColors.inputBorder,
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
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.error.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.info, color: AppColors.error, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta información será utilizada para personalizar las opciones de catering en los eventos.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
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

// FIXED: Posts Management Section - La UI que faltaba
class _PostsManagementSection extends StatelessWidget {
  final String userId;
  final List<String> tempImages;
  final Function(String) onAddImage;
  final Function(int) onRemoveImage;

  const _PostsManagementSection({
    required this.userId,
    required this.tempImages,
    required this.onAddImage,
    required this.onRemoveImage,
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

            // Grid for current posts + temp images + add button
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: tempImages.length + 1, // temp images + add button
              itemBuilder: (context, index) {
                if (index == tempImages.length) {
                  return _buildAddImageButton(context);
                }
                return _buildTempImageItem(context, index);
              },
            ),

            if (tempImages.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
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
                        'Las imágenes se subirán cuando guardes el perfil.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    return InkWell(
      onTap: () => _showImagePicker(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.inputBorder,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            AutoSizeText(
              'Agregar\nImagen',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempImageItem(BuildContext context, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(tempImages[index])),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveImage(index),
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

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Agregar Imagen al Post',
        enableCrop: false, // Para posts no necesitamos crop
        onImageSelected: onAddImage,
      ),
    );
  }
}
