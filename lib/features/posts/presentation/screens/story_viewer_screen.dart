import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/features/posts/presentation/bloc/blocs.dart';
import '/features/posts/domain/entities/feed_story_entity.dart'; // CAMBIADO
import '/core/core.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<FeedStoryEntity> stories; // CAMBIADO
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  int _currentIndex = 0;
  static const Duration _storyDuration = Duration(
    seconds: 5,
  ); // Reducido a 5 segundos

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _progressController = AnimationController(
      duration: _storyDuration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _startStoryTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    _progressController.reset();
    _progressController.forward().then((_) {
      _nextStory();
    });

    // Marcar como vista
    if (_currentIndex < widget.stories.length) {
      context.read<FeedPostsBloc>().viewStory(
        widget.stories[_currentIndex].id,
      ); // CAMBIADO
    }
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    }
  }

  void _pauseStory() {
    _progressController.stop();
  }

  void _resumeStory() {
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _pauseStory(),
        onTapUp: (details) {
          _resumeStory();
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onTapCancel: () => _resumeStory(),
        child: Stack(
          children: [
            // Stories content
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _startStoryTimer();
              },
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return _StoryContent(story: story);
              },
            ),

            // Progress indicators
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: Row(
                children: widget.stories.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          double progress = 0.0;
                          if (index < _currentIndex) {
                            progress = 1.0;
                          } else if (index == _currentIndex) {
                            progress = _progressAnimation.value;
                          }

                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Header
            Positioned(
              top: MediaQuery.of(context).padding.top + 32,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surfaceVariant,
                    backgroundImage:
                        widget.stories[_currentIndex].avatarUrl != null
                        ? CachedNetworkImageProvider(
                            widget.stories[_currentIndex].avatarUrl!,
                          )
                        : null,
                    child: widget.stories[_currentIndex].avatarUrl == null
                        ? _getInitials(widget.stories[_currentIndex].username)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stories[_currentIndex].username,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getTimeAgo(widget.stories[_currentIndex].createdAt),
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      LucideIcons.x,
                      color: Colors.white,
                      size: 24,
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

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

class _StoryContent extends StatelessWidget {
  final FeedStoryEntity story; // CAMBIADO

  const _StoryContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background image
          CachedNetworkImage(
            imageUrl: story.imageUrl,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primaryDark.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.imageOff,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
          ),

          // Gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Caption at bottom
          if (story.caption.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  story.caption,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
