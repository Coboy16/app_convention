import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/presentation/widgets/widgets.dart';
import '/features/home/presentation/bloc/blocs.dart';
import '/features/home/data/data.dart';
import '/core/core.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().loadDashboard(UserRole.organizer);
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
                          UserRole.organizer,
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

                      // Admin Dashboard Welcome
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                LucideIcons.settings,
                                color: AppColors.surface,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Panel de Administración',
                                    style: AppTextStyles.labelMedium,
                                  ),
                                  Text(
                                    '¡Bienvenido de vuelta, Admin!',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Items
                      if (dashboard.actionItems.isNotEmpty)
                        ActionItemsWidget(actionItems: dashboard.actionItems),

                      const SizedBox(height: 24),

                      // Event Analytics
                      Text('Análisis del Evento', style: AppTextStyles.h4),
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
                              label: 'Personas',
                              color: AppColors.success,
                              icon: LucideIcons.users,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatsCardWidget(
                              value: '${dashboard.stats.engagement}%',
                              label: 'Participación',
                              color: AppColors.info,
                              icon: LucideIcons.trendingUp,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Admin Actions
                      const AdminActionsWidget(),

                      const SizedBox(height: 24),

                      // Recent Activity
                      if (dashboard.recentActivities.isNotEmpty)
                        RecentActivityWidget(
                          activities: dashboard.recentActivities,
                        ),

                      const SizedBox(height: 24),

                      // Event Operations
                      if (dashboard.eventOperations.isNotEmpty)
                        EventOperationsWidget(
                          operations: dashboard.eventOperations,
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
