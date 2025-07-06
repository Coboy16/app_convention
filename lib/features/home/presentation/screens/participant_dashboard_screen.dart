import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/presentation/widgets/widgets.dart';
import '/features/home/presentation/bloc/blocs.dart';
import '/features/home/data/data.dart';
import '/core/core.dart';

class ParticipantDashboardScreen extends StatefulWidget {
  const ParticipantDashboardScreen({super.key});

  @override
  State<ParticipantDashboardScreen> createState() =>
      _ParticipantDashboardScreenState();
}

class _ParticipantDashboardScreenState
    extends State<ParticipantDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar dashboard para participante
    context.read<DashboardBloc>().loadDashboard(UserRole.participant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is DashboardError) {
              ToastUtils.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.circleAlert,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text('Error al cargar dashboard', style: AppTextStyles.h4),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DashboardBloc>().loadDashboard(
                          UserRole.participant,
                        );
                      },
                      icon: const Icon(LucideIcons.refreshCw),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is DashboardLoaded) {
              final dashboard = state.dashboard;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().refreshDashboard();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    AppResponsive.horizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Header
                      DashboardHeaderWidget(dashboard: dashboard),

                      const SizedBox(height: 24),

                      // Welcome Card
                      const WelcomeCardWidget(),

                      const SizedBox(height: 24),

                      // Today's Highlights
                      if (dashboard.todayHighlights.isNotEmpty)
                        TodayHighlightsWidget(
                          highlights: dashboard.todayHighlights,
                        ),

                      const SizedBox(height: 24),

                      // Event Pulse
                      Text('Pulso de evento', style: AppTextStyles.h4),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: StatsCardWidget(
                              value: dashboard.stats.posts.toString(),
                              label: 'Publicaciones',
                              color: AppColors.primary,
                              icon: LucideIcons.fileText,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatsCardWidget(
                              value: dashboard.stats.people.toString(),
                              label: 'Gente',
                              color: AppColors.success,
                              icon: LucideIcons.users,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatsCardWidget(
                              value: dashboard.stats.hours.toString(),
                              label: 'Horas',
                              color: AppColors.warning,
                              icon: LucideIcons.clock,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions
                      const ParticipantActionsWidget(),

                      const SizedBox(height: 24),

                      // Recent Updates
                      if (dashboard.recentActivities.isNotEmpty)
                        RecentActivityWidget(
                          activities: dashboard.recentActivities,
                          title: 'Últimas actualizaciones',
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
