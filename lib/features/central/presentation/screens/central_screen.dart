import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/feactures.dart';

class CentralScreen extends StatefulWidget {
  const CentralScreen({super.key});

  @override
  State<CentralScreen> createState() => _CentralScreenState();
}

class _CentralScreenState extends State<CentralScreen> {
  bool _profileInitialized = false;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    context.read<NavigationBloc>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state is NavigationChanged &&
            state.selectedIndex == 2 &&
            !_profileInitialized) {
          _loadUserProfile();
          _profileInitialized = true;
        }
      },
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: _getSelectedView(state),
            bottomNavigationBar: const BottomNavigationWidget(),
          );
        },
      ),
    );
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

  Widget _getSelectedView(NavigationState state) {
    int selectedIndex = 0;

    if (state is NavigationChanged) {
      selectedIndex = state.selectedIndex;
    }

    switch (selectedIndex) {
      case 0:
        // return const OrganizerDashboardScreen();
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
