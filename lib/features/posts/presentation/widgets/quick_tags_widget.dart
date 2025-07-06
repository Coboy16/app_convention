import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/core.dart';

class QuickTagsWidget extends StatelessWidget {
  final List<String> predefinedTags;
  final List<String> customTags;
  final List<String> selectedTags;
  final bool showCustomInput;
  final TextEditingController customTagController;
  final Function(String) onTagSelected;
  final VoidCallback onCustomPressed;
  final VoidCallback onCustomTagAdded;

  const QuickTagsWidget({
    super.key,
    required this.predefinedTags,
    required this.customTags,
    required this.selectedTags,
    required this.showCustomInput,
    required this.customTagController,
    required this.onTagSelected,
    required this.onCustomPressed,
    required this.onCustomTagAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(LucideIcons.tag, size: 16, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(
              'Etiquetas Rápidas (Opcional)',
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Tags Grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Predefined tags
            ...predefinedTags.map(
              (tag) => _TagChip(
                text: tag,
                isSelected: selectedTags.contains(tag),
                onTap: () => onTagSelected(tag),
              ),
            ),

            // Custom tags
            ...customTags.map(
              (tag) => _TagChip(
                text: tag,
                isSelected: selectedTags.contains(tag),
                isCustom: true,
                onTap: () => onTagSelected(tag),
              ),
            ),

            // Custom button
            _CustomTagButton(
              onPressed: onCustomPressed,
              isActive: showCustomInput,
            ),
          ],
        ),

        // Custom tag input
        if (showCustomInput) ...[
          const SizedBox(height: 12),
          _CustomTagInput(
            controller: customTagController,
            onAdd: onCustomTagAdded,
          ),
        ],

        // Selected tags display
        if (selectedTags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Etiquetas seleccionadas:',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedTags
                .map(
                  (tag) => _SelectedTag(
                    text: tag,
                    onRemove: () => onTagSelected(tag),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCustom;
  final VoidCallback onTap;

  const _TagChip({
    required this.text,
    required this.isSelected,
    this.isCustom = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceVariant,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AutoSizeText(
          text,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

class _CustomTagButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const _CustomTagButton({required this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.inputBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.plus,
              size: 14,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            AutoSizeText(
              'Personalizado',
              style: AppTextStyles.caption.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTagInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _CustomTagInput({required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.hash,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Ingresa etiqueta personalizada',
                    hintStyle: AppTextStyles.body2.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTextStyles.body2,
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: onAdd,
                  child: Text(
                    'Agregar',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectedTag extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const _SelectedTag({required this.text, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(8),
            child: const Icon(
              LucideIcons.x,
              size: 12,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
