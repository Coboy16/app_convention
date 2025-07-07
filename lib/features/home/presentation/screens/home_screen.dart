import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/bloc/blocs.dart';
import '/features/home/presentation/screens/organizer_dashboard_screen.dart';
import '/features/home/presentation/screens/participant_dashboard_screen.dart';
import '/core/core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Verificar si hay usuario autenticado
        final user = authState.user;

        if (user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // ✅ DETECCIÓN SIMPLE POR ROL
        final userRole = user.role;
        debugPrint('👤 Usuario: ${user.name} | Rol: $userRole');

        if (userRole != 'organizer') {
          debugPrint('🎯 Navegando a Organizer Dashboard');
          return const OrganizerDashboardScreen();
        } else {
          debugPrint('🎯 Navegando a Participant Dashboard');
          return const ParticipantDashboardScreen();
        }
      },
    );
  }
}
