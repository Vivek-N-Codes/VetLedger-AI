import 'package:flutter/material.dart';
import '../models/clinical_intelligence.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/status_badge.dart';

class ClinicalIntelligenceScreen extends StatefulWidget {
  final int animalId;
  final String animalName;
  final String animalCode;

  const ClinicalIntelligenceScreen({
    super.key,
    required this.animalId,
    required this.animalName,
    required this.animalCode,
  });

  @override
  State<ClinicalIntelligenceScreen> createState() => _ClinicalIntelligenceScreenState();
}

class _ClinicalIntelligenceScreenState extends State<ClinicalIntelligenceScreen> {
  late Future<ClinicalIntelligenceModel> _intelligenceFuture;

  @override
  void initState() {
    super.initState();
    _fetchIntelligence();
  }

  void _fetchIntelligence() {
    setState(() {
      _intelligenceFuture = ApiService.getClinicalIntelligence(widget.animalId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical AI Intelligence'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Re-analyze Records',
            onPressed: _fetchIntelligence,
          ),
        ],
      ),
      body: FutureBuilder<ClinicalIntelligenceModel>(
        future: _intelligenceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppTheme.primaryTeal),
                    const SizedBox(height: 20),
                    const Text(
                      'Analyzing Longitudinal Records...',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Synthesizing historical encounters for ${widget.animalName} (${widget.animalCode})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppTheme.alertRed),
                    const SizedBox(height: 16),
                    const Text('Intelligence Generation Failed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry Analysis'),
                      onPressed: _fetchIntelligence,
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Card with Source Status Badge
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.animalName} (${data.animalCode})',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${data.species} • ${data.breed ?? ''} • ${data.farmName ?? ''} (${data.villageName ?? ''})',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge.aiSource(data.source),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              data.isLiveLlm ? Icons.cloud_done_rounded : Icons.offline_bolt_rounded,
                              size: 14,
                              color: data.isLiveLlm ? const Color(0xFF4338CA) : AppTheme.warningAmber,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                data.isLiveLlm
                                    ? 'Engine: Remote Gemini LLM (${data.modelName ?? 'gemini-1.5-flash'})'
                                    : 'Engine: Deterministic Clinical Rules Fallback (${data.modelName ?? 'VetLedger-Heuristics'})',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Clinical Summary Card
              _buildSectionCard(
                title: 'Clinical Longitudinal Summary',
                icon: Icons.assignment_outlined,
                iconColor: AppTheme.primaryTeal,
                child: Text(
                  data.clinicalSummary,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.45),
                ),
              ),
              const SizedBox(height: 14),

              // Recurring Symptoms
              if (data.recurringSymptoms.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Recurring Symptoms Across Timeline',
                  icon: Icons.repeat_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  child: Column(
                    children: data.recurringSymptoms.map((sym) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle, size: 6, color: Color(0xFF7C3AED)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sym,
                                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Longitudinal Trajectory / Pattern shifts
              if (data.symptomChangesOverTime != null && data.symptomChangesOverTime!.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Symptom Trajectory & Evolution',
                  icon: Icons.trending_up_rounded,
                  iconColor: const Color(0xFF2563EB),
                  child: Text(
                    data.symptomChangesOverTime!,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Risk Indicators
              if (data.riskIndicators.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Potential Risk Indicators',
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppTheme.alertRed,
                  cardColor: const Color(0xFFFFFBFB),
                  borderColor: const Color(0xFFFEE2E2),
                  child: Column(
                    children: data.riskIndicators.map((risk) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.priority_high_rounded, size: 16, color: AppTheme.alertRed),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                risk,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B), height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Possible Conditions to Consider (Differentials)
              if (data.possibleConditionsToConsider.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Differential Conditions to Consider',
                  subtitle: 'Decision-support suggestions — not confirmed diagnoses',
                  icon: Icons.biotech_outlined,
                  iconColor: AppTheme.secondaryEmerald,
                  child: Column(
                    children: data.possibleConditionsToConsider.map((cond) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDCFCE7)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.help_outline_rounded, size: 16, color: AppTheme.successGreen),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cond,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF166534), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Recommended Observations & Monitoring
              if (data.recommendedObservations.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Recommended Clinical Monitoring',
                  icon: Icons.fact_check_outlined,
                  iconColor: AppTheme.primaryTeal,
                  child: Column(
                    children: data.recommendedObservations.map((obs) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppTheme.primaryTeal),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                obs,
                                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Suggested Follow-up
              if (data.suggestedFollowUp != null && data.suggestedFollowUp!.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Suggested Follow-Up Timeline',
                  icon: Icons.schedule_outlined,
                  iconColor: AppTheme.warningAmber,
                  child: Text(
                    data.suggestedFollowUp!,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Mandatory Disclaimer Banner
              DisclaimerBanner(text: data.disclaimer),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget child,
    Color? cardColor,
    Color? borderColor,
  }) {
    return Card(
      color: cardColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor ?? AppTheme.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
