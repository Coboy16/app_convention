import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.id,
    required super.eventName,
    required super.location,
    required super.eventStatus,
    required super.stats,
    required super.todayHighlights,
    required super.recentUpdates,
    required super.availableSurveys,
    required super.lastUpdated,
  });

  factory DashboardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DashboardModel(
      id: doc.id,
      eventName: data['eventName'] ?? '',
      location: data['location'] ?? '',
      eventStatus: _parseEventStatus(data['eventStatus']),
      stats: DashboardStatsModel.fromMap(data['stats'] ?? {}),
      todayHighlights: [],
      recentUpdates: [],
      availableSurveys: [],
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

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

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'location': location,
      'eventStatus': eventStatus.name,
      'stats': (stats as DashboardStatsModel).toMap(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.posts,
    required super.people,
    super.engagement,
    super.hours,
  });

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      posts: map['posts'] ?? 0,
      people: map['people'] ?? 0,
      engagement: map['engagement'],
      hours: map['hours'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'posts': posts,
      'people': people,
      'engagement': engagement,
      'hours': hours,
    };
  }
}

class TodayHighlightModel extends TodayHighlightEntity {
  const TodayHighlightModel({
    required super.id,
    required super.title,
    required super.time,
    required super.description,
    required super.location,
    required super.type,
    required super.startTime,
    required super.endTime,
    super.imageUrl,
    required super.isActive,
  });

  factory TodayHighlightModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TodayHighlightModel(
      id: doc.id,
      title: data['title'] ?? '',
      time: data['time'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      type: _parseHighlightType(data['type']),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
    );
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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'description': description,
      'location': location,
      'type': type.name,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }
}

class RecentUpdateModel extends RecentUpdateEntity {
  const RecentUpdateModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.timestamp,
    super.imageUrl,
    required super.isImportant,
  });

  factory RecentUpdateModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RecentUpdateModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: _parseUpdateType(data['type']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      isImportant: data['isImportant'] ?? false,
    );
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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'isImportant': isImportant,
    };
  }
}

class SurveyModel extends SurveyEntity {
  const SurveyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.questions,
    required super.expiresAt,
    required super.isCompleted,
    required super.responseCount,
  });

  factory SurveyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SurveyModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      questions: (data['questions'] as List<dynamic>?)
              ?.map((q) => SurveyQuestionModel.fromMap(q))
              .toList() ??
          [],
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      responseCount: data['responseCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'questions': questions.map((q) => (q as SurveyQuestionModel).toMap()).toList(),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isCompleted': isCompleted,
      'responseCount': responseCount,
    };
  }
}

class SurveyQuestionModel extends SurveyQuestionEntity {
  const SurveyQuestionModel({
    required super.id,
    required super.question,
    required super.type,
    required super.options,
    required super.isRequired,
  });

  factory SurveyQuestionModel.fromMap(Map<String, dynamic> map) {
    return SurveyQuestionModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      type: _parseQuestionType(map['type']),
      options: List<String>.from(map['options'] ?? []),
      isRequired: map['isRequired'] ?? false,
    );
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'type': type.name,
      'options': options,
      'isRequired': isRequired,
    };
  }
}