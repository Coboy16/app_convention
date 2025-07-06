import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/feactures.dart';

class CentralScreen extends StatelessWidget {
  const CentralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _getSelectedView(state),
          bottomNavigationBar: const BottomNavigationWidget(),
        );
      },
    );
  }

  Widget _getSelectedView(NavigationState state) {
    int selectedIndex = 0;

    if (state is NavigationChanged) {
      selectedIndex = state.selectedIndex;
    }

    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const PostScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
