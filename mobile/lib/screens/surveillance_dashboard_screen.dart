import 'package:flutter/material.dart';
import '../models/surveillance_cluster.dart';
import '../services/api_service.dart';
import '../services/locale_service.dart';
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
  late Future<PopulationOverview> _overviewFuture;

  @override
  void initState() {
    super.initState();
    _loadSurveillanceData();
  }

  void _loadSurveillanceData() {
    setState(() {
      _clustersFuture = ApiService.getSurveillanceClusters(windowDays: _windowDays);
      _overviewFuture = ApiService.getPopulationOverview(windowDays: _windowDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleService.t('surveillance_dashboard'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: LocaleService.code == 'mr' ? 'अल्गोरिदम पुन्हा चालवा' : (LocaleService.code == 'hi' ? 'एल्गोरिदम पुनः चलाएं' : 'Re-run Surveillance Algorithm'),
            onPressed: _loadSurveillanceData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadSurveillanceData(),
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
                      Expanded(
                        child: Text(
                          LocaleService.code == 'mr'
                              ? 'लक्षण-क्लस्टर रोग पाळत इंजिन'
                              : (LocaleService.code == 'hi' ? 'लक्षण-क्लस्टर निगरानी इंजन' : 'Symptom-Cluster Surveillance Engine'),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleService.code == 'mr'
                        ? 'फिरत्या निरीक्षण कालावधीत विविध जनावरे आणि फार्म्समधील नोंदवलेल्या लक्षणांचे विश्लेषण करून, रोगाचा संभाव्य उद्रेक वेळेवर शोधते.'
                        : (LocaleService.code == 'hi'
                            ? 'विभिन्न पशुओं और फार्मों में दर्ज लक्षणों का विश्लेषण करके प्रकोप की समय पर पहचान करता है।'
                            : 'Analyzes persisted clinical encounters across distinct animals and farms within a sliding observation window, comparing against historical baseline incidence to detect abnormal symptom concentrations.'),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF14532D), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${LocaleService.code == 'mr' ? 'निरीक्षण कालावधी:' : (LocaleService.code == 'hi' ? 'निरीक्षण अवधि:' : 'Observation Window:')} ',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                      ),
                      DropdownButton<int>(
                        value: _windowDays,
                        underline: const SizedBox(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                        items: [
                          DropdownMenuItem(value: 7, child: Text(LocaleService.code == 'mr' ? '७ दिवस' : (LocaleService.code == 'hi' ? '7 दिन' : '7 Days'))),
                          DropdownMenuItem(value: 14, child: Text(LocaleService.code == 'mr' ? '१४ दिवस (प्रमाणित)' : (LocaleService.code == 'hi' ? '14 दिन (मानक)' : '14 Days (Standard)'))),
                          DropdownMenuItem(value: 30, child: Text(LocaleService.code == 'mr' ? '३० दिवस' : (LocaleService.code == 'hi' ? '30 दिन' : '30 Days'))),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _windowDays = val);
                            _loadSurveillanceData();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Population Overview Metrics Card
            FutureBuilder<PopulationOverview>(
              future: _overviewFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final ov = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.query_stats_rounded, color: AppTheme.primaryTeal, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              LocaleService.code == 'mr'
                                  ? 'लोकसंख्या आरोग्य निर्देशक (कालावधी)'
                                  : (LocaleService.code == 'hi' ? 'पशु स्वास्थ्य मीट्रिक्स (अवधि)' : 'Population Health Metrics (Window)'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _metricBox(
                                LocaleService.code == 'mr' ? 'तपासलेली जनावरे' : (LocaleService.code == 'hi' ? 'सक्रिय पशु' : 'Active Animals'),
                                ov.activeAnimalsWithVisits.toString(),
                                AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _metricBox(
                                LocaleService.code == 'mr' ? 'क्लस्टर बाधित' : (LocaleService.code == 'hi' ? 'क्लस्टर प्रभावित' : 'Cluster Animals'),
                                ov.clusterAffectedAnimals.toString(),
                                AppTheme.alertRed,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _metricBox(
                                LocaleService.code == 'mr' ? 'सिंड्रोम प्रमाण' : (LocaleService.code == 'hi' ? 'सिंड्रोम अनुपात' : 'Syndrome Ratio'),
                                '${ov.syndromeElevationRatio.toStringAsFixed(1)}x',
                                const Color(0xFF7C3AED),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Dedicated Discrepancy Clarification Banner
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.primaryTeal),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  LocaleService.translateAdvisory(ov.clarificationNote),
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                          ElevatedButton(
                            onPressed: _loadSurveillanceData,
                            child: Text(LocaleService.code == 'mr' ? 'पुन्हा विश्लेषण करा' : (LocaleService.code == 'hi' ? 'पुनः विश्लेषण करें' : 'Retry Analysis')),
                          ),
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
                          Text(
                            LocaleService.code == 'mr' ? 'कोणताही असामान्य क्लस्टर आढळला नाही' : (LocaleService.code == 'hi' ? 'कोई असामान्य क्लस्टर नहीं मिला' : 'No Anomalous Clusters Detected'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            LocaleService.code == 'mr'
                                ? 'सर्व निरीक्षण गावांमध्ये लक्षणांचे प्रमाण सामान्य पातळीत आहे.'
                                : (LocaleService.code == 'hi'
                                    ? 'सभी निगरानी गांव सामान्य सीमा के भीतर हैं।'
                                    : 'All monitored villages are within normal baseline thresholds for the $_windowDays-day observation window.'),
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
                          '${LocaleService.code == 'mr' ? 'सक्रिय सांख्यिकीय इशारे' : (LocaleService.code == 'hi' ? 'सक्रिय सांख्यिकीय चेतावनी' : 'Active Statistical Alerts')} (${clusters.length})',
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
            Text(
              LocaleService.code == 'mr' ? 'भौगोलिक पाळत व्याप्ती (५ गावे)' : (LocaleService.code == 'hi' ? 'भौगोलिक निगरानी कवरेज (5 गांव)' : 'Geographic Coverage Monitoring'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _buildVillageStatusTile(
              'Sangamner',
              'Ahmednagar',
              LocaleService.code == 'mr' ? '६ फार्म • ४० जनावरे' : (LocaleService.code == 'hi' ? '6 फार्म • 40 पशु' : '6 Farms • 40 Animals'),
              true,
              LocaleService.code == 'mr' ? '१७ केसेस आढळल्या' : (LocaleService.code == 'hi' ? '17 मामले मिले' : '17 cases detected'),
            ),
            _buildVillageStatusTile(
              'Rahata',
              'Ahmednagar',
              LocaleService.code == 'mr' ? '२ फार्म • १२ जनावरे' : (LocaleService.code == 'hi' ? '2 फार्म • 12 पशु' : '2 Farms • 12 Animals'),
              false,
              LocaleService.code == 'mr' ? 'सामान्य पातळी (० क्लस्टर)' : (LocaleService.code == 'hi' ? 'सामान्य स्तर (0 क्लस्टर)' : 'Normal baseline (0 clusters)'),
            ),
            _buildVillageStatusTile(
              'Akole',
              'Ahmednagar',
              LocaleService.code == 'mr' ? '२ फार्म • १२ जनावरे' : (LocaleService.code == 'hi' ? '2 फार्म • 12 पशु' : '2 Farms • 12 Animals'),
              false,
              LocaleService.code == 'mr' ? 'सामान्य पातळी (० क्लस्टर)' : (LocaleService.code == 'hi' ? 'सामान्य स्तर (0 क्लस्टर)' : 'Normal baseline (0 clusters)'),
            ),
            _buildVillageStatusTile(
              'Kopargaon',
              'Ahmednagar',
              LocaleService.code == 'mr' ? '१ फार्म • ८ जनावरे' : (LocaleService.code == 'hi' ? '1 फार्म • 8 पशु' : '1 Farm • 8 Animals'),
              false,
              LocaleService.code == 'mr' ? 'सामान्य पातळी (० क्लस्टर)' : (LocaleService.code == 'hi' ? 'सामान्य स्तर (0 क्लस्टर)' : 'Normal baseline (0 clusters)'),
            ),
            _buildVillageStatusTile(
              'Shrirampur',
              'Ahmednagar',
              LocaleService.code == 'mr' ? '१ फार्म • ८ जनावरे' : (LocaleService.code == 'hi' ? '1 फार्म • 8 पशु' : '1 Farm • 8 Animals'),
              false,
              LocaleService.code == 'mr' ? 'सामान्य पातळी (० क्लस्टर)' : (LocaleService.code == 'hi' ? 'सामान्य स्तर (0 क्लस्टर)' : 'Normal baseline (0 clusters)'),
            ),

            const SizedBox(height: 18),
            DisclaimerBanner(
              isEpidemiological: true,
              text: LocaleService.code == 'mr'
                  ? 'रोगनिदान निर्णय साहाय्य: सांख्यिकीय इशारे प्राथमिक लक्षण एकाग्रता दर्शवतात, हे प्रयोगशाळा-पुष्टी झालेले निदान नाही. पशुवैद्यकीय तपासणी आवश्यक आहे.'
                  : (LocaleService.code == 'hi'
                      ? 'महामारी निर्णय समर्थन: सांख्यिकीय चेतावनी प्रारंभिक सिंड्रोम एकाग्रता दर्शाती है, यह प्रयोगशाला पुष्ट निदान नहीं है।'
                      : 'Epidemiological Decision Support: Statistical alerts represent early syndromic concentrations, not laboratory-confirmed disease diagnoses. Immediate veterinary investigation recommended.'),
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
                          '${LocaleService.code == 'mr' ? 'गाव' : (LocaleService.code == 'hi' ? 'गांव' : 'Village')}: ${c.villageName}',
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
                    LocaleService.code == 'mr' ? 'बाधित जनावरे' : (LocaleService.code == 'hi' ? 'प्रभावित पशु' : 'Distinct Animals'),
                    c.distinctAnimalCount.toString(),
                    isHigh ? AppTheme.alertRed : AppTheme.warningAmber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _metricBox(
                    LocaleService.code == 'mr' ? 'बाधित फार्म्स' : (LocaleService.code == 'hi' ? 'प्रभावित फार्म' : 'Affected Farms'),
                    c.affectedFarmCount.toString(),
                    AppTheme.primaryTeal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _metricBox(
                    LocaleService.code == 'mr' ? 'वाढ (प्रमाण)' : (LocaleService.code == 'hi' ? 'वृद्धि (गुना)' : 'Baseline Elevation'),
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
                    LocaleService.translateSymptom(sym),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            Text(
              LocaleService.translateAdvisory(c.rationale),
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
                label: Text(
                  LocaleService.code == 'mr'
                      ? '${c.villageName} पुराव्यांची तपासणी करा'
                      : (LocaleService.code == 'hi' ? '${c.villageName} साक्ष्य की जांच करें' : 'Investigate ${c.villageName} Evidence'),
                ),
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
