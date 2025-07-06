import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/core/core.dart';
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
    final currentState = context.read<FeedBloc>().state;
    if (currentState is FeedInitial) {
      context.read<FeedBloc>().loadFeed();
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
              child: BlocConsumer<FeedBloc, FeedState>(
                listener: (context, state) {
                  if (state is FeedError) {
                    ToastUtils.showError(
                      context: context,
                      message: state.message,
                    );
                  } else if (state is PostLikeUpdated) {
                    // Opcional: mostrar feedback de like
                  }
                },
                builder: (context, state) {
                  if (state is FeedLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FeedError) {
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
                              context.read<FeedBloc>().loadFeed();
                            },
                            icon: const Icon(LucideIcons.refreshCw),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FeedLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<FeedBloc>().refreshFeed();
                      },
                      child: CustomScrollView(
                        slivers: [
                          // Stories section
                          SliverToBoxAdapter(
                            child: StoriesSectionWidget(
                              stories: state.stories,
                              onAddStory: () {
                                ToastUtils.showInfo(
                                  context: context,
                                  message: 'Add story coming soon...',
                                );
                              },
                            ),
                          ),

                          // Posts list
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final post = state.posts[index];
                              return PostItemWidget(
                                post: post,
                                onLike: () {
                                  context.read<FeedBloc>().togglePostLike(
                                    post.id,
                                  );
                                },
                                onComment: () {
                                  // Handled by PostItemWidget (opens detail)
                                },
                                onShare: () {
                                  ToastUtils.showInfo(
                                    context: context,
                                    message:
                                        'Share functionality coming soon...',
                                  );
                                },
                              );
                            }, childCount: state.posts.length),
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
}
