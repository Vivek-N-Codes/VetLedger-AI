import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/animal.dart';
import '../models/visit.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

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

  DateTime _selectedDate = DateTime.now();
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _followUpController = TextEditingController();

  String _severity = 'MODERATE';
  final Set<String> _selectedSymptoms = {};

  bool _isSaving = false;
  List<AnimalSummary> _availableAnimals = [];
  bool _isLoadingAnimals = false;

  final List<Map<String, String>> _symptomCatalog = [
    {'code': 'FEVER', 'label': 'Fever / Hyperthermia'},
    {'code': 'NASAL_DISCHARGE', 'label': 'Nasal Discharge'},
    {'code': 'REDUCED_APPETITE', 'label': 'Reduced Appetite'},
    {'code': 'COUGH', 'label': 'Cough / Rales'},
    {'code': 'DIARRHEA', 'label': 'Diarrhea / Scouring'},
    {'code': 'LETHARGY', 'label': 'Lethargy / Dull'},
    {'code': 'EXCESSIVE_SALIVATION', 'label': 'Excessive Salivation'},
    {'code': 'REDUCED_MILK_PRODUCTION', 'label': 'Drop in Milk Yield'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedAnimalId != null) {
      _selectedAnimalId = widget.preselectedAnimalId;
    } else {
      _fetchAnimals();
    }
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
        }
      });
    } catch (_) {
      setState(() => _isLoadingAnimals = false);
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _tempController.dispose();
    _observationsController.dispose();
    _treatmentController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryTeal),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveVisit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAnimalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an animal for this clinical encounter.')),
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
      double? temp;
      if (_tempController.text.trim().isNotEmpty) {
        temp = double.tryParse(_tempController.text.trim());
      }

      final dto = CreateVisitDto(
        animalId: _selectedAnimalId!,
        visitDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        presentingComplaint: _complaintController.text.trim(),
        observations: _observationsController.text.trim().isNotEmpty ? _observationsController.text.trim() : null,
        severity: _severity,
        temperatureCelsius: temp,
        treatmentNotes: _treatmentController.text.trim().isNotEmpty ? _treatmentController.text.trim() : null,
        followUpNotes: _followUpController.text.trim().isNotEmpty ? _followUpController.text.trim() : null,
        symptoms: _selectedSymptoms.toList(),
      );

      final saved = await ApiService.createVisit(dto);

      if (!mounted) return;
      setState(() => _isSaving = false);

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.successGreen),
              SizedBox(width: 8),
              Text('Encounter Saved'),
            ],
          ),
          content: Text(
            'Clinical visit recorded successfully (Visit ID: ${saved.id}) and persisted to PostgreSQL.\nTimeline updated.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, true); // return true to refresh
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
        SnackBar(
          content: Text('Error saving visit: $e'),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Clinical Visit'),
      ),
      body: _isLoadingAnimals
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Animal Context Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Animal Context', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
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
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primaryTeal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.preselectedAnimalName ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ] else ...[
                            DropdownButtonFormField<int>(
                              initialValue: _selectedAnimalId,
                              decoration: const InputDecoration(labelText: 'Select Animal Record'),
                              items: _availableAnimals.map((a) {
                                return DropdownMenuItem<int>(
                                  value: a.id,
                                  child: Text('${a.animalCode} — ${a.name} (${a.breed ?? a.species}, ${a.farmName ?? ''})'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedAnimalId = val;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Date and Vitals Row
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
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(_selectedDate),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _tempController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Temperature (°C)',
                            hintText: 'e.g. 39.5',
                            prefixIcon: Icon(Icons.thermostat_rounded, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Presenting Complaint
                  TextFormField(
                    controller: _complaintController,
                    decoration: const InputDecoration(
                      labelText: 'Presenting Complaint *',
                      hintText: 'e.g. Persistent high fever, serous nasal discharge, off-feed for 2 days',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Presenting complaint is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Severity Selection
                  const Text('Clinical Severity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['MILD', 'MODERATE', 'SEVERE'].map((sev) {
                      final isSelected = _severity == sev;
                      Color activeColor;
                      if (sev == 'SEVERE') {
                        activeColor = AppTheme.alertRed;
                      } else if (sev == 'MODERATE') {
                        activeColor = AppTheme.warningAmber;
                      } else {
                        activeColor = AppTheme.successGreen;
                      }

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(sev),
                            selected: isSelected,
                            selectedColor: activeColor.withValues(alpha: 0.18),
                            labelStyle: TextStyle(
                              color: isSelected ? activeColor : AppTheme.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: isSelected ? activeColor : AppTheme.borderSubtle),
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _severity = sev);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Standardized Symptoms Multiselect Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Standardized Symptoms *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(
                        '${_selectedSymptoms.length} selected',
                        style: const TextStyle(fontSize: 12, color: AppTheme.primaryTeal, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptomCatalog.map((item) {
                      final code = item['code']!;
                      final label = item['label']!;
                      final isSelected = _selectedSymptoms.contains(code);

                      return FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        showCheckmark: true,
                        checkmarkColor: AppTheme.primaryTeal,
                        selectedColor: AppTheme.primaryLight,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.primaryTeal : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: isSelected ? AppTheme.primaryTeal : AppTheme.borderSubtle),
                        ),
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
                  const SizedBox(height: 16),

                  // Clinical Observations
                  TextFormField(
                    controller: _observationsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Clinical Examination & Physical Observations',
                      hintText: 'Auscultation findings, mucosal examination, ruminal motility, lymph node palpation...',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Treatment Administered
                  TextFormField(
                    controller: _treatmentController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Treatment & Therapies Administered',
                      hintText: 'Antipyretics, fluid resuscitation, supportive vitamins, local dressings...',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Follow-up notes
                  TextFormField(
                    controller: _followUpController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Follow-up & Biosecurity Advice',
                      hintText: 'Isolation protocols, temperature monitoring frequency, re-check schedule...',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: _isSaving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_rounded, size: 20),
                      label: Text(_isSaving ? 'Persisting Encounter...' : 'Save Clinical Encounter'),
                      onPressed: _isSaving ? null : _saveVisit,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
