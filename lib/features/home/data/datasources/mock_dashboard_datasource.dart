import 'package:flutter/material.dart';
import 'package:konecta/features/home/domain/entities/dashboard_entity.dart';
import '/core/data/local_dashboard_data.dart';
import '/core/errors/exceptions.dart';
import '../models/dashboard_model.dart';

class MockDashboardDataSource {
  static Future<DashboardModel> getDashboard(String eventId) async {
    try {
      debugPrint('🔍 [MOCK] Obteniendo dashboard para eventId: $eventId');

      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));

      final data = LocalDashboardData.dashboardData;

      final dashboard = DashboardModel(
        id: data['id'],
        eventName: data['eventName'],
        location: data['location'],
        eventStatus: _parseEventStatus(data['eventStatus']),
        stats: DashboardStatsModel.fromMap(data['stats']),
        todayHighlights: [],
        recentUpdates: [],
        availableSurveys: [],
        lastUpdated: DateTime.parse(data['lastUpdated']),
      );

      debugPrint('✅ [MOCK] Dashboard cargado exitosamente');
      return dashboard;
    } catch (e) {
      debugPrint('❌ [MOCK] Error al obtener dashboard: ${e.toString()}');
      throw ServerException('Error al obtener dashboard: ${e.toString()}');
    }
  }

  static Future<List<TodayHighlightModel>> getTodayHighlights(
    String eventId,
  ) async {
    try {
      debugPrint('🔍 [MOCK] Obteniendo highlights para eventId: $eventId');

      // Simular delay
      await Future.delayed(const Duration(milliseconds: 300));

      final data = LocalDashboardData.dashboardData;
      final highlightsData = data['todayHighlights'] as List;

      final highlights = highlightsData
          .map(
            (item) => TodayHighlightModel(
              id: item['id'],
              title: item['title'],
              time: item['time'],
              description: item['description'],
              location: item['location'],
              type: _parseHighlightType(item['type']),
              startTime: DateTime.parse(item['startTime']),
              endTime: DateTime.parse(item['endTime']),
              imageUrl: item['imageUrl'],
              isActive: item['isActive'],
            ),
          )
          .toList();

      debugPrint('📊 [MOCK] Highlights encontrados: ${highlights.length}');
      return highlights;
    } catch (e) {
      debugPrint('❌ [MOCK] Error al obtener highlights: ${e.toString()}');
      return [];
    }
  }

  static Future<List<RecentUpdateModel>> getRecentUpdates(
    String eventId,
  ) async {
    try {
      debugPrint('🔍 [MOCK] Obteniendo updates para eventId: $eventId');

      // Simular delay
      await Future.delayed(const Duration(milliseconds: 200));

      final data = LocalDashboardData.dashboardData;
      final updatesData = data['recentUpdates'] as List;

      final updates = updatesData
          .map(
            (item) => RecentUpdateModel(
              id: item['id'],
              title: item['title'],
              description: item['description'],
              type: _parseUpdateType(item['type']),
              timestamp: DateTime.parse(item['timestamp']),
              imageUrl: item['imageUrl'],
              isImportant: item['isImportant'],
            ),
          )
          .toList();

      debugPrint('📊 [MOCK] Updates encontrados: ${updates.length}');
      return updates;
    } catch (e) {
      debugPrint('❌ [MOCK] Error al obtener updates: ${e.toString()}');
      return [];
    }
  }

  static Future<List<SurveyModel>> getAvailableSurveys(String eventId) async {
    try {
      debugPrint('🔍 [MOCK] Obteniendo surveys para eventId: $eventId');

      // Simular delay
      await Future.delayed(const Duration(milliseconds: 400));

      final data = LocalDashboardData.dashboardData;
      final surveysData = data['availableSurveys'] as List;

      final surveys = surveysData.map((item) {
        final questionsData = item['questions'] as List;
        final questions = questionsData
            .map(
              (q) => SurveyQuestionModel(
                id: q['id'],
                question: q['question'],
                type: _parseQuestionType(q['type']),
                options: List<String>.from(q['options']),
                isRequired: q['isRequired'],
              ),
            )
            .toList();

        return SurveyModel(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          questions: questions,
          expiresAt: DateTime.parse(item['expiresAt']),
          isCompleted: item['isCompleted'],
          responseCount: item['responseCount'],
        );
      }).toList();

      debugPrint('📊 [MOCK] Surveys encontrados: ${surveys.length}');
      return surveys;
    } catch (e) {
      debugPrint('❌ [MOCK] Error al obtener surveys: ${e.toString()}');
      return [];
    }
  }

  static Future<void> submitSurveyResponse({
    required String surveyId,
    required String userId,
    required Map<String, dynamic> responses,
  }) async {
    try {
      debugPrint('📤 [MOCK] Enviando respuesta de survey: $surveyId');

      // Simular delay de envío
      await Future.delayed(const Duration(milliseconds: 800));

      debugPrint('✅ [MOCK] Respuesta de survey enviada exitosamente');
    } catch (e) {
      debugPrint('❌ [MOCK] Error al enviar respuesta: ${e.toString()}');
      throw ServerException('Error al enviar respuesta: ${e.toString()}');
    }
  }

  // Helper methods
  static EventStatus _parseEventStatus(String? status) {
    switch (status) {
      case 'upcoming':
        return EventStatus.upcoming;
      case 'live':
        return EventStatus.live;
      case 'ended':
        return EventStatus.ended;
      default:
        return EventStatus.upcoming;
    }
  }

  static HighlightType _parseHighlightType(String? type) {
    switch (type) {
      case 'session':
        return HighlightType.session;
      case 'break':
        return HighlightType.breaki;
      case 'networking':
        return HighlightType.networking;
      case 'workshop':
        return HighlightType.workshop;
      case 'keynote':
        return HighlightType.keynote;
      default:
        return HighlightType.session;
    }
  }

  static UpdateType _parseUpdateType(String? type) {
    switch (type) {
      case 'general':
        return UpdateType.general;
      case 'important':
        return UpdateType.important;
      case 'schedule':
        return UpdateType.schedule;
      case 'venue':
        return UpdateType.venue;
      case 'catering':
        return UpdateType.catering;
      default:
        return UpdateType.general;
    }
  }

  static QuestionType _parseQuestionType(String? type) {
    switch (type) {
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'singleChoice':
        return QuestionType.singleChoice;
      case 'text':
        return QuestionType.text;
      case 'rating':
        return QuestionType.rating;
      default:
        return QuestionType.singleChoice;
    }
  }
}
