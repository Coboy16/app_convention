part of 'home_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboard;

  const DashboardLoaded({required this.dashboard});

  @override
  List<Object> get props => [dashboard];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}

class TodayHighlightsLoaded extends DashboardState {
  final List<TodayHighlightEntity> highlights;

  const TodayHighlightsLoaded({required this.highlights});

  @override
  List<Object> get props => [highlights];
}

class RecentUpdatesLoaded extends DashboardState {
  final List<RecentUpdateEntity> updates;

  const RecentUpdatesLoaded({required this.updates});

  @override
  List<Object> get props => [updates];
}

class AvailableSurveysLoaded extends DashboardState {
  final List<SurveyEntity> surveys;

  const AvailableSurveysLoaded({required this.surveys});

  @override
  List<Object> get props => [surveys];
}

class SurveySubmitting extends DashboardState {}

class SurveySubmitted extends DashboardState {}

class SurveySubmissionError extends DashboardState {
  final String message;

  const SurveySubmissionError({required this.message});

  @override
  List<Object> get props => [message];
}
