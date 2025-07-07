import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:konecta/features/profile/domain/domain.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/shared/bloc/blocs.dart';
import '/core/core.dart';

class ProfilePostsWidget extends StatelessWidget {
  final PostsState postsState;
  final VoidCallback? onAddPost;
  final Function(String)? onDeletePost;

  const ProfilePostsWidget({
    super.key,
    required this.postsState,
    this.onAddPost,
    this.onDeletePost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.horizontalPadding(context),
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posts header
          Row(
            children: [
              const Icon(
                LucideIcons.grid3x3,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AutoSizeText(
                  'Posts',
                  style: AppTextStyles.h4,
                  maxLines: 1,
                ),
              ),
              if (postsState is PostsLoaded) ...[
                Text(
                  '(${(postsState as PostsLoaded).posts.length})',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Posts grid - FIXED: Solo mostrar grid de fotos, SIN botón agregar
          _buildPostsGrid(context),
        ],
      ),
    );
  }

  Widget _buildPostsGrid(BuildContext context) {
    if (postsState is PostsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (postsState is PostsError) {
      return _buildErrorState((postsState as PostsError).message);
    }

    if (postsState is PostsLoaded ||
        postsState is PostCreating ||
        postsState is PostDeleting) {
      List<PostEntity> posts;
      String? deletingPostId;

      if (postsState is PostsLoaded) {
        posts = (postsState as PostsLoaded).posts;
      } else if (postsState is PostCreating) {
        posts = (postsState as PostCreating).currentPosts;
      } else if (postsState is PostDeleting) {
        final deletingState = postsState as PostDeleting;
        posts = deletingState.currentPosts;
        deletingPostId = deletingState.deletingPostId;
      } else {
        posts = [];
      }

      if (posts.isEmpty) {
        return _buildEmptyState();
      }

      // FIXED: Solo mostrar grid de fotos de posts existentes
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: posts.length, // REMOVED: +1 for add button
        itemBuilder: (context, index) {
          final post = posts[index];
          final isDeleting = deletingPostId == post.id;

          return _buildPostItem(post, isDeleting);
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(String message) {
    return Column(
      children: [
        const Icon(LucideIcons.circleAlert, size: 48, color: AppColors.error),
        const SizedBox(height: 16),
        Text('Error al cargar posts', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        Text(message, style: AppTextStyles.body2, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const Icon(LucideIcons.image, size: 48, color: AppColors.textTertiary),
        const SizedBox(height: 16),
        Text('No hay posts aún', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        Text(
          'Los posts aparecerán aquí cuando los crees',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPostItem(PostEntity post, bool isDeleting) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: post.imageUrls.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: post.imageUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Icon(
                          LucideIcons.imageOff,
                          color: AppColors.textTertiary,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Icon(
                        LucideIcons.image,
                        color: AppColors.textTertiary,
                        size: 24,
                      ),
                    ),
                  ),
          ),
        ),

        // Multiple images indicator
        if (post.imageUrls.length > 1)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.layers, color: Colors.white, size: 10),
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

        // Deleting indicator
        if (isDeleting)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.surface,
                strokeWidth: 2,
              ),
            ),
          ),
      ],
    );
  }
}
