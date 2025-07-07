import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/presentation/bloc/blocs.dart';
import '/features/profile/presentation/widgets/widgets.dart';
import '/features/profile/domain/domain.dart';
import '/core/core.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late List<String> _selectedAllergies;

  // Para manejar imágenes temporales
  final List<String> _tempPostImages = [];

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _bioController = TextEditingController(text: widget.profile.bio);
    _selectedAllergies = List.from(widget.profile.allergies);

    debugPrint(
      '🟢 EditProfileScreen iniciado para usuario: ${widget.profile.id}',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              setState(() {
                _isLoading = false;
              });
              debugPrint('✅ Perfil actualizado exitosamente');
              ToastUtils.showSuccess(
                context: context,
                message: 'Perfil actualizado exitosamente',
              );
              Navigator.pop(context, true);
            } else if (state is ProfileError) {
              setState(() {
                _isLoading = false;
              });
              debugPrint('❌ Error al actualizar perfil: ${state.message}');
              ToastUtils.showError(context: context, message: state.message);
            } else if (state is ProfileUpdating) {
              setState(() {
                _isLoading = true;
              });
              debugPrint('🔄 Actualizando perfil...');
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
                          : () => Navigator.pop(context, _hasChanges),
                      icon: const Icon(
                        LucideIcons.arrowLeft,
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
                        'Editar Perfil',
                        style: AppTextStyles.h4,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Save button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: _isLoading ? null : _handleSave,
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
                                'Guardar',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Avatar Section
                        ProfileAvatarWidget(
                          avatarUrl: widget.profile.photoUrl,
                          name: widget.profile.name,
                          size: 80,
                          isEditable: true,
                          onEditPressed: () {
                            _showChangePhotoModal();
                          },
                        ),

                        const SizedBox(height: 32),

                        // Form Fields
                        EditProfileFormWidget(
                          nameController: _nameController,
                          emailController: TextEditingController(
                            text: widget.profile.email,
                          ),
                          bioController: _bioController,
                          selectedAllergies: _selectedAllergies,
                          onAllergiesChanged: (allergies) {
                            setState(() {
                              _selectedAllergies = allergies;
                              _hasChanges = true;
                            });
                            debugPrint('🔄 Alergias actualizadas: $allergies');
                          },
                          userRole: widget.profile.role,
                          userId: widget.profile.id,
                          tempPostImages: _tempPostImages,
                          onAddTempImage: (imagePath) {
                            setState(() {
                              _tempPostImages.add(imagePath);
                              _hasChanges = true;
                            });
                            debugPrint(
                              '📸 Imagen temporal agregada: $imagePath',
                            );
                            debugPrint(
                              '📸 Total imágenes temporales: ${_tempPostImages.length}',
                            );
                          },
                          onRemoveTempImage: (index) {
                            setState(() {
                              _tempPostImages.removeAt(index);
                              _hasChanges = true;
                            });
                            debugPrint(
                              '🗑️ Imagen temporal removida en índice: $index',
                            );
                            debugPrint(
                              '📸 Total imágenes temporales: ${_tempPostImages.length}',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() async {
    debugPrint('💾 Iniciando guardado de perfil...');
    debugPrint('📋 Datos a guardar:');
    debugPrint('   - Nombre: ${_nameController.text.trim()}');
    debugPrint('   - Bio: ${_bioController.text.trim()}');
    debugPrint('   - Alergias: $_selectedAllergies');
    debugPrint('   - Imágenes temporales: ${_tempPostImages.length}');

    // FIXED: Obtener posts marcados para eliminar usando el método of()
    final formState = EditProfileFormWidget.of(context);
    final postsToDelete = formState?.postsToDelete ?? <String>{};
    debugPrint('   - Posts a eliminar: ${postsToDelete.length}');

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ Formulario inválido');
      ToastUtils.showError(
        context: context,
        message: 'Por favor corrige los errores en el formulario',
      );
      return;
    }

    setState(() {
      _hasChanges = true;
    });

    // 1. Actualizar el perfil
    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(
        userId: widget.profile.id,
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        allergies: _selectedAllergies,
      ),
    );

    // 2. Eliminar posts marcados para eliminación
    if (postsToDelete.isNotEmpty) {
      debugPrint('🗑️ Eliminando ${postsToDelete.length} posts...');
      for (final postId in postsToDelete) {
        context.read<PostsBloc>().add(
          PostDeleteRequested(userId: widget.profile.id, postId: postId),
        );
        // Pequeña pausa entre eliminaciones
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    // 3. Subir imágenes temporales como posts
    if (_tempPostImages.isNotEmpty) {
      debugPrint(
        '📤 Subiendo ${_tempPostImages.length} imágenes como posts...',
      );

      // Esperar un momento para que se completen las otras operaciones
      await Future.delayed(const Duration(milliseconds: 500));

      context.read<PostsBloc>().add(
        PostCreateRequested(
          userId: widget.profile.id,
          description: null,
          imagePaths: _tempPostImages,
        ),
      );
    } else {
      debugPrint('📋 No hay imágenes temporales para subir');
    }
  }

  void _showChangePhotoModal() {
    debugPrint('📷 Abriendo modal para cambiar foto de perfil');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Cambiar Foto de Perfil',
        onImageSelected: (imagePath) {
          debugPrint('📷 Foto de perfil seleccionada: $imagePath');
          setState(() {
            _hasChanges = true;
          });

          context.read<ProfileBloc>().add(
            ProfileImageUpdateRequested(
              userId: widget.profile.id,
              imagePath: imagePath,
            ),
          );
        },
      ),
    );
  }
}
