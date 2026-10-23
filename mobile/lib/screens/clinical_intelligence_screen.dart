import 'package:flutter/material.dart';
import '../models/clinical_intelligence.dart';
import '../services/api_service.dart';
import '../services/locale_service.dart';
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
        title: Text(
          LocaleService.code == 'mr'
              ? 'एआय क्लिनिकल निदान व सल्ला'
              : (LocaleService.code == 'hi' ? 'एआई क्लिनिकल निदान एवं सलाह' : 'Clinical AI Intelligence'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: LocaleService.t('refresh'),
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
                    Text(
                      LocaleService.code == 'mr'
                          ? 'क्लिनिकल डेटाचे सखोल विश्लेषण सुरू आहे...'
                          : (LocaleService.code == 'hi'
                              ? 'नैदानिक रिकॉर्ड का विश्लेषण हो रहा है...'
                              : 'Analyzing Longitudinal Records...'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleService.code == 'mr'
                          ? '${widget.animalName ?? "जनावर #${widget.animalId}"} च्या सर्व जुन्या व नवीन नोंदी तपासल्या जात आहेत.'
                          : (LocaleService.code == 'hi'
                              ? '${widget.animalName ?? "पशु #${widget.animalId}"} के पुराने एवं वर्तमान रिकॉर्ड का मिलान किया जा रहा है।'
                              : 'Synthesizing historical encounters for ${widget.animalName ?? "Animal #${widget.animalId}"}'),
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
                    Text(
                      LocaleService.code == 'mr'
                          ? 'विश्लेषण लोड करण्यात अडचण'
                          : (LocaleService.code == 'hi' ? 'विश्लेषण लोड करने में विफल' : 'Intelligence Generation Failed'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(LocaleService.t('retry')),
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
                                    Flexible(
                                      child: Text(
                                        '${data.animalName} (${data.animalCode})',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (data.isDraftAnalysis) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppTheme.warningBg,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          LocaleService.code == 'mr' ? 'मसुदा' : (LocaleService.code == 'hi' ? 'प्रारूप' : 'DRAFT'),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.warningAmber),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${LocaleService.translateSpecies(data.species)} • ${data.breed ?? 'Native'} • ${data.farmName ?? ''} (${data.villageName ?? ''})',
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
                                    ? (LocaleService.code == 'mr'
                                        ? 'इंजिन: क्लाउड जेमिनी एआय मॉडेल (${data.modelName ?? 'gemini-1.5-flash'})'
                                        : (LocaleService.code == 'hi'
                                            ? 'इंजन: क्लाउड जेमिनी एआई मॉडल (${data.modelName ?? 'gemini-1.5-flash'})'
                                            : 'Engine: Remote Gemini LLM (${data.modelName ?? 'gemini-1.5-flash'})'))
                                    : (LocaleService.code == 'mr'
                                        ? 'इंजिन: क्लिनिकल नियम फॉलबॅक (${data.modelName ?? 'VetLedger-Heuristics'})'
                                        : (LocaleService.code == 'hi'
                                            ? 'इंजन: नैदानिक नियम फॉलबैक (${data.modelName ?? 'VetLedger-Heuristics'})'
                                            : 'Engine: Deterministic Clinical Rules Fallback (${data.modelName ?? 'VetLedger-Heuristics'})')),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल १: दीर्घकालीन लक्षण इतिहास'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 1: दीर्घकालिक लक्षण ट्रैकर' : 'Module 1: Longitudinal Symptom Tracker'),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल २: सद्य क्लिनिकल लक्षणे'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 2: वर्तमान नैदानिक लक्षण' : 'Module 2: Current Clinical Presentation'),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल ३: ऐतिहासिक तुलना'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 3: ऐतिहासिक तुलना' : 'Module 3: Historical Comparison'),
                  icon: Icons.compare_arrows_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  child: Column(
                    children: data.recurringSymptoms.map((s) => Text('• ${LocaleService.translateSymptom(s)}')).toList(),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल ४: संभाव्य रोग व निदान'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 4: विचारणीय संभावित स्थितियां' : 'Module 4: Conditions to Consider'),
                  icon: Icons.biotech_rounded,
                  iconColor: AppTheme.secondaryEmerald,
                  child: Column(
                    children: data.possibleConditionsToConsider.map((c) => Text('• ${LocaleService.translateDiagnosis(c)}')).toList(),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल ५: जोखीम निर्देशक व वैद्यकीय चिंता'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 5: जोखिम संकेतक' : 'Module 5: Risk Indicators'),
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppTheme.alertRed,
                  child: Column(
                    children: data.riskIndicators.map((r) => Text('• ${LocaleService.translateAdvisory(r)}')).toList(),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल ६: शिफारस केलेली पुढील पावले'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 6: अनुशंसित अगले कदम' : 'Module 6: Recommended Next Steps'),
                  icon: Icons.checklist_rounded,
                  iconColor: AppTheme.primaryTeal,
                  child: Column(
                    children: data.recommendedObservations.map((o) => Text('• ${LocaleService.translateAdvisory(o)}')).toList(),
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
                  title: LocaleService.code == 'mr'
                      ? 'मॉड्युल ७: वैद्यकीय निर्णय आराखडा व पाठपुरावा'
                      : (LocaleService.code == 'hi' ? 'मॉड्यूल 7: नैदानिक निर्णय प्रारूप' : 'Module 7: Clinical Decision Template'),
                  icon: Icons.assignment_turned_in_rounded,
                  iconColor: AppTheme.primaryTeal,
                  child: Text(LocaleService.translateAdvisory(data.suggestedFollowUp!)),
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
    final title = LocaleService.code == 'mr'
        ? 'मॉड्युल १: दीर्घकालीन लक्षण इतिहास'
        : (LocaleService.code == 'hi' ? 'मॉड्यूल 1: दीर्घकालिक लक्षण ट्रैकर' : 'Module 1: Longitudinal Symptom Tracker');
    final subtitle = LocaleService.code == 'mr'
        ? '${mod.totalHistoricalVisits} ऐतिहासिक नोंदी उपलब्ध'
        : (LocaleService.code == 'hi' ? '${mod.totalHistoricalVisits} ऐतिहासिक दौरे दर्ज' : '${mod.totalHistoricalVisits} historical visits on file');

    return _buildSectionCard(
      title: title,
      subtitle: subtitle,
      icon: Icons.timeline_rounded,
      iconColor: AppTheme.primaryTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleService.translateAdvisory(mod.longitudinalSummary), style: const TextStyle(fontSize: 13, height: 1.4)),
          if (mod.symptomItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...mod.symptomItems.map((item) {
              Color statusColor = AppTheme.textMuted;
              String statusLabel = item.status;
              if (item.status == 'RECURRENT') {
                statusColor = const Color(0xFF7C3AED);
                statusLabel = LocaleService.code == 'mr' ? 'वारंवार' : (LocaleService.code == 'hi' ? 'पुनरावृत्त' : 'RECURRENT');
              } else if (item.status == 'NEW') {
                statusColor = AppTheme.warningAmber;
                statusLabel = LocaleService.code == 'mr' ? 'नवीन' : (LocaleService.code == 'hi' ? 'नया' : 'NEW');
              }

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
                        Text(LocaleService.translateSymptom(item.displayName), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(LocaleService.translateAdvisory(item.presentationText), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
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
    final title = LocaleService.code == 'mr'
        ? 'मॉड्युल २: सद्य क्लिनिकल लक्षणे'
        : (LocaleService.code == 'hi' ? 'मॉड्यूल 2: वर्तमान नैदानिक लक्षण' : 'Module 2: Current Clinical Presentation');
    final complaintPrefix = LocaleService.code == 'mr' ? 'तक्रार:' : (LocaleService.code == 'hi' ? 'शिकायत:' : 'Complaint:');
    final severityPrefix = LocaleService.code == 'mr' ? 'तीव्रता:' : (LocaleService.code == 'hi' ? 'गंभीरता:' : 'Severity:');
    final onsetPrefix = LocaleService.code == 'mr' ? 'सुरुवात:' : (LocaleService.code == 'hi' ? 'शुरुआत:' : 'Onset:');

    return _buildSectionCard(
      title: title,
      subtitle: '${LocaleService.code == 'mr' ? 'नोंद तारीख:' : (LocaleService.code == 'hi' ? 'दर्ज तिथि:' : 'Recorded date:')} ${mod.visitDate}',
      icon: Icons.medical_information_rounded,
      iconColor: const Color(0xFF2563EB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$complaintPrefix ${LocaleService.translateAdvisory(mod.presentingComplaint)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (mod.temperatureCelsius != null) ...[
                _badgeChip(Icons.thermostat_rounded, '${mod.temperatureCelsius}°C', AppTheme.alertRed),
                const SizedBox(width: 8),
              ],
              _badgeChip(Icons.speed_rounded, '$severityPrefix ${LocaleService.translateSeverity(mod.severity)}', AppTheme.warningAmber),
              if (mod.symptomOnsetDuration != null) ...[
                const SizedBox(width: 8),
                _badgeChip(Icons.timelapse_rounded, '$onsetPrefix ${LocaleService.translateAdvisory(mod.symptomOnsetDuration!)}', AppTheme.primaryTeal),
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
                child: Text(LocaleService.translateSymptom(s), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryTeal)),
              )).toList(),
            ),
          ],
          if (mod.physicalExamFindings != null && mod.physicalExamFindings!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '${LocaleService.code == 'mr' ? 'शारीरिक तपासणी निष्कर्ष' : (LocaleService.code == 'hi' ? 'शारीरिक परीक्षण निष्कर्ष' : 'Exam Findings')}: ${LocaleService.translateAdvisory(mod.physicalExamFindings!)}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
          if (mod.priorTreatmentsNoted != null && mod.priorTreatmentsNoted!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '${LocaleService.code == 'mr' ? 'मागील उपचार' : (LocaleService.code == 'hi' ? 'पूर्व उपचार' : 'Prior Rx Noted')}: ${LocaleService.translateAdvisory(mod.priorTreatmentsNoted!)}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 3 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule3Card(Module3HistoricalComparison mod) {
    final title = LocaleService.code == 'mr'
        ? 'मॉड्युल ३: ऐतिहासिक तुलना'
        : (LocaleService.code == 'hi' ? 'मॉड्यूल 3: ऐतिहासिक तुलना' : 'Module 3: Historical Comparison');

    return _buildSectionCard(
      title: title,
      subtitle: '${LocaleService.code == 'mr' ? 'प्रगती' : (LocaleService.code == 'hi' ? 'प्रक्षेपवक्र' : 'Trajectory')}: ${LocaleService.translateAdvisory(mod.severityTrajectory)}',
      icon: Icons.compare_arrows_rounded,
      iconColor: const Color(0xFF7C3AED),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mod.sharedSymptoms.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'मागील आजारांशी सामायिक लक्षणे:' : (LocaleService.code == 'hi' ? 'पिछले दौरों से साझा लक्षण:' : 'Shared with Past Encounters:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(mod.sharedSymptoms.map((s) => LocaleService.translateSymptom(s)).join(', '), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
          ],
          if (mod.newlyRecordedSymptoms.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'नव्यानं दिसणारी लक्षणे:' : (LocaleService.code == 'hi' ? 'नए प्रकट लक्षण:' : 'Newly Manifested Symptoms:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.warningAmber),
            ),
            const SizedBox(height: 4),
            Text(mod.newlyRecordedSymptoms.map((s) => LocaleService.translateSymptom(s)).join(', '), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
          ],
          if (mod.documentedTreatmentResponses.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'मागील उपचारांचा प्रतिसाद:' : (LocaleService.code == 'hi' ? 'दर्ज पूर्व उपचार प्रतिसाद:' : 'Documented Prior Rx Responses:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            ...mod.documentedTreatmentResponses.map((r) => Text('• ${LocaleService.translateAdvisory(r)}', style: const TextStyle(fontSize: 12))),
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
      title: LocaleService.code == 'mr'
          ? 'मॉड्युल ४: संभाव्य रोग व निदान'
          : (LocaleService.code == 'hi' ? 'मॉड्यूल 4: विचारणीय संभावित स्थितियां' : 'Module 4: Possible Conditions to Consider'),
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
                        LocaleService.translateDiagnosis(c.conditionName),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                      ),
                    ),
                  ],
                ),
                if (c.supportingFindings.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${LocaleService.code == 'mr' ? 'पूरक क्लिनिकल निष्कर्ष' : (LocaleService.code == 'hi' ? 'सहायक निष्कर्ष' : 'Supporting Findings')}: ${c.supportingFindings.map((f) => LocaleService.translateAdvisory(f)).join("; ")}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
                if (c.distinguishingTestsOrExams.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${LocaleService.code == 'mr' ? 'भेद निश्चित करणाऱ्या चाचण्या' : (LocaleService.code == 'hi' ? 'अंतर स्पष्ट करने वाले परीक्षण' : 'Tests to Distinguish')}: ${c.distinguishingTestsOrExams.map((t) => LocaleService.translateAdvisory(t)).join("; ")}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryTeal),
                  ),
                ],
                if (c.uncertaintyNote != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${LocaleService.code == 'mr' ? 'टीप' : (LocaleService.code == 'hi' ? 'नोट' : 'Note')}: ${LocaleService.translateAdvisory(c.uncertaintyNote!)}',
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.textMuted),
                  ),
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
    String urgencyLabel = mod.urgencyLevel;
    if (mod.urgencyLevel == 'CRITICAL_ATTENTION') {
      bannerColor = AppTheme.alertBg;
      textColor = AppTheme.alertRed;
      urgencyLabel = LocaleService.code == 'mr' ? 'तातडीचे लक्ष आवश्यक' : (LocaleService.code == 'hi' ? 'अति-गंभीर ध्यान आवश्यक' : 'CRITICAL ATTENTION');
    } else if (mod.urgencyLevel == 'ELEVATED') {
      bannerColor = AppTheme.warningBg;
      textColor = AppTheme.warningAmber;
      urgencyLabel = LocaleService.code == 'mr' ? 'वाढीव जोखीम' : (LocaleService.code == 'hi' ? 'बढ़ा हुआ जोखिम' : 'ELEVATED');
    } else {
      urgencyLabel = LocaleService.code == 'mr' ? 'सामान्य' : (LocaleService.code == 'hi' ? 'सामान्य' : 'ROUTINE');
    }

    final title = LocaleService.code == 'mr'
        ? 'मॉड्युल ५: जोखीम निर्देशक व वैद्यकीय चिंता'
        : (LocaleService.code == 'hi' ? 'मॉड्यूल 5: जोखिम संकेतक और नैदानिक चिंताएं' : 'Module 5: Risk Indicators & Clinical Concerns');
    final subtitle = LocaleService.code == 'mr'
        ? 'नियम आणि एआय आधारित तातडीचे मूल्यांकन'
        : (LocaleService.code == 'hi' ? 'नियम और एआई आधारित तत्कालिकता मूल्यांकन' : 'Deterministic and AI synthesized urgency assessment');

    return _buildSectionCard(
      title: title,
      subtitle: subtitle,
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
                Text(
                  '${LocaleService.code == 'mr' ? 'तातडीची स्थिती:' : (LocaleService.code == 'hi' ? 'तत्कालिकता स्थिति:' : 'Urgency Status:')} $urgencyLabel',
                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (mod.deterministicRuleFlags.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'वैद्यकीय नियमांचे इशारे:' : (LocaleService.code == 'hi' ? 'नैदानिक नियम संकेत:' : 'Deterministic Rule Flags:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.alertRed),
            ),
            const SizedBox(height: 4),
            ...mod.deterministicRuleFlags.map((f) => Text('• ${LocaleService.translateAdvisory(f)}', style: const TextStyle(fontSize: 12, color: AppTheme.alertRed))),
            const SizedBox(height: 8),
          ],
          if (mod.aiInterpretations.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'क्लिनिकल अंतर्दृष्टी:' : (LocaleService.code == 'hi' ? 'नैदानिक अंतर्दृष्टि:' : 'Clinical Insights:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            ...mod.aiInterpretations.map((i) => Text('• ${LocaleService.translateAdvisory(i)}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 6 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule6Card(Module6RecommendedNextSteps mod) {
    final title = LocaleService.code == 'mr'
        ? 'मॉड्युल ६: शिफारस केलेली पुढील पावले'
        : (LocaleService.code == 'hi' ? 'मॉड्यूल 6: अनुशंसित अगले कदम' : 'Module 6: Recommended Next Steps');

    return _buildSectionCard(
      title: title,
      subtitle: mod.veterinaryDecisionNotice,
      icon: Icons.checklist_rounded,
      iconColor: AppTheme.primaryTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mod.observationsToVerify.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'प्रत्यक्ष तपासणीत खात्री करण्याचे मुद्दे:' : (LocaleService.code == 'hi' ? 'प्रत्यक्ष जांच में सत्यापित करने योग्य बिंदु:' : 'Observations to Verify at Chute:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            ...mod.observationsToVerify.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_box_outline_blank_rounded, size: 14, color: AppTheme.primaryTeal),
                      const SizedBox(width: 6),
                      Expanded(child: Text(LocaleService.translateAdvisory(o), style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
          ],
          if (mod.examinationsToConsider.isNotEmpty) ...[
            Text(
              LocaleService.code == 'mr' ? 'विचारार्थ निदान चाचण्या:' : (LocaleService.code == 'hi' ? 'विचारणीय नैदानिक परीक्षण:' : 'Diagnostic Examinations to Consider:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            ...mod.examinationsToConsider.map((e) => Text('• ${LocaleService.translateAdvisory(e)}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // MODULE 7 WIDGET
  // -------------------------------------------------------------
  Widget _buildModule7Card(Module7ClinicalDecisionTemplate mod) {
    final title = LocaleService.code == 'mr'
        ? 'मॉड्युल ७: वैद्यकीय निर्णय आराखडा व पाठपुरावा'
        : (LocaleService.code == 'hi' ? 'मॉड्यूल 7: नैदानिक निर्णय प्रारूप और अनुवर्ती' : 'Module 7: Clinical Decision Template & Follow-up');

    return _buildSectionCard(
      title: title,
      subtitle: mod.practitionerActionNotice,
      icon: Icons.assignment_turned_in_rounded,
      iconColor: AppTheme.primaryTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mod.suggestedAssessmentPrompt != null) ...[
            Text(
              LocaleService.code == 'mr' ? 'सुचवलेला मूल्यांकन आराखडा:' : (LocaleService.code == 'hi' ? 'सुझाया गया मूल्यांकन ढांचा:' : 'Suggested Assessment Framework:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(LocaleService.translateAdvisory(mod.suggestedAssessmentPrompt!), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35)),
            const SizedBox(height: 8),
          ],
          if (mod.recommendedFollowUpWindow != null) ...[
            Row(
              children: [
                const Icon(Icons.alarm_rounded, size: 16, color: AppTheme.primaryTeal),
                const SizedBox(width: 6),
                Text(
                  '${LocaleService.code == 'mr' ? 'शिफारस केलेला पाठपुरावा:' : (LocaleService.code == 'hi' ? 'अनुशंसित अनुवर्ती:' : 'Recommended Follow-up:')} ${LocaleService.translateAdvisory(mod.recommendedFollowUpWindow!)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (mod.ownerAdviceGuidance != null) ...[
            Text(
              LocaleService.code == 'mr' ? 'पशुपालकास द्यावयाचा सल्ला व मार्गदर्शन:' : (LocaleService.code == 'hi' ? 'पशुपालक के लिए परामर्श और मार्गदर्शन:' : 'Owner Guidance to Communicate:'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(LocaleService.translateAdvisory(mod.ownerAdviceGuidance!), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
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
