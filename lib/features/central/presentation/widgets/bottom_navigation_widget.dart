import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/central/presentation/bloc/blocs.dart';
import '/core/core.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;

        if (state is NavigationChanged) {
          currentIndex = state.selectedIndex;
        }

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.inputBorder, width: 1),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 60, // Reducido de 64 a 60
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavigationItem(
                    context: context,
                    icon: LucideIcons.house,
                    label: 'Home',
                    index: 0,
                    isSelected: currentIndex == 0,
                  ),
                  _buildNavigationItem(
                    context: context,
                    icon: LucideIcons.messageCircle,
                    label: 'Feed',
                    index: 1,
                    isSelected: currentIndex == 1,
                  ),
                  _buildNavigationItem(
                    context: context,
                    icon: LucideIcons.user,
                    label: 'Profile',
                    index: 2,
                    isSelected: currentIndex == 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<NavigationBloc>().add(
            NavigationTabSelected(index: index),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                size: 22,
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
