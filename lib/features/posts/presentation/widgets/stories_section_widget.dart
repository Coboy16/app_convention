import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/features/posts/presentation/screens/screens.dart';
import '/features/posts/domain/entities/feed_story_entity.dart';
import '/core/core.dart';

// Clase para agrupar historias por usuario
class UserStoryGroup {
  final String userId;
  final String username;
  final String? avatarUrl;
  final List<FeedStoryEntity> stories;
  final bool hasUnviewedStories;

  UserStoryGroup({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.stories,
    required this.hasUnviewedStories,
  });
}

class StoriesSectionWidget extends StatelessWidget {
  final List<FeedStoryEntity> stories;
  final VoidCallback onAddStory;

  const StoriesSectionWidget({
    super.key,
    required this.stories,
    required this.onAddStory,
  });

  // Agrupar historias por usuario
  List<UserStoryGroup> _groupStoriesByUser(List<FeedStoryEntity> stories) {
    final Map<String, List<FeedStoryEntity>> groupedStories = {};

    for (final story in stories) {
      if (!groupedStories.containsKey(story.userId)) {
        groupedStories[story.userId] = [];
      }
      groupedStories[story.userId]!.add(story);
    }

    return groupedStories.entries.map((entry) {
      final userStories = entry.value;
      // Ordenar historias del usuario por fecha de creación
      userStories.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // Verificar si hay historias no vistas
      final hasUnviewedStories = userStories.any(
        (story) => !story.isViewedByCurrentUser,
      );

      return UserStoryGroup(
        userId: entry.key,
        username: userStories.first.username,
        avatarUrl: userStories.first.avatarUrl,
        stories: userStories,
        hasUnviewedStories: hasUnviewedStories,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      // Solo mostrar el botón "Add Story" si no hay historias
      return Container(
        height: 110,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [_AddStoryButton(onTap: onAddStory)],
        ),
      );
    }

    final groupedStories = _groupStoriesByUser(stories);

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: groupedStories.length + 1, // +1 para el botón "Add Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddStoryButton(onTap: onAddStory);
          }

          final userGroup = groupedStories[index - 1];
          return _StoryItem(
            userGroup: userGroup,
            onTap: () => _openStoryViewer(context, userGroup.stories, 0),
          );
        },
      ),
    );
  }

  void _openStoryViewer(
    BuildContext context,
    List<FeedStoryEntity> userStories,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StoryViewerScreen(stories: userStories, initialIndex: initialIndex),
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
          mainAxisSize: MainAxisSize.min,
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
            Flexible(
              child: SizedBox(
                width: 64,
                child: AutoSizeText(
                  'Add Story',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final UserStoryGroup userGroup;
  final VoidCallback onTap;

  const _StoryItem({required this.userGroup, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                // Círculo principal con avatar/iniciales
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: userGroup.hasUnviewedStories
                          ? AppColors.primary
                          : AppColors.inputBorder,
                      width: 3,
                    ),
                  ),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceVariant,
                    ),
                    child: userGroup.avatarUrl != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: userGroup.avatarUrl!,
                              fit: BoxFit.cover,
                              width: 58,
                              height: 58,
                              placeholder: (context, url) => Container(
                                color: AppColors.surfaceVariant,
                                child: Center(
                                  child: _getInitials(userGroup.username),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.surfaceVariant,
                                child: Center(
                                  child: _getInitials(userGroup.username),
                                ),
                              ),
                            ),
                          )
                        : Center(child: _getInitials(userGroup.username)),
                  ),
                ),

                // Indicador de múltiples historias
                if (userGroup.stories.length > 1)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${userGroup.stories.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Flexible(
              child: SizedBox(
                width: 64,
                child: AutoSizeText(
                  userGroup.username,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: userGroup.hasUnviewedStories
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                ),
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
