import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/widgets/widgets.dart';
import '/core/core.dart';

class EditProfileFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController jobTitleController;
  final TextEditingController bioController;
  final TextEditingController locationController;

  const EditProfileFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.jobTitleController,
    required this.bioController,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        _SectionHeader(
          icon: LucideIcons.pencilLine,
          title: 'Basic Information',
        ),

        const SizedBox(height: 16),

        // Name Field
        CustomTextField(
          label: 'Name',
          hintText: 'Enter your full name',
          controller: nameController,
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
          label: 'Email (read-only)',
          hintText: 'Email address',
          controller: emailController,
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

        // Job Title Field
        CustomTextField(
          label: 'Job Title',
          hintText: 'Enter your job title',
          controller: jobTitleController,
          validator: (value) =>
              FormValidators.validateRequired(value, 'Job title'),
          prefixIcon: const Icon(
            LucideIcons.briefcase,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ),

        const SizedBox(height: 32),

        // About You Section
        _SectionHeader(icon: LucideIcons.messageSquare, title: 'About You'),

        const SizedBox(height: 16),

        // Bio Field
        _BioTextField(controller: bioController),

        const SizedBox(height: 16),

        // Location Field
        CustomTextField(
          label: 'Location',
          hintText: 'Enter your location',
          controller: locationController,
          validator: (value) =>
              FormValidators.validateRequired(value, 'Location'),
          prefixIcon: const Icon(
            LucideIcons.mapPin,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ),

        const SizedBox(height: 32),

        // Your Posts Section
        _PostsSection(),

        const SizedBox(height: 24),
      ],
    );
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
          label: 'Bio',
          hintText: 'Tell us about yourself...',
          controller: widget.controller,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Bio is required';
            }
            if (value.length > maxLength) {
              return 'Bio cannot exceed $maxLength characters';
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
              'Character count: ${remainingLength}/$maxLength',
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

class _PostsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: LucideIcons.camera, title: 'Your Posts (12)'),

        const SizedBox(height: 16),

        // Posts Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: 7, // 6 posts + 1 add button
          itemBuilder: (context, index) {
            if (index == 6) {
              return _AddPostButton();
            }
            return _PostItem(index: index);
          },
        ),
      ],
    );
  }
}

class _PostItem extends StatelessWidget {
  final int index;

  const _PostItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: const Center(
        child: Icon(LucideIcons.image, color: AppColors.textTertiary, size: 24),
      ),
    );
  }
}

class _AddPostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement add post functionality
      },
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
              'Add New Post',
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
}
