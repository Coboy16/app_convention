import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '/features/posts/presentation/widgets/widgets.dart';
import '/features/posts/presentation/bloc/blocs.dart';
import '/features/posts/domain/entities/feed_post_entity.dart';
import '/features/posts/domain/entities/feed_comment_entity.dart';
import '/core/core.dart';

class PostDetailScreen extends StatefulWidget {
  final FeedPostEntity post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  List<FeedCommentEntity> _comments = [];
  bool _isLoadingComments = true; // CAMBIADO: true por defecto

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadComments() {
    setState(() {
      _isLoadingComments = true;
    });
    context.read<FeedPostsBloc>().loadComments(widget.post.id);
  }

  void _addComment() {
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      context.read<FeedPostsBloc>().addComment(widget.post.id, content);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _sharePost() {
    final shareText =
        '''
🎉 ¡Mira este post de ${widget.post.username}!

${widget.post.content}

${widget.post.hashtags.isNotEmpty ? widget.post.hashtags.join(' ') : ''}

📱 Compartido desde Konecta App
''';

    if (widget.post.imageUrls.isNotEmpty) {
      // Compartir con imagen
      Share.share(shareText, subject: 'Post de ${widget.post.username}');
    } else {
      // Compartir solo texto
      Share.share(shareText);
    }
  }

  void _likePost() {
    context.read<FeedPostsBloc>().togglePostLike(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  Text('Post', style: AppTextStyles.h4),
                  const Spacer(),
                  IconButton(
                    onPressed: _sharePost, // IMPLEMENTADO
                    icon: const Icon(
                      LucideIcons.share,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: BlocListener<FeedPostsBloc, FeedPostsState>(
                listener: (context, state) {
                  if (state is FeedCommentsLoaded &&
                      state.postId == widget.post.id) {
                    setState(() {
                      _comments = state.comments;
                      _isLoadingComments = false;
                    });
                  } else if (state is FeedCommentAdded) {
                    setState(() {
                      _comments.insert(0, state.comment);
                    });
                    ToastUtils.showSuccess(
                      context: context,
                      message: 'Comentario agregado',
                    );
                  } else if (state is FeedPostsError) {
                    setState(() {
                      _isLoadingComments = false;
                    });
                  }
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(
                    AppResponsive.horizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post content
                      _PostContent(
                        post: widget.post,
                        onLike: _likePost,
                        onShare: _sharePost,
                      ),

                      const SizedBox(height: 24),

                      // Comments section
                      _CommentsSection(
                        comments: _comments,
                        isLoading: _isLoadingComments,
                        onCommentLike: (commentId) {
                          context.read<FeedPostsBloc>().toggleCommentLike(
                            commentId,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Comment input
            _CommentInput(controller: _commentController, onSend: _addComment),
          ],
        ),
      ),
    );
  }
}

class _PostContent extends StatelessWidget {
  final FeedPostEntity post;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const _PostContent({
    required this.post,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              if (post.type == FeedPostType.admin)
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
                  radius: 24,
                  backgroundColor: AppColors.surfaceVariant,
                  backgroundImage: post.avatarUrl != null
                      ? CachedNetworkImageProvider(post.avatarUrl!)
                      : null,
                  child: post.avatarUrl == null
                      ? _getInitials(post.username)
                      : null,
                ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          post.username,
                          style: AppTextStyles.h4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (post.userRole != null) ...[
                          const SizedBox(width: 8),
                          AutoSizeText(
                            '(${post.userRole})',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ],
                    ),
                    AutoSizeText(
                      _getTimeAgo(post.createdAt),
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Post content
          AutoSizeText(post.content, style: AppTextStyles.body1),

          // Hashtags
          if (post.hashtags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: post.hashtags.map((hashtag) {
                return Text(
                  hashtag,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],

          // Post images
          if (post.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildImageSection(),
          ],

          const SizedBox(height: 16),

          // Post actions
          Row(
            children: [
              // Like button
              InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        post.isLikedByCurrentUser
                            ? LucideIcons.heart
                            : LucideIcons.heart,
                        color: post.isLikedByCurrentUser
                            ? AppColors.error
                            : AppColors.textTertiary,
                        size: 20,
                        fill: post.isLikedByCurrentUser ? 1.0 : 0.0,
                      ),
                      const SizedBox(width: 4),
                      AutoSizeText(
                        '${post.likesCount} likes',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.messageCircle,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  AutoSizeText(
                    '${post.commentsCount} comments',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),

              const Spacer(),

              // Share button
              InkWell(
                onTap: onShare,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Icon(
                    LucideIcons.share,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ),
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
        height: 250,
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
                  size: 64,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Multiple images in grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: post.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.inputBorder, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: post.imageUrls[index],
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
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
}

class _CommentsSection extends StatelessWidget {
  final List<FeedCommentEntity> comments;
  final bool isLoading;
  final Function(String) onCommentLike;

  const _CommentsSection({
    required this.comments,
    required this.isLoading,
    required this.onCommentLike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comentarios', style: AppTextStyles.h4),
        const SizedBox(height: 16),

        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (comments.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder, width: 1),
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.messageCircle,
                  color: AppColors.textTertiary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay comentarios aún',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sé el primero en comentar este post',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentItemWidget(
                comment: comment,
                onLike: () => onCommentLike(comment.id),
              );
            },
          ),
      ],
    );
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.horizontalPadding(context)),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.inputBorder, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceVariant,
              child: Text(
                'JD',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Escribe un comentario...',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: AppTextStyles.body2,
                maxLines: 3,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: onSend,
              icon: const Icon(
                LucideIcons.send,
                color: AppColors.primary,
                size: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
