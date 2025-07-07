import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/features/posts/presentation/screens/screens.dart';
import '/features/posts/domain/entities/feed_post_entity.dart'; // CAMBIADO
import '/core/core.dart';

class PostItemWidget extends StatelessWidget {
  final FeedPostEntity post; // CAMBIADO
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostItemWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Row(
            children: [
              // Admin badge or user avatar
              if (post.type == FeedPostType.admin) // CAMBIADO
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AutoSizeText(
                    'ADMIN POST',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                )
              else
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceVariant,
                  backgroundImage: post.avatarUrl != null
                      ? CachedNetworkImageProvider(post.avatarUrl!)
                      : null,
                  child: post.avatarUrl == null
                      ? _getInitials(post.username)
                      : null,
                ),

              const SizedBox(width: 12),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          post.username,
                          style: AppTextStyles.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (post.userRole != null) ...[
                          const SizedBox(width: 8),
                          AutoSizeText(
                            '(${post.userRole})', // CAMBIADO de post.role
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ],
                    ),
                    AutoSizeText(
                      _getTimeAgo(post.createdAt),
                      style: AppTextStyles.caption,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              // More options
              IconButton(
                onPressed: () {
                  // Show more options
                },
                icon: const Icon(
                  LucideIcons.moveHorizontal,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Post content
          GestureDetector(
            onTap: () => _openPostDetail(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  post.content,
                  style: AppTextStyles.body2,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                // Hashtags
                if (post.hashtags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: post.hashtags.map((hashtag) {
                      return Text(
                        hashtag,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Post images
                if (post.imageUrls.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildImageSection(),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Post actions
          Row(
            children: [
              // Like button
              _ActionButton(
                icon: post.isLikedByCurrentUser
                    ? LucideIcons.heart
                    : LucideIcons.heart, // CAMBIADO
                label: post.likesCount.toString(),
                isActive: post.isLikedByCurrentUser, // CAMBIADO
                onTap: onLike,
              ),

              const SizedBox(width: 16),

              // Comment button
              _ActionButton(
                icon: LucideIcons.messageCircle,
                label: post.commentsCount.toString(),
                onTap: () => _openPostDetail(context),
              ),

              const Spacer(),

              // Share button
              _ActionButton(icon: LucideIcons.share, onTap: onShare),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (post.imageUrls.isEmpty) return const SizedBox.shrink();

    if (post.imageUrls.length == 1) {
      // Single image
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: post.imageUrls.first,
            fit: BoxFit.cover,
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
                  size: 48,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Multiple images
      return SizedBox(
        height: 200,
        child: PageView.builder(
          itemCount: post.imageUrls.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrls[index],
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
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Image counter
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}/${post.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _openPostDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.error : AppColors.textTertiary,
              size: 20,
              fill: isActive ? 1.0 : 0.0,
            ),
            if (label != null) ...[
              const SizedBox(width: 4),
              AutoSizeText(
                label!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
