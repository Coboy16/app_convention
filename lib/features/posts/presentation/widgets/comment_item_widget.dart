import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/posts/data/data.dart';
import '/core/core.dart';

class CommentItemWidget extends StatelessWidget {
  final CommentModel comment;

  const CommentItemWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceVariant,
            child: _getInitials(comment.username),
          ),

          const SizedBox(width: 12),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and time
                Row(
                  children: [
                    AutoSizeText(
                      comment.username,
                      style: AppTextStyles.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 8),
                    AutoSizeText(
                      _getTimeAgo(comment.createdAt),
                      style: AppTextStyles.caption,
                      maxLines: 1,
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Comment text
                AutoSizeText(
                  comment.content,
                  style: AppTextStyles.body2,
                  maxLines: 10,
                ),

                const SizedBox(height: 8),

                // Comment actions
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Toggle like comment
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              comment.isLiked
                                  ? LucideIcons.heart
                                  : LucideIcons.heart,
                              color: comment.isLiked
                                  ? AppColors.error
                                  : AppColors.textTertiary,
                              size: 16,
                              fill: comment.isLiked ? 1.0 : 0.0,
                            ),
                            if (comment.likesCount > 0) ...[
                              const SizedBox(width: 4),
                              AutoSizeText(
                                comment.likesCount.toString(),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    InkWell(
                      onTap: () {
                        // Reply to comment
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: AutoSizeText(
                          'Responder',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      style: AppTextStyles.caption.copyWith(
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
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
