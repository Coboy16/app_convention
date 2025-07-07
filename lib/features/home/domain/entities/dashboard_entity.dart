import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String id;
  final String eventName;
  final String location;
  final EventStatus eventStatus;
  final DashboardStatsEntity stats;
  final List<TodayHighlightEntity> todayHighlights;
  final List<RecentUpdateEntity> recentUpdates;
  final List<SurveyEntity> availableSurveys;
  final DateTime lastUpdated;

  const DashboardEntity({
    required this.id,
    required this.eventName,
    required this.location,
    required this.eventStatus,
    required this.stats,
    required this.todayHighlights,
    required this.recentUpdates,
    required this.availableSurveys,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [
    id,
    eventName,
    location,
    eventStatus,
    stats,
    todayHighlights,
    recentUpdates,
    availableSurveys,
    lastUpdated,
  ];
}

class DashboardStatsEntity extends Equatable {
  final int posts;
  final int people;
  final int? engagement;
  final int? hours;

  const DashboardStatsEntity({
    required this.posts,
    required this.people,
    this.engagement,
    this.hours,
  });

  @override
  List<Object?> get props => [posts, people, engagement, hours];
}

class TodayHighlightEntity extends Equatable {
  final String id;
  final String title;
  final String time;
  final String description;
  final String location;
  final HighlightType type;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;
  final bool isActive;

  const TodayHighlightEntity({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    required this.location,
    required this.type,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    time,
    description,
    location,
    type,
    startTime,
    endTime,
    imageUrl,
    isActive,
  ];
}

class RecentUpdateEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final UpdateType type;
  final DateTime timestamp;
  final String? imageUrl;
  final bool isImportant;

  const RecentUpdateEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.imageUrl,
    required this.isImportant,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    timestamp,
    imageUrl,
    isImportant,
  ];
}

class SurveyEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<SurveyQuestionEntity> questions;
  final DateTime expiresAt;
  final bool isCompleted;
  final int responseCount;

  const SurveyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.expiresAt,
    required this.isCompleted,
    required this.responseCount,
  });

  @override
  List<Object> get props => [
    id,
    title,
    description,
    questions,
    expiresAt,
    isCompleted,
    responseCount,
  ];
}

class SurveyQuestionEntity extends Equatable {
  final String id;
  final String question;
  final QuestionType type;
  final List<String> options;
  final bool isRequired;

  const SurveyQuestionEntity({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.isRequired,
  });

  @override
  List<Object> get props => [id, question, type, options, isRequired];
}

enum EventStatus { upcoming, live, ended }

enum HighlightType { session, breaki, networking, workshop, keynote }

enum UpdateType { general, important, schedule, venue, catering }

enum QuestionType { multipleChoice, singleChoice, text, rating }
