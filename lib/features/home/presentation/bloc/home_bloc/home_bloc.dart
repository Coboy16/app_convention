import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konecta/features/home/domain/domain.dart';

part 'home_event.dart';
part 'home_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;
  final GetTodayHighlightsUseCase getTodayHighlightsUseCase;
  final GetRecentUpdatesUseCase getRecentUpdatesUseCase;
  final GetAvailableSurveysUseCase getAvailableSurveysUseCase;
  final SubmitSurveyResponseUseCase submitSurveyResponseUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
    required this.getTodayHighlightsUseCase,
    required this.getRecentUpdatesUseCase,
    required this.getAvailableSurveysUseCase,
    required this.submitSurveyResponseUseCase,
  }) : super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
    on<DashboardRefreshRequested>(_onDashboardRefreshRequested);
    on<SurveyResponseSubmitted>(_onSurveyResponseSubmitted);

    debugPrint('🟢 DashboardBloc inicializado');
  }

  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      debugPrint('🔄 DashboardLoadRequested para eventId: ${event.eventId}');
      emit(DashboardLoading());

      // ✅ SIMPLIFICADO: Cargar todo en paralelo
      final results = await Future.wait([
        getDashboardUseCase(event.eventId),
        getTodayHighlightsUseCase(event.eventId),
        getRecentUpdatesUseCase(event.eventId),
        getAvailableSurveysUseCase(event.eventId),
      ]);

      final dashboardResult = results[0];
      final highlightsResult = results[1];
      final updatesResult = results[2];
      final surveysResult = results[3];

      // Procesar resultados
      DashboardEntity? dashboard;
      List<TodayHighlightEntity> highlights = [];
      List<RecentUpdateEntity> updates = [];
      List<SurveyEntity> surveys = [];

      // Dashboard principal
      dashboardResult.fold((failure) {
        debugPrint('❌ Error dashboard: ${failure.message}');
        emit(DashboardError(message: failure.message));
        return;
      }, (data) => dashboard = data as DashboardEntity);

      // Highlights
      highlightsResult.fold(
        (failure) => debugPrint('⚠️ Error highlights: ${failure.message}'),
        (data) => highlights = data as List<TodayHighlightEntity>,
      );

      // Updates
      updatesResult.fold(
        (failure) => debugPrint('⚠️ Error updates: ${failure.message}'),
        (data) => updates = data as List<RecentUpdateEntity>,
      );

      // Surveys
      surveysResult.fold(
        (failure) => debugPrint('⚠️ Error surveys: ${failure.message}'),
        (data) => surveys = data as List<SurveyEntity>,
      );

      // ✅ CREAR DASHBOARD COMPLETO
      if (dashboard != null) {
        final completeDashboard = DashboardEntity(
          id: dashboard!.id,
          eventName: dashboard!.eventName,
          location: dashboard!.location,
          eventStatus: dashboard!.eventStatus,
          stats: dashboard!.stats,
          todayHighlights: highlights,
          recentUpdates: updates,
          availableSurveys: surveys,
          lastUpdated: dashboard!.lastUpdated,
        );

        debugPrint('✅ Dashboard completo creado con:');
        debugPrint('   - Highlights: ${highlights.length}');
        debugPrint('   - Updates: ${updates.length}');
        debugPrint('   - Surveys: ${surveys.length}');

        emit(DashboardLoaded(dashboard: completeDashboard));
      }
    } catch (e) {
      debugPrint('❌ Error inesperado: ${e.toString()}');
      emit(DashboardError(message: 'Error inesperado: ${e.toString()}'));
    }
  }

  Future<void> _onDashboardRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      add(DashboardLoadRequested(eventId: currentState.dashboard.id));
    }
  }

  Future<void> _onSurveyResponseSubmitted(
    SurveyResponseSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      debugPrint('📤 Enviando respuesta de survey: ${event.surveyId}');
      emit(SurveySubmitting());

      final result = await submitSurveyResponseUseCase(
        surveyId: event.surveyId,
        userId: event.userId,
        responses: event.responses,
      );

      result.fold(
        (failure) {
          debugPrint('❌ Error al enviar survey: ${failure.message}');
          emit(SurveySubmissionError(message: failure.message));
        },
        (_) {
          debugPrint('✅ Survey enviado exitosamente');
          emit(SurveySubmitted());
        },
      );
    } catch (e) {
      debugPrint('❌ Error inesperado al enviar survey: ${e.toString()}');
      emit(SurveySubmissionError(message: 'Error inesperado: ${e.toString()}'));
    }
  }
}
