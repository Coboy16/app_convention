part of 'home_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {
  final UserRole userRole;

  const DashboardLoadRequested({required this.userRole});

  @override
  List<Object> get props => [userRole];
}

class DashboardRefreshRequested extends DashboardEvent {}
