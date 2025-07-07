import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/home/domain/domain.dart';
import 'package:konecta/features/home/presentation/widgets/highlight_details_bottom_sheet.dart';
import 'package:konecta/features/home/presentation/widgets/recent_updates_widget.dart';
import 'package:konecta/features/home/presentation/widgets/survey_bottom_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/presentation/widgets/widgets.dart';
import '/features/home/presentation/bloc/blocs.dart';
import '/shared/bloc/blocs.dart';
import '/core/core.dart';

class ParticipantDashboardScreen extends StatefulWidget {
  const ParticipantDashboardScreen({super.key});

  @override
  State<ParticipantDashboardScreen> createState() =>
      _ParticipantDashboardScreenState();
}

class _ParticipantDashboardScreenState
    extends State<ParticipantDashboardScreen> {
  String? currentEventId;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    currentEventId = 'event_2024_convention';

    if (currentEventId != null) {
      context.read<DashboardBloc>().add(
        DashboardLoadRequested(eventId: currentEventId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            debugPrint('🔄 NUEVO ESTADO: ${state.runtimeType}');

            if (state is DashboardError) {
              ToastUtils.showError(context: context, message: state.message);
            } else if (state is SurveySubmitted) {
              ToastUtils.showSuccess(
                context: context,
                message: 'Encuesta enviada exitosamente',
              );
            } else if (state is SurveySubmissionError) {
              ToastUtils.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            debugPrint('🎨 BUILDING CON ESTADO: ${state.runtimeType}');

            // ✅ AGREGAR DEBUG TEMPORAL
            if (state is DashboardLoading) {
              debugPrint('⏳ Estado: LOADING');
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Cargando dashboard...'),
                  ],
                ),
              );
            }

            if (state is DashboardError) {
              debugPrint('❌ Estado: ERROR - ${state.message}');
              return _buildErrorState(state.message);
            }

            if (state is DashboardLoaded) {
              debugPrint('✅ Estado: LOADED');
              debugPrint(
                '   - Highlights: ${state.dashboard.todayHighlights.length}',
              );
              debugPrint(
                '   - Updates: ${state.dashboard.recentUpdates.length}',
              );
              debugPrint(
                '   - Surveys: ${state.dashboard.availableSurveys.length}',
              );

              final dashboard = state.dashboard;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                    DashboardRefreshRequested(),
                  );
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    AppResponsive.horizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Header - NO MODIFICAR
                      DashboardHeaderWidget(dashboard: dashboard),

                      const SizedBox(height: 24),

                      // Welcome Card
                      _buildWelcomeCard(),

                      const SizedBox(height: 10),

                      // Today's Highlights
                      if (dashboard.todayHighlights.isNotEmpty)
                        TodayHighlightsWidget(
                          highlights: dashboard.todayHighlights,
                          onHighlightTap: _showHighlightDetails,
                        ),

                      const SizedBox(height: 24),

                      // Event Pulse
                      _buildEventPulse(dashboard),

                      const SizedBox(height: 24),

                      // Quick Actions
                      _buildQuickActions(dashboard.availableSurveys),

                      const SizedBox(height: 24),

                      // Recent Updates
                      if (dashboard.recentUpdates.isNotEmpty)
                        RecentUpdatesWidget(updates: dashboard.recentUpdates),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            }

            // ✅ ESTADO DESCONOCIDO
            debugPrint('❓ Estado desconocido: ${state.runtimeType}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Estado desconocido: ${state.runtimeType}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDashboard,
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.circleAlert, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Error al cargar dashboard', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadDashboard,
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState.user?.name ?? 'Usuario';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '¡Bienvenido, ${userName.split(' ').first}!',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Estás conectado al evento. Disfruta de la experiencia y mantente actualizado.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventPulse(dashboard) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.activity,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Pulso del Evento', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  value: dashboard.stats.posts.toString(),
                  label: 'Posts',
                  color: AppColors.primary,
                  icon: LucideIcons.fileText,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  value: dashboard.stats.people.toString(),
                  label: 'Asistentes',
                  color: AppColors.success,
                  icon: LucideIcons.users,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  value: '${dashboard.stats.hours ?? 0}h',
                  label: 'Tiempo activo',
                  color: AppColors.warning,
                  icon: LucideIcons.clock,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h4.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(List<SurveyEntity> surveys) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.zap,
                  color: AppColors.info,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Acciones Rápidas', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 16),
          if (surveys.isNotEmpty) ...[
            ...surveys.map((survey) => _buildSurveyAction(survey)).toList(),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.info,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No hay encuestas disponibles en este momento',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSurveyAction(SurveyEntity survey) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showSurveyBottomSheet(survey),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.clipboardList,
                  color: AppColors.surface,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(survey.title, style: AppTextStyles.labelMedium),
                    const SizedBox(height: 2),
                    Text(
                      survey.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                color: AppColors.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHighlightDetails(TodayHighlightEntity highlight) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => HighlightDetailsBottomSheet(highlight: highlight),
    );
  }

  void _showSurveyBottomSheet(SurveyEntity survey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SurveyBottomSheet(
        survey: survey,
        onSubmit: (responses) {
          ToastUtils.showSuccess(
            context: context,
            message: 'Evaluación enviava correctamente',
          );
        },
      ),
    );
  }
}
