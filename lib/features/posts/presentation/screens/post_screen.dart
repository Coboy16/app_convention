import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/core/core.dart';
import 'package:konecta/features/posts/presentation/screens/create_story_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/features/posts/presentation/screens/screens.dart';
import '/features/posts/presentation/widgets/widgets.dart';
import '/features/posts/presentation/bloc/blocs.dart';
import '/features/posts/domain/entities/feed_post_entity.dart';
import '/features/posts/domain/entities/feed_story_entity.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    final currentState = context.read<FeedPostsBloc>().state;
    if (currentState is FeedPostsInitial) {
      context.read<FeedPostsBloc>().loadFeed();
    }
  }

  void _sharePost(FeedPostEntity post) {
    final shareText =
        '''
🎉 ¡Mira este post de ${post.username}!

${post.content}

${post.hashtags.isNotEmpty ? post.hashtags.join(' ') : ''}

📱 Compartido desde Konecta App
''';

    Share.share(shareText, subject: 'Post de ${post.username}');
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
                  Text('Feed', style: AppTextStyles.h4),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      LucideIcons.plus,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: BlocConsumer<FeedPostsBloc, FeedPostsState>(
                listener: (context, state) {
                  if (state is FeedPostsError) {
                    ToastUtils.showError(
                      context: context,
                      message: state.message,
                    );
                  } else if (state is FeedCommentAdded) {
                    ToastUtils.showSuccess(
                      context: context,
                      message: 'Comentario agregado',
                    );
                  } else if (state is FeedStoryCreated) {
                    ToastUtils.showSuccess(
                      context: context,
                      message: 'Historia creada exitosamente',
                    );
                  } else if (state is FeedStoryViewed) {
                    debugPrint(
                      '✅ Historia vista manejada en UI: ${state.storyId}',
                    );
                  }
                },
                builder: (context, state) {
                  if (state is FeedPostsLoading) {
                    return _buildLoadingState();
                  }

                  if (state is FeedPostsError) {
                    return _buildErrorState(state.message);
                  }

                  if (state is FeedPostsLoaded ||
                      state is FeedPostCreating ||
                      state is FeedCommentsLoaded ||
                      state is FeedStoriesLoaded ||
                      state is FeedStoryViewed) {
                    List<FeedPostEntity> posts = [];
                    List<FeedStoryEntity> stories = [];

                    if (state is FeedPostsLoaded) {
                      posts = state.posts;
                      stories = state.stories;
                    } else if (state is FeedPostCreating) {
                      posts = state.currentPosts;
                      stories = state.currentStories;
                    } else if (state is FeedCommentsLoaded) {
                      final previousState = context.read<FeedPostsBloc>().state;
                      if (previousState is FeedPostsLoaded) {
                        posts = previousState.posts;
                        stories = previousState.stories;
                      }
                    } else if (state is FeedStoriesLoaded) {
                      stories = state.stories;
                    } else if (state is FeedStoryViewed) {
                      final bloc = context.read<FeedPostsBloc>();
                      final previousState = bloc.state;
                      if (previousState is FeedPostsLoaded) {
                        posts = previousState.posts;
                        stories = previousState.stories;
                      }
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<FeedPostsBloc>().refreshFeed();
                      },
                      child: CustomScrollView(
                        slivers: [
                          // Stories section
                          SliverToBoxAdapter(
                            child: StoriesSectionWidget(
                              stories: stories,
                              onAddStory: () {
                                _showCreateStoryModal(context);
                              },
                            ),
                          ),

                          // Loading indicator for creating post
                          if (state is FeedPostCreating)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(height: 8),
                                      Text('Creando post...'),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Posts content
                          posts.isEmpty
                              ? _buildEmptyPostsState()
                              : _buildPostsList(posts),

                          // Bottom padding
                          const SliverToBoxAdapter(child: SizedBox(height: 16)),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        // Stories skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 110,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 64,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.inputBorder,
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Posts skeleton
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildPostSkeleton(),
            childCount: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildPostSkeleton() {
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
          // Header skeleton
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content skeleton
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          // Image skeleton
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          // Actions skeleton
          Row(
            children: [
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPostsState() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Empty post cards (3 cards)
            for (int i = 0; i < 3; i++) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: Icon(
                            LucideIcons.user,
                            color: AppColors.textTertiary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant.withOpacity(
                                    0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant.withOpacity(
                                    0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Content lines
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Image placeholder
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Icon(
                        LucideIcons.image,
                        color: AppColors.textTertiary,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Action buttons
                    Row(
                      children: [
                        Icon(
                          LucideIcons.heart,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 40,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          LucideIcons.messageCircle,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Empty message
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    LucideIcons.messageSquare,
                    color: AppColors.primary,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¡No hay posts aún!',
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sé el primero en compartir algo increíble\ncon la comunidad.',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostScreen(),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.plus),
                    label: const Text('Crear mi primer post'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(List<FeedPostEntity> posts) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final post = posts[index];
        return PostItemWidget(
          post: post,
          onLike: () {
            context.read<FeedPostsBloc>().togglePostLike(post.id);
          },
          onComment: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post),
              ),
            );
          },
          onShare: () => _sharePost(post),
        );
      }, childCount: posts.length),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.circleAlert, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Error loading feed', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<FeedPostsBloc>().loadFeed();
            },
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showCreateStoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CreateStoryBottomSheet(),
    );
  }
}

class CreateStoryBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Crear Historia', style: AppTextStyles.h4),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StoryOption(
                icon: LucideIcons.camera,
                label: 'Cámara',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateStoryScreen(isCamera: true),
                    ),
                  );
                },
              ),
              _StoryOption(
                icon: LucideIcons.image,
                label: 'Galería',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateStoryScreen(isCamera: false),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StoryOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StoryOption({
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
