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
    on<TodayHighlightsLoadRequested>(_onTodayHighlightsLoadRequested);
    on<RecentUpdatesLoadRequested>(_onRecentUpdatesLoadRequested);
    on<AvailableSurveysLoadRequested>(_onAvailableSurveysLoadRequested);
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

      final result = await getDashboardUseCase(event.eventId);

      result.fold(
        (failure) {
          debugPrint('❌ Error al cargar dashboard: ${failure.message}');
          if (!emit.isDone) {
            emit(DashboardError(message: failure.message));
          }
        },
        (dashboard) async {
          debugPrint('✅ Dashboard cargado exitosamente');

          // ✅ FIXED: Cargar datos adicionales de forma segura
          List<TodayHighlightEntity> highlights = [];
          List<RecentUpdateEntity> updates = [];
          List<SurveyEntity> surveys = [];

          // Cargar highlights con manejo de errores
          try {
            final highlightsResult = await getTodayHighlightsUseCase(
              event.eventId,
            );
            highlightsResult.fold(
              (failure) => debugPrint(
                '⚠️ Error al cargar highlights: ${failure.message}',
              ),
              (data) => highlights = data,
            );
          } catch (e) {
            debugPrint('⚠️ Error al cargar highlights: $e');
          }

          // Cargar updates con manejo de errores
          try {
            final updatesResult = await getRecentUpdatesUseCase(event.eventId);
            updatesResult.fold(
              (failure) =>
                  debugPrint('⚠️ Error al cargar updates: ${failure.message}'),
              (data) => updates = data,
            );
          } catch (e) {
            debugPrint('⚠️ Error al cargar updates: $e');
          }

          // Cargar surveys con manejo de errores
          try {
            final surveysResult = await getAvailableSurveysUseCase(
              event.eventId,
            );
            surveysResult.fold(
              (failure) =>
                  debugPrint('⚠️ Error al cargar surveys: ${failure.message}'),
              (data) => surveys = data,
            );
          } catch (e) {
            debugPrint('⚠️ Error al cargar surveys: $e');
          }

          // ✅ FIXED: Verificar que el emit sigue activo antes de emitir
          if (!emit.isDone) {
            // Crear dashboard completo
            final completeDashboard = DashboardEntity(
              id: dashboard.id,
              eventName: dashboard.eventName,
              location: dashboard.location,
              eventStatus: dashboard.eventStatus,
              stats: dashboard.stats,
              todayHighlights: highlights,
              recentUpdates: updates,
              availableSurveys: surveys,
              lastUpdated: dashboard.lastUpdated,
            );

            emit(DashboardLoaded(dashboard: completeDashboard));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error inesperado: ${e.toString()}');
      if (!emit.isDone) {
        emit(DashboardError(message: 'Error inesperado: ${e.toString()}'));
      }
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

  Future<void> _onTodayHighlightsLoadRequested(
    TodayHighlightsLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final result = await getTodayHighlightsUseCase(event.eventId);

      result.fold(
        (failure) =>
            debugPrint('❌ Error al cargar highlights: ${failure.message}'),
        (highlights) {
          debugPrint('✅ Highlights cargados: ${highlights.length}');
          if (!emit.isDone) {
            emit(TodayHighlightsLoaded(highlights: highlights));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error inesperado al cargar highlights: $e');
    }
  }

  Future<void> _onRecentUpdatesLoadRequested(
    RecentUpdatesLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final result = await getRecentUpdatesUseCase(event.eventId);

      result.fold(
        (failure) =>
            debugPrint('❌ Error al cargar updates: ${failure.message}'),
        (updates) {
          debugPrint('✅ Updates cargados: ${updates.length}');
          if (!emit.isDone) {
            emit(RecentUpdatesLoaded(updates: updates));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error inesperado al cargar updates: $e');
    }
  }

  Future<void> _onAvailableSurveysLoadRequested(
    AvailableSurveysLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final result = await getAvailableSurveysUseCase(event.eventId);

      result.fold(
        (failure) =>
            debugPrint('❌ Error al cargar surveys: ${failure.message}'),
        (surveys) {
          debugPrint('✅ Surveys cargados: ${surveys.length}');
          if (!emit.isDone) {
            emit(AvailableSurveysLoaded(surveys: surveys));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error inesperado al cargar surveys: $e');
    }
  }

  Future<void> _onSurveyResponseSubmitted(
    SurveyResponseSubmitted event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      debugPrint('📤 Enviando respuesta de survey: ${event.surveyId}');
      if (!emit.isDone) {
        emit(SurveySubmitting());
      }

      final result = await submitSurveyResponseUseCase(
        surveyId: event.surveyId,
        userId: event.userId,
        responses: event.responses,
      );

      result.fold(
        (failure) {
          debugPrint('❌ Error al enviar survey: ${failure.message}');
          if (!emit.isDone) {
            emit(SurveySubmissionError(message: failure.message));
          }
        },
        (_) {
          debugPrint('✅ Survey enviado exitosamente');
          if (!emit.isDone) {
            emit(SurveySubmitted());
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error inesperado al enviar survey: ${e.toString()}');
      if (!emit.isDone) {
        emit(
          SurveySubmissionError(message: 'Error inesperado: ${e.toString()}'),
        );
      }
    }
  }
}
