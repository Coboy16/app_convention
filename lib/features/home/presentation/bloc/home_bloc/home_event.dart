part of 'home_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {
  final String eventId;

  const DashboardLoadRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class DashboardRefreshRequested extends DashboardEvent {}

class TodayHighlightsLoadRequested extends DashboardEvent {
  final String eventId;

  const TodayHighlightsLoadRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class RecentUpdatesLoadRequested extends DashboardEvent {
  final String eventId;

  const RecentUpdatesLoadRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class AvailableSurveysLoadRequested extends DashboardEvent {
  final String eventId;

  const AvailableSurveysLoadRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class SurveyResponseSubmitted extends DashboardEvent {
  final String surveyId;
  final String userId;
  final Map<String, dynamic> responses;

  const SurveyResponseSubmitted({
    required this.surveyId,
    required this.userId,
    required this.responses,
  });

  @override
  List<Object> get props => [surveyId, userId, responses];
}
