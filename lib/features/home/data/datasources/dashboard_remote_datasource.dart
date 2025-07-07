import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/core/errors/exceptions.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboard(String eventId);
  Future<List<TodayHighlightModel>> getTodayHighlights(String eventId);
  Future<List<RecentUpdateModel>> getRecentUpdates(String eventId);
  Future<List<SurveyModel>> getAvailableSurveys(String eventId);
  Future<void> submitSurveyResponse({
    required String surveyId,
    required String userId,
    required Map<String, dynamic> responses,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<DashboardModel> getDashboard(String eventId) async {
    try {
      debugPrint('🔍 Obteniendo dashboard para eventId: $eventId');

      final doc = await firestore.collection('events').doc(eventId).get();

      if (!doc.exists) {
        debugPrint('❌ Evento no encontrado: $eventId');
        throw const ServerException('Evento no encontrado');
      }

      debugPrint('✅ Dashboard encontrado para evento: $eventId');
      return DashboardModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Error al obtener dashboard: ${e.toString()}');
      throw ServerException('Error al obtener dashboard: ${e.toString()}');
    }
  }

  @override
  Future<List<TodayHighlightModel>> getTodayHighlights(String eventId) async {
    try {
      debugPrint('🔍 Obteniendo highlights para eventId: $eventId');

      // ✅ SIMPLIFIED: Query simple sin filtros complejos
      final querySnapshot = await firestore
          .collection('events')
          .doc(eventId)
          .collection('highlights')
          .where('isActive', isEqualTo: true)
          .get(); // Remover orderBy para evitar índices complejos

      debugPrint('📊 Highlights encontrados: ${querySnapshot.docs.length}');

      final highlights = querySnapshot.docs
          .map((doc) => TodayHighlightModel.fromFirestore(doc))
          .toList();

      // Ordenar en memoria por startTime si existe
      highlights.sort((a, b) => a.startTime.compareTo(b.startTime));

      return highlights;
    } catch (e) {
      debugPrint('❌ Error al obtener highlights: ${e.toString()}');
      // ✅ NO lanzar excepción, retornar lista vacía
      return [];
    }
  }

  @override
  Future<List<RecentUpdateModel>> getRecentUpdates(String eventId) async {
    try {
      debugPrint('🔍 Obteniendo updates para eventId: $eventId');

      // ✅ SIMPLIFIED: Query simple
      final querySnapshot = await firestore
          .collection('events')
          .doc(eventId)
          .collection('updates')
          .limit(10)
          .get(); // Remover orderBy para evitar índices

      debugPrint('📊 Updates encontrados: ${querySnapshot.docs.length}');

      final updates = querySnapshot.docs
          .map((doc) => RecentUpdateModel.fromFirestore(doc))
          .toList();

      // Ordenar en memoria por timestamp
      updates.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return updates;
    } catch (e) {
      debugPrint('❌ Error al obtener updates: ${e.toString()}');
      // ✅ NO lanzar excepción, retornar lista vacía
      return [];
    }
  }

  @override
  Future<List<SurveyModel>> getAvailableSurveys(String eventId) async {
    try {
      debugPrint('🔍 Obteniendo surveys para eventId: $eventId');

      // ✅ SIMPLIFIED: Query simple sin filtros de fecha
      final querySnapshot = await firestore
          .collection('events')
          .doc(eventId)
          .collection('surveys')
          .get();

      debugPrint('📊 Surveys encontrados: ${querySnapshot.docs.length}');

      final surveys = querySnapshot.docs
          .map((doc) => SurveyModel.fromFirestore(doc))
          .toList();

      // Filtrar en memoria los surveys que no han expirado
      final now = DateTime.now();
      final activeSurveys = surveys
          .where((survey) => survey.expiresAt.isAfter(now))
          .toList();

      return activeSurveys;
    } catch (e) {
      debugPrint('❌ Error al obtener surveys: ${e.toString()}');
      // ✅ NO lanzar excepción, retornar lista vacía
      return [];
    }
  }

  @override
  Future<void> submitSurveyResponse({
    required String surveyId,
    required String userId,
    required Map<String, dynamic> responses,
  }) async {
    try {
      debugPrint(
        '📤 Enviando respuesta de survey: $surveyId para user: $userId',
      );

      final responseData = {
        'surveyId': surveyId,
        'userId': userId,
        'responses': responses,
        'submittedAt': Timestamp.fromDate(DateTime.now()),
      };

      await firestore.collection('survey_responses').add(responseData);

      debugPrint('✅ Respuesta de survey enviada exitosamente');
    } catch (e) {
      debugPrint('❌ Error al enviar respuesta de survey: ${e.toString()}');
      throw ServerException('Error al enviar respuesta: ${e.toString()}');
    }
  }
}
