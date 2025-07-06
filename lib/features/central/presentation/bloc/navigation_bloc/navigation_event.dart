part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationTabSelected extends NavigationEvent {
  final int index;

  const NavigationTabSelected({required this.index});

  @override
  List<Object> get props => [index];
}

class NavigationInitialized extends NavigationEvent {}

class NavigationReset extends NavigationEvent {}
