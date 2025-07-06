import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:konecta/features/home/data/data.dart';

part 'home_event.dart';
part 'home_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
    on<DashboardRefreshRequested>(_onDashboardRefreshRequested);
  }

  DashboardModel? _currentDashboard;

  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      // Cargar dashboard según el rol del usuario
      final dashboard = event.userRole == UserRole.organizer
          ? DashboardModel.mockOrganizerDashboard
          : DashboardModel.mockParticipantDashboard;

      _currentDashboard = dashboard;
      emit(DashboardLoaded(dashboard: dashboard));
    } catch (e) {
      emit(
        DashboardError(
          message: 'Error al cargar el dashboard: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDashboardRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_currentDashboard != null) {
        // Simular refresh
        await Future.delayed(const Duration(milliseconds: 500));

        emit(DashboardLoaded(dashboard: _currentDashboard!));
      }
    } catch (e) {
      emit(
        DashboardError(
          message: 'Error al refrescar el dashboard: ${e.toString()}',
        ),
      );
    }
  }

  // Helper methods
  void loadDashboard(UserRole userRole) {
    add(DashboardLoadRequested(userRole: userRole));
  }

  void refreshDashboard() {
    add(DashboardRefreshRequested());
  }
}
