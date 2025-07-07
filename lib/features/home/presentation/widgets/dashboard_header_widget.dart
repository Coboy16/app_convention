import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/data/data.dart';
import '/core/core.dart';
import 'profile_menu_widget.dart'; // <-- IMPORTA EL NUEVO WIDGET

// Convertido a StatefulWidget para manejar el GlobalKey
class DashboardHeaderWidget extends StatefulWidget {
  final DashboardModel dashboard;

  const DashboardHeaderWidget({super.key, required this.dashboard});

  @override
  State<DashboardHeaderWidget> createState() => _DashboardHeaderWidgetState();
}

class _DashboardHeaderWidgetState extends State<DashboardHeaderWidget> {
  final GlobalKey _avatarKey = GlobalKey();

  void _showProfileMenu(BuildContext context) {
    final RenderBox renderBox =
        _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final RelativeRect rect = RelativeRect.fromLTRB(
      position.dx - 220,
      position.dy + size.height + 10,
      position.dx + size.width,
      position.dy + size.height,
    );

    // Mostramos el menú
    showMenu(
      context: context,
      position: rect,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      items: [
        const PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: ProfileMenuWidget(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AutoSizeText(
                    widget.dashboard.eventName,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    widget.dashboard.location,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.dashboard.eventStatus == EventStatus.live
                        ? 'Live'
                        : 'Inactive',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.dashboard.role == UserRole.organizer
                          ? AppColors.warning
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.dashboard.role == UserRole.organizer
                          ? 'ORGANIZER'
                          : 'ATTENDEE',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Ícono de notificaciones
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.bell,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),

        GestureDetector(
          key: _avatarKey,
          onTap: () {
            _showProfileMenu(context);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF8A2BE2),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceVariant,
              child: Text('JD', style: AppTextStyles.caption),
            ),
          ),
        ),
      ],
    );
  }
}
