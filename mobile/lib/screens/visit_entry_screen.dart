import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/animal.dart';
import '../models/clinical_intelligence.dart';
import '../models/visit.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
import '../theme/app_theme.dart';
import 'clinical_intelligence_screen.dart';

class VisitEntryScreen extends StatefulWidget {
  final int? preselectedAnimalId;
  final String? preselectedAnimalCode;
  final String? preselectedAnimalName;

  const VisitEntryScreen({
    super.key,
    this.preselectedAnimalId,
    this.preselectedAnimalCode,
    this.preselectedAnimalName,
  });

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedAnimalId;
  AnimalDetail? _selectedAnimalDetail;
  List<VisitModel> _pastVisits = [];
  bool _isLoadingAnimalHistory = false;

  // Visit Draft Fields
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _onsetController = TextEditingController(text: '2 days');
  final TextEditingController _physicalExamController = TextEditingController();
  final TextEditingController _priorTreatmentsController = TextEditingController();
  final TextEditingController _priorResponseController = TextEditingController();

  String _severity = 'MODERATE';
  final Set<String> _selectedSymptoms = {'FEVER'};

  // Financial Breakdown Fields
  final TextEditingController _consultationFeeCtrl = TextEditingController(text: '250');
  final TextEditingController _serviceFeeCtrl = TextEditingController(text: '150');
  final TextEditingController _medicineFeeCtrl = TextEditingController(text: '300');
  final TextEditingController _otherFeeCtrl = TextEditingController(text: '0');

  // Stage 5 Final Assessment Fields
  final TextEditingController _finalAssessmentController = TextEditingController();
  final TextEditingController _actualTreatmentController = TextEditingController();
  final TextEditingController _ownerAdviceController = TextEditingController();
  DateTime? _followUpDueDate = DateTime.now().add(const Duration(days: 3));

  // AI Draft Analysis State
  ClinicalIntelligenceModel? _draftAnalysisResult;
  bool _isAnalyzingDraft = false;
  bool _isSaving = false;

  List<AnimalSummary> _availableAnimals = [];
  bool _isLoadingAnimals = false;

  final List<Map<String, String>> _symptomCatalog = [
    {'code': 'FEVER', 'label': 'Fever / Hyperthermia'},
    {'code': 'NASAL_DISCHARGE', 'label': 'Nasal Discharge'},
    {'code': 'REDUCED_APPETITE', 'label': 'Reduced Appetite'},
    {'code': 'COUGH', 'label': 'Cough / Rales'},
    {'code': 'DIARRHEA', 'label': 'Diarrhea / Scouring'},
    {'code': 'LETHARGY', 'label': 'Lethargy / Dull Demeanor'},
    {'code': 'EXCESSIVE_SALIVATION', 'label': 'Excessive Salivation'},
    {'code': 'REDUCED_MILK_PRODUCTION', 'label': 'Drop in Milk Yield'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedAnimalId != null) {
      _selectedAnimalId = widget.preselectedAnimalId;
      _loadSelectedAnimalHistory(_selectedAnimalId!);
    } else {
      _fetchAnimals();
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _tempController.dispose();
    _onsetController.dispose();
    _physicalExamController.dispose();
    _priorTreatmentsController.dispose();
    _priorResponseController.dispose();
    _consultationFeeCtrl.dispose();
    _serviceFeeCtrl.dispose();
    _medicineFeeCtrl.dispose();
    _otherFeeCtrl.dispose();
    _finalAssessmentController.dispose();
    _actualTreatmentController.dispose();
    _ownerAdviceController.dispose();
    super.dispose();
  }

  Future<void> _fetchAnimals() async {
    setState(() => _isLoadingAnimals = true);
    try {
      final animals = await ApiService.getAnimals();
      setState(() {
        _availableAnimals = animals;
        _isLoadingAnimals = false;
        if (animals.isNotEmpty && _selectedAnimalId == null) {
          _selectedAnimalId = animals.first.id;
          _loadSelectedAnimalHistory(_selectedAnimalId!);
        }
      });
    } catch (_) {
      setState(() => _isLoadingAnimals = false);
    }
  }

  Future<void> _loadSelectedAnimalHistory(int animalId) async {
    setState(() => _isLoadingAnimalHistory = true);
    try {
      final detail = await ApiService.getAnimalDetail(animalId);
      final visits = await ApiService.getAnimalVisits(animalId);
      if (mounted) {
        setState(() {
          _selectedAnimalDetail = detail;
          _pastVisits = visits;
          _isLoadingAnimalHistory = false;
          _draftAnalysisResult = null; // reset draft analysis on animal change
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingAnimalHistory = false);
    }
  }

  double get _totalCalculatedCharge {
    final c = double.tryParse(_consultationFeeCtrl.text.trim()) ?? 0.0;
    final s = double.tryParse(_serviceFeeCtrl.text.trim()) ?? 0.0;
    final m = double.tryParse(_medicineFeeCtrl.text.trim()) ?? 0.0;
    final o = double.tryParse(_otherFeeCtrl.text.trim()) ?? 0.0;
    return c + s + m + o;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickFollowUpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _followUpDueDate ?? DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _followUpDueDate = picked);
  }

  // -------------------------------------------------------------
  // STAGE 4: RUN NON-PERSISTING DRAFT CLINICAL INTELLIGENCE
  // -------------------------------------------------------------
  Future<void> _analyzeDraftVisit() async {
    if (_selectedAnimalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an animal first.')),
      );
      return;
    }

    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one clinical symptom.')),
      );
      return;
    }

    setState(() => _isAnalyzingDraft = true);

    try {
      final req = AnalyzeDraftRequest(
        animalId: _selectedAnimalId!,
        visitDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        presentingComplaint: _complaintController.text.trim().isNotEmpty
            ? _complaintController.text.trim()
            : 'Clinical examination requested',
        symptoms: _selectedSymptoms.toList(),
        symptomOnsetDuration: _onsetController.text.trim(),
        severity: _severity,
        temperatureCelsius: double.tryParse(_tempController.text.trim()),
        physicalExamFindings: _physicalExamController.text.trim(),
        treatmentsAdministeredPrior: _priorTreatmentsController.text.trim(),
      );

      final analysis = await ApiService.analyzeDraftVisit(req);

      if (mounted) {
        setState(() {
          _draftAnalysisResult = analysis;
          _isAnalyzingDraft = false;
          // If final assessment is still empty, suggest from AI findings
          if (_finalAssessmentController.text.trim().isEmpty &&
              analysis.possibleConditionsToConsider.isNotEmpty) {
            _finalAssessmentController.text =
                'Suspected: ${analysis.possibleConditionsToConsider.first}. Differential consideration based on longitudinal history.';
          }
          if (_ownerAdviceController.text.trim().isEmpty &&
              analysis.module7ClinicalDecision?.ownerAdviceGuidance != null) {
            _ownerAdviceController.text = analysis.module7ClinicalDecision!.ownerAdviceGuidance!;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft analyzed! Clinical intelligence generated across 7 modules.'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzingDraft = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Draft analysis failed: $e'), backgroundColor: AppTheme.alertRed),
        );
      }
    }
  }

  // -------------------------------------------------------------
  // STAGE 5: SAVE COMPLETE ENCOUNTER
  // -------------------------------------------------------------
  Future<void> _saveVisit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAnimalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an animal record.')),
      );
      return;
    }

    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one clinical symptom.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dto = CreateVisitDto(
        animalId: _selectedAnimalId!,
        visitDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        presentingComplaint: _complaintController.text.trim(),
        observations: _physicalExamController.text.trim().isNotEmpty ? _physicalExamController.text.trim() : null,
        severity: _severity,
        temperatureCelsius: double.tryParse(_tempController.text.trim()),
        treatmentNotes: _actualTreatmentController.text.trim().isNotEmpty
            ? _actualTreatmentController.text.trim()
            : null,
        followUpNotes: _ownerAdviceController.text.trim().isNotEmpty ? _ownerAdviceController.text.trim() : null,
        symptoms: _selectedSymptoms.toList(),
        symptomOnsetDuration: _onsetController.text.trim().isNotEmpty ? _onsetController.text.trim() : null,
        physicalExamFindings: _physicalExamController.text.trim().isNotEmpty ? _physicalExamController.text.trim() : null,
        treatmentsAdministeredPrior: _priorTreatmentsController.text.trim().isNotEmpty ? _priorTreatmentsController.text.trim() : null,
        priorTreatmentResponse: _priorResponseController.text.trim().isNotEmpty ? _priorResponseController.text.trim() : null,
        finalClinicalAssessment: _finalAssessmentController.text.trim().isNotEmpty ? _finalAssessmentController.text.trim() : null,
        actualTreatmentAdministered: _actualTreatmentController.text.trim().isNotEmpty ? _actualTreatmentController.text.trim() : null,
        ownerAdvice: _ownerAdviceController.text.trim().isNotEmpty ? _ownerAdviceController.text.trim() : null,
        followUpDueDate: _followUpDueDate != null ? DateFormat('yyyy-MM-dd').format(_followUpDueDate!) : null,
        followUpStatus: _followUpDueDate != null ? 'PENDING' : null,
        consultationFee: double.tryParse(_consultationFeeCtrl.text.trim()) ?? 0.0,
        serviceFee: double.tryParse(_serviceFeeCtrl.text.trim()) ?? 0.0,
        medicineFee: double.tryParse(_medicineFeeCtrl.text.trim()) ?? 0.0,
        otherFee: double.tryParse(_otherFeeCtrl.text.trim()) ?? 0.0,
        totalCharge: _totalCalculatedCharge,
      );

      final saved = await ApiService.createVisit(dto);
      AppDataSync.notifyDataChanged();

      if (!mounted) return;
      setState(() => _isSaving = false);

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.successGreen),
              SizedBox(width: 8),
              Text('Encounter Saved', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Visit #${saved.id} successfully persisted to PostgreSQL.'),
              const SizedBox(height: 10),
              Text('Total Billed: ₹${saved.totalCharge.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryTeal)),
              const SizedBox(height: 4),
              Text('Assigned to Owner Ledger for ${saved.farmName ?? "Farm"}.'),
              if (saved.followUpDueDate != null) ...[
                const SizedBox(height: 4),
                Text('Follow-up scheduled: ${saved.followUpDueDate}', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, true);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save visit: $e'), backgroundColor: AppTheme.alertRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Visit Workflow', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoadingAnimals
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // =========================================================
                  // STAGE 1: SELECT ANIMAL CONTEXT
                  // =========================================================
                  _buildSectionHeader('Stage 1: Animal Identification & Context', Icons.pets_rounded),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.preselectedAnimalId != null) ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.preselectedAnimalCode ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.preselectedAnimalName ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ] else ...[
                            DropdownButtonFormField<int>(
                              initialValue: _selectedAnimalId,
                              decoration: const InputDecoration(
                                labelText: 'Select Registered Animal *',
                                prefixIcon: Icon(Icons.search_rounded, color: AppTheme.primaryTeal),
                              ),
                              items: _availableAnimals.map((a) {
                                return DropdownMenuItem<int>(
                                  value: a.id,
                                  child: Text('${a.animalCode} — ${a.name} (${a.species}, ${a.farmName ?? "Farm"})'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedAnimalId = val);
                                  _loadSelectedAnimalHistory(val);
                                }
                              },
                            ),
                          ],
                          if (_selectedAnimalDetail != null) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                _infoBadge(Icons.agriculture_rounded, '${_selectedAnimalDetail!.farmName} (${_selectedAnimalDetail!.villageName})'),
                                _infoBadge(Icons.person_rounded, 'Owner: ${_selectedAnimalDetail!.ownerName ?? "N/A"}'),
                                _infoBadge(Icons.phone_rounded, _selectedAnimalDetail!.contactNumber ?? 'No phone'),
                                _infoBadge(Icons.category_rounded, '${_selectedAnimalDetail!.species} • ${_selectedAnimalDetail!.breed ?? "Native"}'),
                                _infoBadge(Icons.cake_rounded, '${_selectedAnimalDetail!.ageYears ?? 0} yrs • ${_selectedAnimalDetail!.sex}'),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // =========================================================
                  // STAGE 2: PREVIOUS HEALTH RECORDS (EXPANDABLE)
                  // =========================================================
                  _buildSectionHeader('Stage 2: Previous Health Records', Icons.history_edu_rounded),
                  Card(
                    child: ExpansionTile(
                      initiallyExpanded: false,
                      leading: const Icon(Icons.folder_shared_rounded, color: AppTheme.primaryTeal),
                      title: Text(
                        'Past Medical History (${_pastVisits.length} recorded visits)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: const Text('Review longitudinal complaints, prior diagnoses, and treatments', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      children: [
                        if (_isLoadingAnimalHistory)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal)),
                          )
                        else if (_pastVisits.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No previous visits on record. This is a first-time encounter.', style: TextStyle(color: AppTheme.textMuted)),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _pastVisits.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final v = _pastVisits[i];
                              return ListTile(
                                dense: true,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(v.visitDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(v.severity, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: v.severity == 'SEVERE' ? AppTheme.alertRed : AppTheme.warningAmber)),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(v.presentingComplaint),
                                    if (v.symptoms.isNotEmpty)
                                      Text('Symptoms: ${v.symptoms.join(", ")}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                    if (v.treatmentNotes != null)
                                      Text('Rx: ${v.treatmentNotes}', style: const TextStyle(fontSize: 11, color: AppTheme.primaryTeal)),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // =========================================================
                  // STAGE 3: CURRENT VISIT DRAFT ENTRY & FINANCIALS
                  // =========================================================
                  _buildSectionHeader('Stage 3: Current Visit Draft Entry & Fees', Icons.edit_note_rounded),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _pickDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Visit Date',
                                      prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                                    ),
                                    child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _tempController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Temp (°C)',
                                    hintText: 'e.g. 39.8',
                                    prefixIcon: Icon(Icons.thermostat_rounded, size: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _onsetController,
                                  decoration: const InputDecoration(
                                    labelText: 'Onset Duration',
                                    hintText: 'e.g. 2 days',
                                    prefixIcon: Icon(Icons.timelapse_rounded, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _complaintController,
                            decoration: const InputDecoration(
                              labelText: 'Presenting Complaint *',
                              hintText: 'e.g., Persistent high fever, off feed, nasal rales',
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Presenting complaint is required' : null,
                          ),
                          const SizedBox(height: 12),
                          const Text('Clinical Severity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(
                            children: ['MILD', 'MODERATE', 'SEVERE'].map((sev) {
                              final isSel = _severity == sev;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: ChoiceChip(
                                    label: Text(sev),
                                    selected: isSel,
                                    selectedColor: AppTheme.primaryLight,
                                    labelStyle: TextStyle(
                                      color: isSel ? AppTheme.primaryTeal : AppTheme.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    onSelected: (val) {
                                      if (val) setState(() => _severity = sev);
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                          const Text('Symptoms Observed *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _symptomCatalog.map((s) {
                              final code = s['code']!;
                              final isSelected = _selectedSymptoms.contains(code);
                              return FilterChip(
                                label: Text(s['label']!),
                                selected: isSelected,
                                selectedColor: AppTheme.primaryLight,
                                checkmarkColor: AppTheme.primaryTeal,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _selectedSymptoms.add(code);
                                    } else {
                                      _selectedSymptoms.remove(code);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _physicalExamController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Physical Examination Findings',
                              hintText: 'Mucous membranes congested, lung auscultation rales, submandibular edema...',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _priorTreatmentsController,
                                  decoration: const InputDecoration(
                                    labelText: 'Prior Home / Field Remedies',
                                    hintText: 'e.g. Paracetamol bolus given yesterday',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _priorResponseController,
                                  decoration: const InputDecoration(
                                    labelText: 'Response to Prior Rx',
                                    hintText: 'e.g. Transient defervescence only',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 28),
                          // Financial Ledger Fee Breakdown
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Encounter Fee Breakdown (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(
                                'Total: ₹${_totalCalculatedCharge.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryTeal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _consultationFeeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Consult (₹)', isDense: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _serviceFeeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Services (₹)', isDense: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _medicineFeeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Meds (₹)', isDense: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _otherFeeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Other (₹)', isDense: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // =========================================================
                  // STAGE 4: AI CLINICAL INTELLIGENCE PREVIEW (7 MODULES)
                  // =========================================================
                  _buildSectionHeader('Stage 4: Draft Clinical Intelligence', Icons.psychology_rounded),
                  Card(
                    color: AppTheme.surfaceBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.primaryTeal, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Analyze Current Visit + Medical History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    SizedBox(height: 2),
                                    Text('Generate 7-module clinical decision support before committing', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                icon: _isAnalyzingDraft
                                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.auto_awesome_rounded, size: 16),
                                label: Text(_isAnalyzingDraft ? 'Analyzing...' : 'Analyze Draft'),
                                onPressed: _isAnalyzingDraft ? null : _analyzeDraftVisit,
                              ),
                            ],
                          ),
                          if (_draftAnalysisResult != null) ...[
                            const Divider(height: 24),
                            _buildDraftIntelligencePreview(_draftAnalysisResult!),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // =========================================================
                  // STAGE 5: FINAL ASSESSMENT, TREATMENT & SAVE
                  // =========================================================
                  _buildSectionHeader('Stage 5: Final Veterinary Assessment & Action', Icons.verified_rounded),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _finalAssessmentController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Final Clinical Assessment / Working Diagnosis *',
                              hintText: 'e.g. Acute Bovine Respiratory Disease Complex (BRDC)',
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Assessment is required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _actualTreatmentController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Actual Treatment Administered *',
                              hintText: 'e.g. Ceftiofur 2.2mg/kg IM, Meloxicam 0.5mg/kg SC, multivitamin injection',
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Treatment details are required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _ownerAdviceController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Owner Advice & Biosecurity Protocols',
                              hintText: 'e.g. Isolate animal from common feeder, offer warm gruel, record morning rectal temp',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _pickFollowUpDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Follow-up Due Date',
                                      prefixIcon: Icon(Icons.alarm_rounded, size: 18),
                                    ),
                                    child: Text(
                                      _followUpDueDate != null ? DateFormat('yyyy-MM-dd').format(_followUpDueDate!) : 'None scheduled',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              if (_followUpDueDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                                  onPressed: () => setState(() => _followUpDueDate = null),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppTheme.primaryTeal,
                      ),
                      icon: _isSaving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_rounded, size: 20),
                      label: Text(
                        _isSaving ? 'Persisting Clinical Encounter...' : 'Submit Encounter (₹${_totalCalculatedCharge.toStringAsFixed(0)})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _isSaving ? null : _saveVisit,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryTeal),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }

  Widget _buildDraftIntelligencePreview(ClinicalIntelligenceModel ci) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: ci.isLiveLlm ? AppTheme.successBg : AppTheme.warningBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                ci.isLiveLlm ? '⚡ Gemini Live LLM' : '⚙️ Rule-Engine Fallback',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ci.isLiveLlm ? AppTheme.successGreen : AppTheme.warningAmber,
                ),
              ),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new_rounded, size: 14),
              label: const Text('View Full 7 Modules', style: TextStyle(fontSize: 12)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicalIntelligenceScreen(
                      animalId: ci.animalId,
                      preloadedData: ci,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          ci.clinicalSummary,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
        ),
        if (ci.possibleConditionsToConsider.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text('Top Conditions to Consider:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...ci.possibleConditionsToConsider.take(2).map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.medical_services_outlined, size: 14, color: AppTheme.primaryTeal),
                    const SizedBox(width: 6),
                    Expanded(child: Text(c, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              )),
        ],
        if (ci.module5RiskIndicators != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ci.module5RiskIndicators!.urgencyLevel == 'CRITICAL_ATTENTION'
                  ? AppTheme.alertBg
                  : ci.module5RiskIndicators!.urgencyLevel == 'ELEVATED'
                      ? AppTheme.warningBg
                      : AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: ci.module5RiskIndicators!.urgencyLevel == 'CRITICAL_ATTENTION'
                      ? AppTheme.alertRed
                      : AppTheme.warningAmber,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Urgency Level: ${ci.module5RiskIndicators!.urgencyLevel}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
