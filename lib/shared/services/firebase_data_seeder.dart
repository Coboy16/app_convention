// lib/core/utils/firebase_data_seeder.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Método SIMPLIFICADO para insertar datos - PASO A PASO
  static Future<void> seedDashboardData() async {
    try {
      debugPrint('🌱 Iniciando inserción de datos de prueba...');

      // Verificar que el usuario esté autenticado
      debugPrint('🔍 Verificando autenticación...');

      // 1. Solo crear el evento principal primero
      await _createMainEvent();

      debugPrint('✅ Datos básicos insertados exitosamente!');
    } catch (e) {
      debugPrint('❌ Error detallado: $e');
      debugPrint('❌ Tipo de error: ${e.runtimeType}');
      if (e.toString().contains('permission-denied')) {
        debugPrint('🚨 PROBLEMA DE PERMISOS - Revisa las reglas de Firestore');
      }
    }
  }

  static Future<void> _createMainEvent() async {
    try {
      debugPrint('📝 Creando evento principal...');

      const eventId = 'event_2024_convention';

      // Verificar si ya existe
      final existingDoc = await _firestore
          .collection('events')
          .doc(eventId)
          .get();
      if (existingDoc.exists) {
        debugPrint('⚠️ El evento ya existe, saltando creación');
        return;
      }

      final eventData = {
        'eventName': 'Convención Tech 2024',
        'location': 'Lima, Perú',
        'eventStatus': 'live',
        'stats': {'posts': 156, 'people': 89, 'engagement': 95, 'hours': 12},
        'lastUpdated': FieldValue.serverTimestamp(), // Usar server timestamp
      };

      debugPrint('📤 Enviando datos a Firestore...');
      await _firestore.collection('events').doc(eventId).set(eventData);
      debugPrint('✅ Evento principal creado exitosamente');
    } catch (e) {
      debugPrint('❌ Error al crear evento principal: $e');
      rethrow;
    }
  }

  /// Método para agregar highlights después de que funcione el principal
  static Future<void> addHighlights() async {
    try {
      debugPrint('🌟 Agregando highlights...');
      const eventId = 'event_2024_convention';

      final highlights = [
        {
          'title': 'Keynote de Apertura',
          'time': '9:00 AM',
          'description': 'Presentación inaugural del evento.',
          'location': 'Auditorio Principal',
          'type': 'keynote',
          'startTime': FieldValue.serverTimestamp(),
          'endTime': FieldValue.serverTimestamp(),
          'imageUrl': null,
          'isActive': true,
        },
        {
          'title': 'Workshop Flutter',
          'time': '11:00 AM',
          'description': 'Taller práctico de Flutter.',
          'location': 'Sala A',
          'type': 'workshop',
          'startTime': FieldValue.serverTimestamp(),
          'endTime': FieldValue.serverTimestamp(),
          'imageUrl': null,
          'isActive': true,
        },
      ];

      for (int i = 0; i < highlights.length; i++) {
        await _firestore
            .collection('events')
            .doc(eventId)
            .collection('highlights')
            .add(highlights[i]);
        debugPrint('✅ Highlight ${i + 1} creado');
      }

      debugPrint('✅ Todos los highlights creados');
    } catch (e) {
      debugPrint('❌ Error al crear highlights: $e');
    }
  }

  /// Método para agregar updates
  static Future<void> addUpdates() async {
    try {
      debugPrint('📢 Agregando updates...');
      const eventId = 'event_2024_convention';

      final updates = [
        {
          'title': 'Bienvenidos al evento',
          'description': 'Esperamos que disfruten la experiencia.',
          'type': 'general',
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': null,
          'isImportant': false,
        },
        {
          'title': 'Cambio de horario',
          'description': 'El workshop se adelanta 30 minutos.',
          'type': 'schedule',
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': null,
          'isImportant': true,
        },
      ];

      for (int i = 0; i < updates.length; i++) {
        await _firestore
            .collection('events')
            .doc(eventId)
            .collection('updates')
            .add(updates[i]);
        debugPrint('✅ Update ${i + 1} creado');
      }

      debugPrint('✅ Todos los updates creados');
    } catch (e) {
      debugPrint('❌ Error al crear updates: $e');
    }
  }

  /// Método para agregar surveys
  static Future<void> addSurveys() async {
    try {
      debugPrint('📊 Agregando surveys...');
      const eventId = 'event_2024_convention';

      final survey = {
        'title': 'Evaluación del Evento',
        'description': 'Comparte tu opinión sobre el evento.',
        'questions': [
          {
            'id': 'q1',
            'question': '¿Cómo calificarías el evento?',
            'type': 'rating',
            'options': [],
            'isRequired': true,
          },
          {
            'id': 'q2',
            'question': '¿Qué te gustó más?',
            'type': 'singleChoice',
            'options': ['Contenido', 'Networking', 'Organización'],
            'isRequired': true,
          },
        ],
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7)),
        ),
        'isCompleted': false,
        'responseCount': 0,
      };

      await _firestore
          .collection('events')
          .doc(eventId)
          .collection('surveys')
          .add(survey);

      debugPrint('✅ Survey creado');
    } catch (e) {
      debugPrint('❌ Error al crear survey: $e');
    }
  }

  /// Método para crear TODO de una vez (usar después de probar el básico)
  static Future<void> seedAllData() async {
    await seedDashboardData();
    await Future.delayed(const Duration(seconds: 1));
    await addHighlights();
    await Future.delayed(const Duration(seconds: 1));
    await addUpdates();
    await Future.delayed(const Duration(seconds: 1));
    await addSurveys();
  }

  /// Método de prueba simple
  static Future<void> testConnection() async {
    try {
      debugPrint('🧪 Probando conexión a Firestore...');

      await _firestore.collection('test').add({
        'message': 'Test connection',
        'timestamp': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Conexión exitosa - puedes borrar el documento "test"');
    } catch (e) {
      debugPrint('❌ Error de conexión: $e');
    }
  }
}
