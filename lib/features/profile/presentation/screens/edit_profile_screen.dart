import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/presentation/bloc/blocs.dart';
import '/features/profile/presentation/widgets/widgets.dart';
import '/features/profile/data/data.dart';
import '/core/core.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _jobTitleController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _jobTitleController = TextEditingController(text: widget.profile.role);
    _bioController = TextEditingController(text: widget.profile.about);
    _locationController = TextEditingController(text: widget.profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _jobTitleController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showSuccess(
                context: context,
                message: 'Profile updated successfully',
              );
              Navigator.pop(context);
            } else if (state is ProfileError) {
              setState(() {
                _isLoading = false;
              });
              ToastUtils.showError(context: context, message: state.message);
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        LucideIcons.arrowLeft,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      label: Text(
                        'Cancel',
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
                        'Edit Profile',
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
                                'Save',
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
                          avatarUrl: widget.profile.avatarUrl,
                          name: widget.profile.name,
                          size: 80,
                          isEditable: false,
                        ),

                        const SizedBox(height: 12),

                        // Change Photo Button
                        TextButton.icon(
                          onPressed: _showChangePhotoModal,
                          icon: const Icon(
                            LucideIcons.camera,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'Change Photo',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Form Fields
                        EditProfileFormWidget(
                          nameController: _nameController,
                          emailController: _emailController,
                          jobTitleController: _jobTitleController,
                          bioController: _bioController,
                          locationController: _locationController,
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
        message: 'Please correct the errors in the form',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _jobTitleController.text.trim(),
      about: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );

    context.read<ProfileBloc>().updateProfile(updatedProfile);
  }

  void _showChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change Profile Picture', style: AppTextStyles.h4),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PhotoOption(
                  icon: LucideIcons.camera,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Camera feature coming soon...',
                    );
                  },
                ),
                _PhotoOption(
                  icon: LucideIcons.image,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Gallery feature coming soon...',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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
