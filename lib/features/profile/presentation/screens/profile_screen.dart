import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/posts/presentation/screens/screens.dart';
import 'package:konecta/shared/bloc/blocs.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/presentation/screens/screens.dart';
import '/features/profile/presentation/widgets/widgets.dart';
import '/core/core.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      currentUserId = authState.user!.id;

      // Cargar perfil y posts
      context.read<ProfileBloc>().add(
        ProfileLoadRequested(userId: currentUserId!),
      );
      context.read<PostsBloc>().add(PostsLoadRequested(userId: currentUserId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ToastUtils.showError(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is ProfileError) {
          return _buildErrorState(state.message);
        }

        if (state is ProfileLoaded ||
            state is ProfileUpdating ||
            state is ProfileImageUploading) {
          final profile = state is ProfileLoaded
              ? state.profile
              : state is ProfileUpdating
              ? state.profile
              : (state as ProfileImageUploading).profile;

          final isUpdating =
              state is ProfileUpdating || state is ProfileImageUploading;

          return RefreshIndicator(
            onRefresh: () async {
              if (currentUserId != null) {
                context.read<ProfileBloc>().add(
                  ProfileRefreshRequested(userId: currentUserId!),
                );
                context.read<PostsBloc>().add(
                  PostsRefreshRequested(userId: currentUserId!),
                );
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Custom AppBar
                  Container(
                    color: AppColors.surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.horizontalPadding(context),
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Perfil', style: AppTextStyles.h4),
                        ),
                        if (isUpdating) ...[
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        IconButton(
                          onPressed: isUpdating
                              ? null
                              : () {
                                  _showEditProfileModal(context, profile);
                                },
                          icon: const Icon(
                            LucideIcons.penLine,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  ProfileHeaderWidget(
                    profile: profile,
                    onEditProfile: isUpdating
                        ? null
                        : () {
                            _showEditProfileModal(context, profile);
                          },
                    onSettings: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    onAvatarEdit: isUpdating
                        ? null
                        : () {
                            _showAvatarEditModal(context);
                          },
                  ),

                  const SizedBox(height: 20),

                  // Stats (posts count from PostsBloc)
                  BlocBuilder<PostsBloc, PostsState>(
                    builder: (context, postsState) {
                      final postsCount = postsState is PostsLoaded
                          ? (postsState as PostsLoaded).posts.length
                          : 0;

                      return ProfileStatsWidget(
                        postsCount: postsCount,
                        onPostsTap: () {
                          // Scroll to posts section
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Profile Info
                  ProfileInfoWidget(profile: profile),

                  const SizedBox(height: 20),

                  // Posts Section
                  BlocConsumer<PostsBloc, PostsState>(
                    listener: (context, postsState) {
                      if (postsState is PostsError) {
                        ToastUtils.showError(
                          context: context,
                          message: (postsState as PostsError).message,
                        );
                      }
                    },
                    builder: (context, postsState) {
                      return ProfilePostsWidget(
                        postsState: postsState,
                        onAddPost: isUpdating
                            ? null
                            : () {
                                _showAddPostModal(context);
                              },
                        onDeletePost: (postId) {
                          if (currentUserId != null) {
                            _showDeletePostDialog(context, postId);
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }

        return const Center(child: Text('Estado desconocido'));
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.circleAlert, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Error al cargar perfil', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (currentUserId != null) {
                context.read<ProfileBloc>().add(
                  ProfileLoadRequested(userId: currentUserId!),
                );
              }
            },
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal(BuildContext context, profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );
  }

  void _showAvatarEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        title: 'Cambiar Foto de Perfil',
        onImageSelected: (imagePath) {
          if (currentUserId != null) {
            context.read<ProfileBloc>().add(
              ProfileImageUpdateRequested(
                userId: currentUserId!,
                imagePath: imagePath,
              ),
            );
          }
        },
      ),
    );
  }

  void _showAddPostModal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen()),
    );
  }

  void _showDeletePostDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Post', style: AppTextStyles.h4),
        content: Text(
          '¿Estás seguro de que quieres eliminar este post?',
          style: AppTextStyles.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (currentUserId != null) {
                context.read<PostsBloc>().add(
                  PostDeleteRequested(userId: currentUserId!, postId: postId),
                );
              }
            },
            child: Text(
              'Eliminar',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
