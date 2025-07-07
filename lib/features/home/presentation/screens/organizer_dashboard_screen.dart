import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konecta/features/home/presentation/widgets/recent_updates_widget.dart';
import 'package:konecta/features/posts/presentation/screens/create_post_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/home/presentation/widgets/widgets.dart';
import '/features/home/presentation/bloc/blocs.dart';
import '/core/core.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  String? currentEventId;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    // En una implementación real, obtendrías el eventId del organizador
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
            if (state is DashboardError) {
              ToastUtils.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DashboardError) {
              return _buildErrorState(state.message);
            }

            if (state is DashboardLoaded) {
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

                      // Admin Welcome Card
                      _buildAdminWelcomeCard(),

                      const SizedBox(height: 24),

                      // Event Analytics
                      _buildEventAnalytics(dashboard),

                      const SizedBox(height: 24),

                      // Admin Actions
                      _buildAdminActions(),

                      const SizedBox(height: 24),

                      // Recent Activity & Updates
                      if (dashboard.recentUpdates.isNotEmpty)
                        RecentUpdatesWidget(updates: dashboard.recentUpdates),

                      const SizedBox(height: 24),

                      // Event Status Overview
                      _buildEventStatusOverview(dashboard),

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

  Widget _buildAdminWelcomeCard() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.shield,
              color: AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Panel de Administración', style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(
                  'Control total del evento en tiempo real',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventAnalytics(dashboard) {
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
                  LucideIcons.chartBar,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Análisis del Evento', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Posts Totales',
                  value: dashboard.stats.posts.toString(),
                  icon: LucideIcons.fileText,
                  color: AppColors.primary,
                  trend: '+12%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Asistentes',
                  value: dashboard.stats.people.toString(),
                  icon: LucideIcons.users,
                  color: AppColors.success,
                  trend: '+5%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Engagement',
                  value: '${dashboard.stats.engagement ?? 0}%',
                  icon: LucideIcons.trendingUp,
                  color: AppColors.info,
                  trend: '+8%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Tiempo Activo',
                  value: '${dashboard.stats.hours ?? 0}h',
                  icon: LucideIcons.clock,
                  color: AppColors.warning,
                  trend: 'Live',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions() {
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
                  LucideIcons.settings,
                  color: AppColors.info,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Acciones de Administrador', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  title: 'Crear Post',
                  icon: LucideIcons.plus,
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  title: 'Ver Reportes',
                  icon: LucideIcons.chartBar,
                  color: AppColors.success,
                  onTap: () {
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Función próximamente...',
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  title: 'Gestionar',
                  icon: LucideIcons.users,
                  color: AppColors.warning,
                  onTap: () {
                    ToastUtils.showInfo(
                      context: context,
                      message: 'Función próximamente...',
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventStatusOverview(dashboard) {
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
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.circleCheck,
                  color: AppColors.success,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text('Estado del Evento', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusItem(
            icon: LucideIcons.wifi,
            title: 'Conectividad',
            status: 'Excelente',
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            icon: LucideIcons.users,
            title: 'Participación',
            status: '${dashboard.stats.engagement ?? 0}% activos',
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            icon: LucideIcons.server,
            title: 'Sistemas',
            status: 'Funcionando normalmente',
            color: AppColors.success,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.activity,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Todos los servicios funcionando correctamente',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String status,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            status,
            style: AppTextStyles.body2.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
