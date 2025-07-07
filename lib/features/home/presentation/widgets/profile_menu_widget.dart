import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/bloc/blocs.dart';
import '/core/core.dart';

class ProfileMenuWidget extends StatefulWidget {
  const ProfileMenuWidget({super.key});

  @override
  State<ProfileMenuWidget> createState() => _ProfileMenuWidgetState();
}

class _ProfileMenuWidgetState extends State<ProfileMenuWidget> {
  bool _isDarkMode = false;

  void _handleLogout(BuildContext context) {
    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Cerrar Sesión', style: AppTextStyles.h4),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: AppTextStyles.body1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
              },
              child: Text(
                'Cancelar',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                Navigator.pop(context);

                // Disparar evento de logout
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              child: Text(
                'Cerrar Sesión',
                style: AppTextStyles.button.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          // Mostrar mensaje de éxito
          ToastUtils.showSuccess(
            context: context,
            message: 'Sesión cerrada exitosamente',
          );
          AppRoutes.goToLogin(context);
        } else if (state.status == AuthStatus.error) {
          // Mostrar error si ocurre
          ToastUtils.showError(
            context: context,
            message: state.errorMessage ?? 'Error al cerrar sesión',
          );
        }
      },
      child: Container(
        color: Colors.white,
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del perfil
            _buildProfileHeader(context),

            const Divider(height: 1, thickness: 1),

            // Opciones del Menú
            _buildMenuOption(
              icon: LucideIcons.user,
              text: 'Ver Perfil',
              onTap: () {
                Navigator.pop(context);
                AppRoutes.goToProfile(context);
              },
            ),
            _buildMenuOption(
              icon: LucideIcons.bell,
              text: 'Configuración de Notificaciones',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a notificaciones
              },
            ),

            // Opción con Switch para Dark Mode
            _buildDarkModeOption(),

            _buildMenuOption(
              icon: LucideIcons.circleHelp,
              text: 'Ayuda y Soporte',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a ayuda
              },
            ),

            const Divider(height: 1, thickness: 1),

            // Opción de Cerrar Sesión
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state.status == AuthStatus.loading;

                return _buildMenuOption(
                  icon: LucideIcons.logOut,
                  text: isLoading ? 'Cerrando sesión...' : 'Cerrar Sesión',
                  color: AppColors.error,
                  isLoading: isLoading,
                  onTap: isLoading ? null : () => _handleLogout(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : null,
                child: user?.photoUrl == null
                    ? Text(
                        _getInitials(user?.name ?? 'User'),
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Usuario',
                      style: AppTextStyles.body1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user?.email ?? 'email@ejemplo.com',
                      style: AppTextStyles.body2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDarkModeOption() {
    return ListTile(
      leading: const Icon(
        LucideIcons.moon,
        size: 20,
        color: AppColors.textSecondary,
      ),
      title: Text('Modo Oscuro', style: AppTextStyles.body1),
      trailing: Switch(
        value: _isDarkMode,
        onChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
          // TODO: Implementar cambio de tema
        },
        activeColor: AppColors.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String text,
    required VoidCallback? onTap,
    Color? color,
    bool isLoading = false,
  }) {
    final textColor = color ?? AppColors.textPrimary;
    final iconColor = color ?? AppColors.textSecondary;

    return ListTile(
      leading: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            )
          : Icon(icon, size: 20, color: iconColor),
      title: Text(text, style: AppTextStyles.body1.copyWith(color: textColor)),
      onTap: onTap,
      enabled: onTap != null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';

    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }
}
