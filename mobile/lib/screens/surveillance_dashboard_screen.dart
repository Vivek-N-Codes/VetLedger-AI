import 'package:flutter/material.dart';
import '../models/surveillance_cluster.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/status_badge.dart';
import 'cluster_investigation_screen.dart';

class SurveillanceDashboardScreen extends StatefulWidget {
  const SurveillanceDashboardScreen({super.key});

  @override
  State<SurveillanceDashboardScreen> createState() => _SurveillanceDashboardScreenState();
}

class _SurveillanceDashboardScreenState extends State<SurveillanceDashboardScreen> {
  int _windowDays = 14;
  late Future<List<SurveillanceCluster>> _clustersFuture;

  @override
  void initState() {
    super.initState();
    _loadClusters();
  }

  void _loadClusters() {
    setState(() {
      _clustersFuture = ApiService.getSurveillanceClusters(windowDays: _windowDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Surveillance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Re-run Surveillance Algorithm',
            onPressed: _loadClusters,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadClusters(),
        color: AppTheme.primaryTeal,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Algorithm overview header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.hub_rounded, color: AppTheme.primaryTeal, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Symptom-Cluster Surveillance Engine',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Analyzes persisted clinical encounters across distinct animals and farms within a sliding observation window, comparing against historical baseline incidence to detect abnormal symptom concentrations.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF14532D), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Observation Window: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                      DropdownButton<int>(
                        value: _windowDays,
                        underline: const SizedBox(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                        items: const [
                          DropdownMenuItem(value: 7, child: Text('7 Days')),
                          DropdownMenuItem(value: 14, child: Text('14 Days (Standard)')),
                          DropdownMenuItem(value: 21, child: Text('21 Days')),
                          DropdownMenuItem(value: 30, child: Text('30 Days')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _windowDays = val);
                            _loadClusters();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Surveillance Clusters
            FutureBuilder<List<SurveillanceCluster>>(
              future: _clustersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppTheme.primaryTeal)));
                }
                if (snapshot.hasError) {
                  return Card(
                    color: const Color(0xFFFEF2F2),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: AppTheme.alertRed, size: 36),
                          const SizedBox(height: 10),
                          Text('Surveillance check failed: ${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: _loadClusters, child: const Text('Retry Analysis')),
                        ],
                      ),
                    ),
                  );
                }

                final clusters = snapshot.data ?? [];
                if (clusters.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppTheme.successGreen, size: 48),
                          const SizedBox(height: 12),
                          const Text('No Anomalous Clusters Detected', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text(
                            'All 5 monitored villages are within normal baseline thresholds for the $_windowDays-day observation window.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Statistical Alerts (${clusters.length})',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        StatusBadge.risk(clusters[0].riskLevel),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...clusters.map((c) => _buildClusterCard(context, c)),
                  ],
                );
              },
            ),

            const SizedBox(height: 18),

            // Geographic Coverage Summary (5 Villages)
            const Text('Geographic Coverage Monitoring', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _buildVillageStatusTile('Sangamner', 'Ahmednagar', '6 Farms • 40 Animals', true, '17 cases detected'),
            _buildVillageStatusTile('Rahata', 'Ahmednagar', '2 Farms • 12 Animals', false, 'Normal baseline (0 clusters)'),
            _buildVillageStatusTile('Akole', 'Ahmednagar', '2 Farms • 12 Animals', false, 'Normal baseline (0 clusters)'),
            _buildVillageStatusTile('Kopargaon', 'Ahmednagar', '1 Farm • 8 Animals', false, 'Normal baseline (0 clusters)'),
            _buildVillageStatusTile('Shrirampur', 'Ahmednagar', '1 Farm • 8 Animals', false, 'Normal baseline (0 clusters)'),

            const SizedBox(height: 18),
            const DisclaimerBanner(
              isEpidemiological: true,
              text: 'Epidemiological Decision Support: Statistical alerts represent early syndromic concentrations, not laboratory-confirmed disease diagnoses. Immediate veterinary investigation recommended.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildClusterCard(BuildContext context, SurveillanceCluster c) {
    final isHigh = c.riskLevel.toUpperCase() == 'HIGH';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isHigh ? const Color(0xFFFECDD3) : const Color(0xFFFDE68A), width: 1.5),
      ),
      color: isHigh ? const Color(0xFFFFF1F2) : const Color(0xFFFFFBEB),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isHigh ? AppTheme.alertBg : AppTheme.warningBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isHigh ? Icons.crisis_alert_rounded : Icons.insights_rounded,
                        color: isHigh ? AppTheme.alertRed : AppTheme.warningAmber,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Village: ${c.villageName}',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                        ),
                        Text(
                          'Cluster ID: ${c.clusterId}',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge.risk(c.riskLevel),
              ],
            ),
            const SizedBox(height: 12),

            // Key Metrics Row
            Row(
              children: [
                Expanded(
                  child: _metricBox(
                    'Distinct Animals',
                    c.distinctAnimalCount.toString(),
                    isHigh ? AppTheme.alertRed : AppTheme.warningAmber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _metricBox(
                    'Affected Farms',
                    c.affectedFarmCount.toString(),
                    AppTheme.primaryTeal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _metricBox(
                    'Baseline Elevation',
                    '${c.elevationFactor}x',
                    const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Shared symptoms
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: c.sharedSymptoms.map((sym) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    sym.replaceAll('_', ' '),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            Text(
              c.rationale,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHigh ? AppTheme.alertRed : AppTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.troubleshoot_rounded, size: 18),
                label: Text('Investigate ${c.villageName} Evidence'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClusterInvestigationScreen(clusterId: c.clusterId),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildVillageStatusTile(String name, String district, String details, bool hasAlert, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  hasAlert ? Icons.warning_rounded : Icons.check_circle_rounded,
                  color: hasAlert ? AppTheme.alertRed : AppTheme.successGreen,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('$district • $details', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: hasAlert ? AppTheme.alertBg : AppTheme.successBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: hasAlert ? AppTheme.alertRed : AppTheme.successGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
