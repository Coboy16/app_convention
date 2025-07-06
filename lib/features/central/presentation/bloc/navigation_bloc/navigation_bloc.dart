import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationInitialized>(_onNavigationInitialized);
    on<NavigationTabSelected>(_onNavigationTabSelected);
    on<NavigationReset>(_onNavigationReset);
  }

  void _onNavigationInitialized(
    NavigationInitialized event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationChanged(selectedIndex: 0));
  }

  void _onNavigationTabSelected(
    NavigationTabSelected event,
    Emitter<NavigationState> emit,
  ) {
    try {
      // Validar que el índice esté en el rango válido (0-2)
      if (event.index < 0 || event.index > 2) {
        emit(const NavigationError(message: 'Índice de navegación inválido'));
        return;
      }

      // Emitir directamente el nuevo estado sin delay
      emit(NavigationChanged(selectedIndex: event.index));
    } catch (e) {
      emit(
        NavigationError(
          message: 'Error al cambiar de pestaña: ${e.toString()}',
        ),
      );
    }
  }

  void _onNavigationReset(
    NavigationReset event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationChanged(selectedIndex: 0));
  }

  // Métodos helper para facilitar el uso
  void selectHomeTab() {
    add(const NavigationTabSelected(index: 0));
  }

  void selectFeedTab() {
    add(const NavigationTabSelected(index: 1));
  }

  void selectProfileTab() {
    add(const NavigationTabSelected(index: 2));
  }

  void initialize() {
    add(NavigationInitialized());
  }

  void reset() {
    add(NavigationReset());
  }
}
