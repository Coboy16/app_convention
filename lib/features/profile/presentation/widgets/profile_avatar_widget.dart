import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/core.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double size;
  final bool isEditable;
  final VoidCallback? onEditPressed;

  const ProfileAvatarWidget({
    super.key,
    this.avatarUrl,
    required this.name,
    this.size = 80,
    this.isEditable = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceVariant,
            border: Border.all(color: AppColors.inputBorder, width: 2),
          ),
          child: avatarUrl != null
              ? ClipOval(
                  child: Image.network(
                    avatarUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildInitialsAvatar();
                    },
                  ),
                )
              : _buildInitialsAvatar(),
        ),
        if (isEditable)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.pencilLine,
                  color: AppColors.surface,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitialsAvatar() {
    final initials = _getInitials(name);
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}
