import 'package:flutter/material.dart';
import '../models/surveillance_cluster.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/status_badge.dart';
import 'animal_profile_screen.dart';

class ClusterInvestigationScreen extends StatefulWidget {
  final String clusterId;

  const ClusterInvestigationScreen({super.key, required this.clusterId});

  @override
  State<ClusterInvestigationScreen> createState() => _ClusterInvestigationScreenState();
}

class _ClusterInvestigationScreenState extends State<ClusterInvestigationScreen> {
  late Future<ClusterDetailModel> _detailFuture;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() {
    setState(() {
      _detailFuture = ApiService.getClusterDetail(widget.clusterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cluster Investigation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Evidence',
            onPressed: _loadDetail,
          ),
        ],
      ),
      body: FutureBuilder<ClusterDetailModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppTheme.alertRed),
                    const SizedBox(height: 12),
                    Text('Failed to load cluster evidence: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadDetail, child: const Text('Retry')),
                  ],
                ),
              ),
            );
          }

          final detail = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Card
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Village: ${detail.villageName}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                              ),
                              Text(
                                'Cluster Ref: ${detail.clusterId} • ${detail.observationWindowDays}-Day Window',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          StatusBadge.risk(detail.riskLevel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        detail.rationale,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Baseline Comparison & Statistical Evidence
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.query_stats_rounded, color: AppTheme.primaryTeal, size: 20),
                          SizedBox(width: 8),
                          Text('Statistical Baseline Comparison', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _statColumn('Current Window', '${detail.distinctAnimalCount} animals', '14-Day Observed', AppTheme.alertRed),
                          ),
                          Container(width: 1, height: 40, color: AppTheme.borderSubtle),
                          Expanded(
                            child: _statColumn('Historical Baseline', '${detail.baselineAnimalCount} animals', 'Prior 14-Day Avg', AppTheme.textSecondary),
                          ),
                          Container(width: 1, height: 40, color: AppTheme.borderSubtle),
                          Expanded(
                            child: _statColumn('Elevation Factor', '${detail.elevationFactor}x', 'Threshold: ≥2.0x', const Color(0xFF7C3AED)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Observed Window: ${detail.windowStartDate} to ${detail.windowEndDate} (${detail.supportingVisitIds.length} underlying clinical visits verified).',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Symptom Distribution
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.checklist_rounded, color: AppTheme.secondaryEmerald, size: 20),
                          SizedBox(width: 8),
                          Text('Co-Occurring Symptom Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: detail.symptomCounts.entries.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFCCFBF1)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  e.key.replaceAll('_', ' '),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryTeal),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryTeal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${e.value}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Affected Farms (${detail.affectedFarms.length})
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.agriculture_rounded, color: AppTheme.primaryTeal, size: 20),
                              SizedBox(width: 8),
                              Text('Affected Farms', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          Text('${detail.affectedFarms.length} farms involved', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...detail.affectedFarms.map((farm) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(farm.farmName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                  Text('Code: ${farm.farmCode} • Owner: ${farm.ownerName}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.alertBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${farm.affectedAnimalCount} animals',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.alertRed),
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
              const SizedBox(height: 14),

              // Affected Animals (${detail.affectedAnimals.length}) with Tap to Profile!
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.pets_rounded, color: AppTheme.primaryTeal, size: 20),
                              SizedBox(width: 8),
                              Text('Distinct Affected Animals', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          Text('${detail.affectedAnimals.length} distinct cases', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap any animal to inspect its longitudinal profile and clinical history:',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 10),
                      ...detail.affectedAnimals.map((animal) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AnimalProfileScreen(animalId: animal.id),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Row(
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
                                        animal.animalCode,
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primaryTeal),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      animal.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '(${animal.breed ?? animal.species})',
                                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      animal.farmName ?? '',
                                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right_rounded, size: 16, color: AppTheme.textMuted),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Recommended Field Actions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: AppTheme.warningAmber, size: 20),
                          SizedBox(width: 8),
                          Text('Recommended Field Veterinary Protocol', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...detail.recommendedFieldActions.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.arrow_right_rounded, size: 18, color: AppTheme.warningAmber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  action,
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.35),
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

              // Epidemiological Disclaimer
              DisclaimerBanner(
                isEpidemiological: true,
                text: detail.veterinaryNotice,
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _statColumn(String title, String value, String subtitle, Color color) {
    return Column(
      children: [
        Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const SizedBox(height: 1),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
      ],
    );
  }
}
