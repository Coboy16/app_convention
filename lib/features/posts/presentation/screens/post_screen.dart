import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/core/core.dart';
import 'package:konecta/features/posts/domain/domain.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/posts/presentation/screens/screens.dart';
import '/features/posts/presentation/widgets/widgets.dart';
import '/features/posts/presentation/bloc/blocs.dart';

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
                  }
                },
                builder: (context, state) {
                  if (state is FeedPostsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FeedPostsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            LucideIcons.circleAlert,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text('Error loading feed', style: AppTextStyles.h4),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: AppTextStyles.body2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<FeedPostsBloc>().loadFeed();
                            },
                            icon: const Icon(LucideIcons.refreshCw),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FeedPostsLoaded ||
                      state is FeedPostCreating ||
                      state is FeedCommentsLoaded ||
                      state is FeedStoriesLoaded) {
                    List<FeedPostEntity> posts = [];
                    List<FeedStoryEntity> stories = [];

                    if (state is FeedPostsLoaded) {
                      posts = state.posts;
                      stories = state.stories;
                    } else if (state is FeedPostCreating) {
                      posts = state.currentPosts;
                      stories = state.currentStories;
                    } else if (state is FeedCommentsLoaded) {
                      // Mantener estado anterior
                      final previousState = context.read<FeedPostsBloc>().state;
                      if (previousState is FeedPostsLoaded) {
                        posts = previousState.posts;
                        stories = previousState.stories;
                      }
                    } else if (state is FeedStoriesLoaded) {
                      stories = state.stories;
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
                                      CircularProgressIndicator(),
                                      SizedBox(height: 8),
                                      Text('Creando post...'),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Posts list
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final post = posts[index];
                              return PostItemWidget(
                                post: post,
                                onLike: () {
                                  context.read<FeedPostsBloc>().togglePostLike(
                                    post.id,
                                  );
                                },
                                onComment: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailScreen(post: post),
                                    ),
                                  );
                                },
                                onShare: () {
                                  ToastUtils.showInfo(
                                    context: context,
                                    message:
                                        'Share functionality coming soon...',
                                  );
                                },
                              );
                            }, childCount: posts.length),
                          ),

                          // Bottom padding
                          const SliverToBoxAdapter(child: SizedBox(height: 16)),
                        ],
                      ),
                    );
                  }

                  // Estado inicial o desconocido
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateStoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
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
                    // TODO: Implementar captura de imagen para historia
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Función de cámara próximamente...',
                    );
                  },
                ),
                _StoryOption(
                  icon: LucideIcons.image,
                  label: 'Galería',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implementar selección de imagen para historia
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Función de galería próximamente...',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
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
