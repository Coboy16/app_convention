import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/presentation/widgets/widgets.dart';
import '/core/core.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  String _selectedTheme = 'auto'; // 'light', 'auto', 'dark'

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
                  // Back button
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

                  // Title
                  Text('Configuración', style: AppTextStyles.h4),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  AppResponsive.horizontalPadding(context),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Account Section
                    SettingsSectionWidget(
                      icon: LucideIcons.user,
                      title: 'Cuenta',
                      iconColor: AppColors.primary,
                      children: [
                        SettingsItemWidget(
                          icon: LucideIcons.user,
                          title: 'Perfil',
                          subtitle: 'Ve y edita la información de tu perfil',
                          onTap: () {
                            ToastUtils.showInfo(
                              context: context,
                              message: 'Navegando al perfil...',
                            );
                          },
                        ),
                        SettingsItemWidget(
                          icon: LucideIcons.settings,
                          title: 'Cambiar Contraseña',
                          subtitle:
                              'Actualiza tus credenciales de inicio de sesión',
                          showArrow: true,
                          onTap: () {
                            ToastUtils.showInfo(
                              context: context,
                              message: 'Función próximamente...',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Notifications Section
                    SettingsSectionWidget(
                      icon: LucideIcons.bell,
                      title: 'Notificaciones',
                      iconColor: AppColors.warning,
                      children: [
                        SettingsToggleWidget(
                          icon: LucideIcons.bell,
                          title: 'Notificaciones Push',
                          subtitle: 'Recibe notificaciones en este dispositivo',
                          value: _pushNotifications,
                          onChanged: (value) {
                            setState(() {
                              _pushNotifications = value;
                            });
                            ToastUtils.showSuccess(
                              context: context,
                              message: value
                                  ? 'Notificaciones activadas'
                                  : 'Notificaciones desactivadas',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Appearance Section
                    SettingsSectionWidget(
                      icon: LucideIcons.palette,
                      title: 'Apariencia',
                      iconColor: AppColors.info,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 8,
                            bottom: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tema', style: AppTextStyles.labelMedium),
                              const SizedBox(height: 12),
                              SettingsRadioWidget(
                                title: 'Modo Claro',
                                value: 'light',
                                groupValue: _selectedTheme,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTheme = value!;
                                  });
                                  ToastUtils.showInfo(
                                    context: context,
                                    message: 'Tema claro seleccionado',
                                  );
                                },
                              ),
                              SettingsRadioWidget(
                                title: 'Auto (Sistema)',
                                value: 'auto',
                                groupValue: _selectedTheme,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTheme = value!;
                                  });
                                  ToastUtils.showInfo(
                                    context: context,
                                    message: 'Tema automático seleccionado',
                                  );
                                },
                              ),
                              SettingsRadioWidget(
                                title: 'Modo Oscuro',
                                value: 'dark',
                                groupValue: _selectedTheme,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTheme = value!;
                                  });
                                  ToastUtils.showInfo(
                                    context: context,
                                    message: 'Tema oscuro seleccionado',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Support & Help Section
                    SettingsSectionWidget(
                      icon: LucideIcons.circleHelp,
                      title: 'Soporte y Ayuda',
                      iconColor: AppColors.error,
                      children: [
                        SettingsItemWidget(
                          icon: LucideIcons.headphones,
                          title: 'Contactar Soporte',
                          subtitle: 'Obtén ayuda de nuestro equipo',
                          showArrow: true,
                          onTap: () {
                            ToastUtils.showInfo(
                              context: context,
                              message: 'Abriendo soporte...',
                            );
                          },
                        ),
                        SettingsItemWidget(
                          icon: LucideIcons.flag,
                          title: 'Reportar un Problema',
                          subtitle: 'Envía comentarios o problemas',
                          showArrow: true,
                          onTap: () {
                            ToastUtils.showInfo(
                              context: context,
                              message: 'Abriendo reporte...',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Danger Zone
                    DangerZoneWidget(
                      onDeleteAccount: () {
                        _showDeleteAccountDialog();
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Cuenta', style: AppTextStyles.h4),
        content: Text(
          '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
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
              ToastUtils.showError(
                context: context,
                message: 'Función próximamente...',
              );
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
