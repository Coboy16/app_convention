import 'package:equatable/equatable.dart';

class DashboardModel extends Equatable {
  final String userId;
  final UserRole role;
  final String eventName;
  final String location;
  final EventStatus eventStatus;
  final DashboardStats stats;
  final List<ActionItem> actionItems;
  final List<RecentActivity> recentActivities;
  final List<EventOperation> eventOperations;
  final List<TodayHighlight> todayHighlights;

  const DashboardModel({
    required this.userId,
    required this.role,
    required this.eventName,
    required this.location,
    required this.eventStatus,
    required this.stats,
    required this.actionItems,
    required this.recentActivities,
    required this.eventOperations,
    required this.todayHighlights,
  });

  @override
  List<Object> get props => [
    userId,
    role,
    eventName,
    location,
    eventStatus,
    stats,
    actionItems,
    recentActivities,
    eventOperations,
    todayHighlights,
  ];

  // Mock data para organizador
  static DashboardModel get mockOrganizerDashboard => DashboardModel(
    userId: 'org1',
    role: UserRole.organizer,
    eventName: 'Convention 2024',
    location: 'Lima, Perú',
    eventStatus: EventStatus.live,
    stats: const DashboardStats(
      posts: 156,
      people: 89,
      engagement: 95,
      hours: null,
    ),
    actionItems: [
      const ActionItem(
        id: '1',
        title: 'Enviar notificación de cambio de lugar de almuerzo',
        type: ActionType.notification,
      ),
      const ActionItem(
        id: '2',
        title: 'Aprobar 2 nuevas publicaciones de asistentes',
        type: ActionType.approval,
      ),
      const ActionItem(
        id: '3',
        title: 'Actualizar horario del taller de la tarde',
        type: ActionType.update,
      ),
    ],
    recentActivities: [
      RecentActivity(
        id: '1',
        description: '📝 María publicó nuevo contenido',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        type: ActivityType.post,
      ),
      RecentActivity(
        id: '2',
        description: '👍 15 nuevos likes en tu publicación',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: ActivityType.like,
      ),
    ],
    eventOperations: [
      const EventOperation(
        title: 'Todos los Servicios Funcionando Sin Problemas',
        details: [
          OperationDetail(
            icon: 'app',
            title: 'App',
            value: '156 usuarios activos',
            status: OperationStatus.good,
          ),
          OperationDetail(
            icon: 'venue',
            title: 'Lugar',
            value: 'Convention Center conectado',
            status: OperationStatus.good,
          ),
          OperationDetail(
            icon: 'engagement',
            title: 'Participación',
            value: '95% participación',
            status: OperationStatus.excellent,
          ),
        ],
        lastUpdate: 'Actualizado hace 30 segundos',
      ),
    ],
    todayHighlights: [],
  );

  // Mock data para participante
  static DashboardModel get mockParticipantDashboard => DashboardModel(
    userId: 'part1',
    role: UserRole.participant,
    eventName: 'Convención 2024',
    location: 'Lima, Perú',
    eventStatus: EventStatus.live,
    stats: const DashboardStats(
      posts: 156,
      people: 89,
      engagement: null,
      hours: 12,
    ),
    actionItems: [],
    recentActivities: [
      RecentActivity(
        id: '1',
        description: 'El lugar del almuerzo se cambió al Salón Principal',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: ActivityType.update,
      ),
      RecentActivity(
        id: '2',
        description: 'Nuevo taller añadido: IA en los negocios',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: ActivityType.new_event,
      ),
      RecentActivity(
        id: '3',
        description: 'Se anuncian los ganadores del concurso de fotografía',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: ActivityType.announcement,
      ),
    ],
    eventOperations: [],
    todayHighlights: [
      TodayHighlight(
        id: '1',
        title: 'Charla de apertura',
        time: '9 a. m.',
        icon: 'microphone',
        color: '#6366F1',
      ),
      TodayHighlight(
        id: '2',
        title: 'Pausa para el almuerzo',
        time: '12 p. m.',
        icon: 'utensils',
        color: '#10B981',
      ),
      TodayHighlight(
        id: '3',
        title: 'Redes',
        time: '6 p. m.',
        icon: 'users',
        color: '#8B5CF6',
      ),
    ],
  );
}

class DashboardStats extends Equatable {
  final int posts;
  final int people;
  final int? engagement;
  final int? hours;

  const DashboardStats({
    required this.posts,
    required this.people,
    this.engagement,
    this.hours,
  });

  @override
  List<Object?> get props => [posts, people, engagement, hours];
}

class ActionItem extends Equatable {
  final String id;
  final String title;
  final ActionType type;

  const ActionItem({required this.id, required this.title, required this.type});

  @override
  List<Object> get props => [id, title, type];
}

class RecentActivity extends Equatable {
  final String id;
  final String description;
  final DateTime timestamp;
  final ActivityType type;

  const RecentActivity({
    required this.id,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object> get props => [id, description, timestamp, type];
}

class EventOperation extends Equatable {
  final String title;
  final List<OperationDetail> details;
  final String lastUpdate;

  const EventOperation({
    required this.title,
    required this.details,
    required this.lastUpdate,
  });

  @override
  List<Object> get props => [title, details, lastUpdate];
}

class OperationDetail extends Equatable {
  final String icon;
  final String title;
  final String value;
  final OperationStatus status;

  const OperationDetail({
    required this.icon,
    required this.title,
    required this.value,
    required this.status,
  });

  @override
  List<Object> get props => [icon, title, value, status];
}

class TodayHighlight extends Equatable {
  final String id;
  final String title;
  final String time;
  final String icon;
  final String color;

  const TodayHighlight({
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  List<Object> get props => [id, title, time, icon, color];
}

enum UserRole { organizer, participant }

enum EventStatus { upcoming, live, ended }

enum ActionType { notification, approval, update }

// ignore: constant_identifier_names
enum ActivityType { post, like, update, new_event, announcement }

enum OperationStatus { good, excellent, warning, error }
