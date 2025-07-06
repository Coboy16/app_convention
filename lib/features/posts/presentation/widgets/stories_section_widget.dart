import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/posts/presentation/screens/screens.dart';
import '/features/posts/data/data.dart';
import '/core/core.dart';

class StoriesSectionWidget extends StatelessWidget {
  final List<StoryModel> stories;
  final VoidCallback onAddStory;

  const StoriesSectionWidget({
    super.key,
    required this.stories,
    required this.onAddStory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length + 1, // +1 para el botón "Add Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddStoryButton(onTap: onAddStory);
          }

          final story = stories[index - 1];
          return _StoryItem(
            story: story,
            onTap: () => _openStoryViewer(context, stories, index - 1),
          );
        },
      ),
    );
  }

  void _openStoryViewer(
    BuildContext context,
    List<StoryModel> stories,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StoryViewerScreen(stories: stories, initialIndex: initialIndex),
      ),
    );
  }
}

class _AddStoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddStoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder, width: 2),
              ),
              child: const Icon(
                LucideIcons.plus,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: AutoSizeText(
                'Add Story',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;

  const _StoryItem({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: story.isViewed
                      ? AppColors.inputBorder
                      : AppColors.primary,
                  width: 3,
                ),
              ),
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceVariant,
                ),
                child: Center(child: _getInitials(story.username)),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: AutoSizeText(
                story.username,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getInitials(String name) {
    final words = name.trim().split(' ');
    String initials = '';
    if (words.isNotEmpty) {
      initials = words[0][0];
      if (words.length > 1) {
        initials += words[1][0];
      }
    }

    return Text(
      initials.toUpperCase(),
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
