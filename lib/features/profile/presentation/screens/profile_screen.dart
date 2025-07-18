import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/posts/presentation/screens/screens.dart';
import 'package:konecta/shared/bloc/blocs.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _requestPermissions();
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

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos, // para iOS y Android 13+
      Permission.storage, // para Android ≤ 12
    ].request();

    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      debugPrint('Algunos permisos están permanentemente denegados.');
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
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Custom AppBar
                    const SizedBox(height: 60),

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

                    // Stats (posts count from PostsBloc)
                    BlocBuilder<PostsBloc, PostsState>(
                      builder: (context, postsState) {
                        final postsCount = postsState is PostsLoaded
                            ? (postsState).posts.length
                            : 0;

                        return ProfileStatsWidget(
                          postsCount: postsCount,
                          onPostsTap: () {
                            // Scroll to posts section
                          },
                        );
                      },
                    ),

                    // Profile Info
                    ProfileInfoWidget(profile: profile),

                    const SizedBox(height: 20),

                    // Posts Section
                    BlocConsumer<PostsBloc, PostsState>(
                      listener: (context, postsState) {
                        if (postsState is PostsError) {
                          ToastUtils.showError(
                            context: context,
                            message: (postsState).message,
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

  // FIXED: Método modificado para refrescar posts al regresar
  void _showEditProfileModal(BuildContext context, profile) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );

    // FIXED: Refrescar posts cuando se regresa de editar perfil
    if (result == true && currentUserId != null) {
      // Refrescar tanto el perfil como los posts
      context.read<ProfileBloc>().add(
        ProfileRefreshRequested(userId: currentUserId!),
      );
      context.read<PostsBloc>().add(
        PostsRefreshRequested(userId: currentUserId!),
      );
    }
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
