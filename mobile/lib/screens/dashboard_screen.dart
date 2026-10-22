import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
import '../theme/app_theme.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/status_badge.dart';
import 'animal_list_screen.dart';
import 'animal_profile_screen.dart';
import 'cluster_investigation_screen.dart';
import 'farms_screen.dart';
import 'surveillance_dashboard_screen.dart';
import 'visit_entry_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
    AppDataSync.changeNotifier.addListener(_loadStats);
  }

  @override
  void dispose() {
    AppDataSync.changeNotifier.removeListener(_loadStats);
    super.dispose();
  }

  void _loadStats() {
    if (mounted) {
      setState(() {
        _statsFuture = ApiService.getDashboardStats();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.pets, color: AppTheme.primaryTeal, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VetLedger AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                Text('Clinical Intelligence & Surveillance', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.textSecondary),
            tooltip: 'Refresh Dashboard',
            onPressed: _loadStats,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadStats(),
        color: AppTheme.primaryTeal,
        child: FutureBuilder<DashboardStats>(
          future: _statsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal));
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off_rounded, size: 48, color: AppTheme.alertRed),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to connect to VetLedger backend',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Target URL: ${ApiService.baseUrl}\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry Connection'),
                        onPressed: _loadStats,
                      ),
                    ],
                  ),
                ),
              );
            }

            final stats = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Key Metric Cards Grid
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Total Animals', stats.totalAnimals.toString(), Icons.pets_rounded, AppTheme.primaryTeal)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildMetricCard('Farms Tracked', stats.totalFarms.toString(), Icons.agriculture_rounded, AppTheme.secondaryEmerald)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Villages Covered', stats.totalVillages.toString(), Icons.location_on_rounded, const Color(0xFF2563EB))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildMetricCard('Clinical Encounters', stats.totalVisits.toString(), Icons.medical_services_rounded, const Color(0xFF7C3AED))),
                  ],
                ),
                const SizedBox(height: 18),

                // Active Surveillance Alert Banner (if alert exists)
                if (stats.activeSurveillanceAlerts > 0) ...[
                  Card(
                    color: const Color(0xFFFFF1F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFFECDD3), width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.alertBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.campaign_rounded, color: AppTheme.alertRed, size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SURVEILLANCE SIGNAL DETECTED',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.alertRed,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      'Sangamner: Unusual Symptom Spike',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge.risk('HIGH'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '17 distinct animals across 6 farms presented with Fever, Nasal Discharge, and Reduced Appetite in the last 14 days (9.4x historical baseline).',
                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.35),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.alertRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.search_rounded, size: 18),
                              label: const Text('Investigate Sangamner Cluster Evidence'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ClusterInvestigationScreen(clusterId: 'Sangamner'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Live Farm Livestock Distribution (Dynamic farm herd breakdown)
                if (stats.farmStats.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Live Farm Livestock Distribution',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('All Farms'),
                        onPressed: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(2);
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmsScreen()));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.borderSubtle),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.agriculture_rounded, color: AppTheme.primaryTeal, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Dynamic Herd Counts per Farm (${stats.farmStats.length} Total Farms)',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          ...stats.farmStats.map((f) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          f.farmName,
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary),
                                        ),
                                        Text(
                                          '${f.villageName}${f.ownerName.isNotEmpty ? ' • ${f.ownerName}' : ''}',
                                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryLight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.pets_rounded, size: 12, color: AppTheme.primaryTeal),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${f.animalCount} animals',
                                          style: const TextStyle(
                                            color: AppTheme.primaryTeal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Village Breakdown
                if (stats.villageStats.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_city_rounded, color: AppTheme.primaryTeal, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Village Animal Breakdown',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: stats.villageStats.map((vs) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vs.villageName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text('${vs.animalCount} animals • ${vs.farmCount} farms', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Quick Navigation Action Row
                const Text('Clinical Workflows', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildWorkflowAction(
                        title: 'Animal Records',
                        subtitle: 'Search & Profiles',
                        icon: Icons.badge_outlined,
                        color: AppTheme.primaryTeal,
                        onTap: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(1);
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AnimalListScreen()));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildWorkflowAction(
                        title: 'Record Visit',
                        subtitle: 'New Clinical Exam',
                        icon: Icons.edit_calendar_rounded,
                        color: AppTheme.secondaryEmerald,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VisitEntryScreen()),
                          );
                          if (result == true) {
                            _loadStats();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildWorkflowAction(
                        title: 'Surveillance',
                        subtitle: 'Cluster Analytics',
                        icon: Icons.analytics_outlined,
                        color: const Color(0xFFD97706),
                        onTap: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(2);
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SurveillanceDashboardScreen()));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Recent Clinical Encounters Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Clinical Visits', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    TextButton.icon(
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('View All Animals'),
                      onPressed: () {
                        if (widget.onNavigateTab != null) {
                          widget.onNavigateTab!(1);
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AnimalListScreen()));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (stats.recentVisits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No recent visits recorded.', style: TextStyle(color: AppTheme.textMuted))),
                  )
                else
                  ...stats.recentVisits.take(5).map((visit) => _buildVisitItem(context, visit)),

                const SizedBox(height: 16),
                const DisclaimerBanner(),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color accentColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                  ),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderSubtle),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitItem(BuildContext context, dynamic visit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimalProfileScreen(animalId: visit.animalId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          visit.animalCode ?? 'ANM-${visit.animalId}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        visit.animalName ?? '',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  StatusBadge.severity(visit.severity),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                visit.presentingComplaint,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 12, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(visit.visitDate, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text('${visit.farmName ?? ''} (${visit.villageName ?? ''})', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
