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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _bioController = TextEditingController(text: widget.profile.bio);
    _selectedAllergies = List.from(widget.profile.allergies);
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
              ToastUtils.showSuccess(
                context: context,
                message: 'Perfil actualizado exitosamente',
              );
              Navigator.pop(context);
            } else if (state is ProfileError) {
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showError(context: context, message: state.message);
            } else if (state is ProfileUpdating) {
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
                            });
                          },
                          userRole: widget.profile.role,
                          userId: widget.profile.id,
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
    if (!_formKey.currentState!.validate()) {
      ToastUtils.showError(
        context: context,
        message: 'Por favor corrige los errores en el formulario',
      );
      return;
    }

    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(
        userId: widget.profile.id,
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        allergies: _selectedAllergies,
      ),
    );
  }

  void _showChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Cambiar Foto de Perfil',
        onImageSelected: (imagePath) {
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
