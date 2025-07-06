part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationChanged extends NavigationState {
  final int selectedIndex;

  const NavigationChanged({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

class NavigationError extends NavigationState {
  final String message;

  const NavigationError({required this.message});

  @override
  List<Object> get props => [message];
}
