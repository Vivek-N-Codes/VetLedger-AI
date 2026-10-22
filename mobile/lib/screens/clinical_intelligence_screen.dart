import 'package:flutter/material.dart';
import '../models/clinical_intelligence.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/status_badge.dart';

class ClinicalIntelligenceScreen extends StatefulWidget {
  final int animalId;
  final String? animalName;
  final String? animalCode;
  final ClinicalIntelligenceModel? preloadedData;

  const ClinicalIntelligenceScreen({
    super.key,
    required this.animalId,
    this.animalName,
    this.animalCode,
    this.preloadedData,
  });

  @override
  State<ClinicalIntelligenceScreen> createState() => _ClinicalIntelligenceScreenState();
}

class _ClinicalIntelligenceScreenState extends State<ClinicalIntelligenceScreen> {
  late Future<ClinicalIntelligenceModel> _intelligenceFuture;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) {
      _intelligenceFuture = Future.value(widget.preloadedData!);
    } else {
      _fetchIntelligence();
    }
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
        title: const Text('Clinical AI Intelligence', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      'Synthesizing historical encounters for ${widget.animalName ?? "Animal #${widget.animalId}"}',
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
              // Header Card with AI Status Badge
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
                                Row(
                                  children: [
                                    Text(
                                      '${data.animalName} (${data.animalCode})',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                    ),
                                    if (data.isDraftAnalysis) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppTheme.warningBg,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('DRAFT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.warningAmber)),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${data.species} • ${data.breed ?? 'Native'} • ${data.farmName ?? ''} (${data.villageName ?? ''})',
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
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 1: LONGITUDINAL SYMPTOM TRACKER
              // =======================================================
              if (data.module1SymptomTracker != null)
                _buildModule1Card(data.module1SymptomTracker!)
              else
                _buildSectionCard(
                  title: 'Module 1: Longitudinal Symptom Tracker',
                  icon: Icons.timeline_rounded,
                  iconColor: AppTheme.primaryTeal,
                  child: Text(data.clinicalSummary, style: const TextStyle(fontSize: 13)),
                ),
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 2: CURRENT CLINICAL PRESENTATION
              // =======================================================
              if (data.module2CurrentPresentation != null)
                _buildModule2Card(data.module2CurrentPresentation!)
              else if (data.clinicalSummary.isNotEmpty)
                _buildSectionCard(
                  title: 'Module 2: Current Clinical Presentation',
                  icon: Icons.medical_information_rounded,
                  iconColor: const Color(0xFF2563EB),
                  child: Text(data.clinicalSummary, style: const TextStyle(fontSize: 13)),
                ),
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 3: HISTORICAL COMPARISON
              // =======================================================
              if (data.module3HistoricalComparison != null)
                _buildModule3Card(data.module3HistoricalComparison!)
              else if (data.recurringSymptoms.isNotEmpty)
                _buildSectionCard(
                  title: 'Module 3: Historical Comparison',
                  icon: Icons.compare_arrows_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  child: Column(
                    children: data.recurringSymptoms.map((s) => Text('• $s')).toList(),
                  ),
                ),
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 4: POSSIBLE CONDITIONS TO CONSIDER
              // =======================================================
              if (data.module4ConditionsToConsider != null)
                _buildModule4Card(data.module4ConditionsToConsider!)
              else if (data.possibleConditionsToConsider.isNotEmpty)
                _buildSectionCard(
                  title: 'Module 4: Conditions to Consider',
                  icon: Icons.biotech_rounded,
                  iconColor: AppTheme.secondaryEmerald,
                  child: Column(
                    children: data.possibleConditionsToConsider.map((c) => Text('• $c')).toList(),
                  ),
                ),
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 5: RISK INDICATORS & CLINICAL CONCERNS
              // =======================================================
              if (data.module5RiskIndicators != null)
                _buildModule5Card(data.module5RiskIndicators!)
              else if (data.riskIndicators.isNotEmpty)
                _buildSectionCard(
                  title: 'Module 5: Risk Indicators',
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppTheme.alertRed,
                  child: Column(
                    children: data.riskIndicators.map((r) => Text('• $r')).toList(),
                  ),
                ),
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 6: RECOMMENDED NEXT STEPS
              // =======================================================
              if (data.module6RecommendedNextSteps != null)
                _buildModule6Card(data.module6RecommendedNextSteps!)
              else if (data.recommendedObservations.isNotEmpty)
                _buildSectionCard(
                  title: 'Module 6: Recommended Next Steps',
                  icon: Icons.checklist_rounded,
                  iconColor: AppTheme.primaryTeal,
                  child: Column(
                    children: data.recommendedObservations.map((o) => Text('• $o')).toList(),
                  ),
                ),
              const SizedBox(height: 16),

              // =======================================================
              // MODULE 7: CLINICAL DECISION & FOLLOW-UP TEMPLATE
              // =======================================================
              if (data.module7ClinicalDecision != null)
                _buildModule7Card(data.module7ClinicalDecision!)
              else if (data.suggestedFollowUp != null)
                _buildSectionCard(
                  title: 'Module 7: Clinical Decision Template',
                  icon: Icons.assignment_turned_in_rounded,
                  iconColor: AppTheme.primaryTeal,
                  child: Text(data.suggestedFollowUp!),
                ),
              const SizedBox(height: 16),

              // Mandatory Disclaimer Banner
              DisclaimerBanner(text: data.disclaimer),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 1 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule1Card(Module1SymptomTracker mod) {
    return _buildSectionCard(
      title: 'Module 1: Longitudinal Symptom Tracker',
      subtitle: '${mod.totalHistoricalVisits} historical visits on file',
      icon: Icons.timeline_rounded,
      iconColor: AppTheme.primaryTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mod.longitudinalSummary, style: const TextStyle(fontSize: 13, height: 1.4)),
          if (mod.symptomItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...mod.symptomItems.map((item) {
              Color statusColor = AppTheme.textMuted;
              if (item.status == 'RECURRENT') statusColor = const Color(0xFF7C3AED);
              if (item.status == 'NEW') statusColor = AppTheme.warningAmber;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.presentationText, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: item.percentage / 100.0,
                      backgroundColor: Colors.grey.shade200,
                      color: AppTheme.primaryTeal,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 2 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule2Card(Module2CurrentPresentation mod) {
    return _buildSectionCard(
      title: 'Module 2: Current Clinical Presentation',
      subtitle: 'Recorded date: ${mod.visitDate}',
      icon: Icons.medical_information_rounded,
      iconColor: const Color(0xFF2563EB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Complaint: ${mod.presentingComplaint}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (mod.temperatureCelsius != null) ...[
                _badgeChip(Icons.thermostat_rounded, '${mod.temperatureCelsius}°C', AppTheme.alertRed),
                const SizedBox(width: 8),
              ],
              _badgeChip(Icons.speed_rounded, 'Severity: ${mod.severity}', AppTheme.warningAmber),
              if (mod.symptomOnsetDuration != null) ...[
                const SizedBox(width: 8),
                _badgeChip(Icons.timelapse_rounded, 'Onset: ${mod.symptomOnsetDuration}', AppTheme.primaryTeal),
              ],
            ],
          ),
          if (mod.currentSymptoms.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: mod.currentSymptoms.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryTeal)),
              )).toList(),
            ),
          ],
          if (mod.physicalExamFindings != null && mod.physicalExamFindings!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Exam Findings: ${mod.physicalExamFindings}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ],
          if (mod.priorTreatmentsNoted != null && mod.priorTreatmentsNoted!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Prior Rx Noted: ${mod.priorTreatmentsNoted}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 3 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule3Card(Module3HistoricalComparison mod) {
    return _buildSectionCard(
      title: 'Module 3: Historical Comparison',
      subtitle: 'Trajectory: ${mod.severityTrajectory}',
      icon: Icons.compare_arrows_rounded,
      iconColor: const Color(0xFF7C3AED),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mod.sharedSymptoms.isNotEmpty) ...[
            const Text('Shared with Past Encounters:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(mod.sharedSymptoms.join(', '), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
          ],
          if (mod.newlyRecordedSymptoms.isNotEmpty) ...[
            const Text('Newly Manifested Symptoms:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.warningAmber)),
            const SizedBox(height: 4),
            Text(mod.newlyRecordedSymptoms.join(', '), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
          ],
          if (mod.documentedTreatmentResponses.isNotEmpty) ...[
            const Text('Documented Prior Rx Responses:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            ...mod.documentedTreatmentResponses.map((r) => Text('• $r', style: const TextStyle(fontSize: 12))),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 4 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule4Card(Module4ConditionsToConsider mod) {
    return _buildSectionCard(
      title: 'Module 4: Possible Conditions to Consider',
      subtitle: mod.professionalNotice,
      icon: Icons.biotech_rounded,
      iconColor: AppTheme.secondaryEmerald,
      child: Column(
        children: mod.candidateConditions.map((c) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCFCE7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.help_outline_rounded, size: 16, color: AppTheme.successGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c.conditionName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                      ),
                    ),
                  ],
                ),
                if (c.supportingFindings.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Supporting Findings: ${c.supportingFindings.join("; ")}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
                if (c.distinguishingTestsOrExams.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Tests to Distinguish: ${c.distinguishingTestsOrExams.join("; ")}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryTeal)),
                ],
                if (c.uncertaintyNote != null) ...[
                  const SizedBox(height: 4),
                  Text('Note: ${c.uncertaintyNote!}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.textMuted)),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 5 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule5Card(Module5RiskIndicators mod) {
    Color bannerColor = AppTheme.successBg;
    Color textColor = AppTheme.successGreen;
    if (mod.urgencyLevel == 'CRITICAL_ATTENTION') {
      bannerColor = AppTheme.alertBg;
      textColor = AppTheme.alertRed;
    } else if (mod.urgencyLevel == 'ELEVATED') {
      bannerColor = AppTheme.warningBg;
      textColor = AppTheme.warningAmber;
    }

    return _buildSectionCard(
      title: 'Module 5: Risk Indicators & Clinical Concerns',
      subtitle: 'Deterministic and AI synthesized urgency assessment',
      icon: Icons.warning_amber_rounded,
      iconColor: textColor,
      cardColor: const Color(0xFFFFFBFB),
      borderColor: bannerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: bannerColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 16, color: textColor),
                const SizedBox(width: 6),
                Text('Urgency Status: ${mod.urgencyLevel}', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (mod.deterministicRuleFlags.isNotEmpty) ...[
            const Text('Deterministic Rule Flags:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.alertRed)),
            const SizedBox(height: 4),
            ...mod.deterministicRuleFlags.map((f) => Text('• $f', style: const TextStyle(fontSize: 12, color: AppTheme.alertRed))),
            const SizedBox(height: 8),
          ],
          if (mod.aiInterpretations.isNotEmpty) ...[
            const Text('Clinical Insights:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            ...mod.aiInterpretations.map((i) => Text('• $i', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 6 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule6Card(Module6RecommendedNextSteps mod) {
    return _buildSectionCard(
      title: 'Module 6: Recommended Next Steps',
      subtitle: mod.veterinaryDecisionNotice,
      icon: Icons.checklist_rounded,
      iconColor: AppTheme.primaryTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mod.observationsToVerify.isNotEmpty) ...[
            const Text('Observations to Verify at Chute:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            ...mod.observationsToVerify.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_box_outline_blank_rounded, size: 14, color: AppTheme.primaryTeal),
                      const SizedBox(width: 6),
                      Expanded(child: Text(o, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
          ],
          if (mod.examinationsToConsider.isNotEmpty) ...[
            const Text('Diagnostic Examinations to Consider:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            ...mod.examinationsToConsider.map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 7 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule7Card(Module7ClinicalDecisionTemplate mod) {
    return _buildSectionCard(
      title: 'Module 7: Clinical Decision Template & Follow-up',
      subtitle: mod.practitionerActionNotice,
      icon: Icons.assignment_turned_in_rounded,
      iconColor: AppTheme.primaryTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mod.suggestedAssessmentPrompt != null) ...[
            const Text('Suggested Assessment Framework:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(mod.suggestedAssessmentPrompt!, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35)),
            const SizedBox(height: 8),
          ],
          if (mod.recommendedFollowUpWindow != null) ...[
            Row(
              children: [
                const Icon(Icons.alarm_rounded, size: 16, color: AppTheme.primaryTeal),
                const SizedBox(width: 6),
                Text('Recommended Follow-up: ${mod.recommendedFollowUpWindow!}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (mod.ownerAdviceGuidance != null) ...[
            const Text('Owner Guidance to Communicate:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(mod.ownerAdviceGuidance!, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ],
        ],
      ),
    );
  }

  Widget _badgeChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
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
