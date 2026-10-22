import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/visit.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import 'clinical_intelligence_screen.dart';
import 'visit_entry_screen.dart';

class AnimalProfileScreen extends StatefulWidget {
  final int animalId;

  const AnimalProfileScreen({super.key, required this.animalId});

  @override
  State<AnimalProfileScreen> createState() => _AnimalProfileScreenState();
}

class _AnimalProfileScreenState extends State<AnimalProfileScreen> {
  late Future<AnimalDetail> _animalFuture;
  late Future<List<VisitModel>> _visitsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _animalFuture = ApiService.getAnimalDetail(widget.animalId);
      _visitsFuture = ApiService.getAnimalVisits(widget.animalId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Longitudinal Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Timeline',
            onPressed: _loadData,
          ),
        ],
      ),
      body: FutureBuilder<AnimalDetail>(
        future: _animalFuture,
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
                    const Icon(Icons.error_outline, size: 40, color: AppTheme.alertRed),
                    const SizedBox(height: 12),
                    Text('Failed to load profile: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
                  ],
                ),
              ),
            );
          }

          final animal = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadData(),
            color: AppTheme.primaryTeal,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Animal Profile Card
                Card(
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        animal.animalCode,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primaryTeal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      animal.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${animal.species} • ${animal.breed ?? 'Native'} • ${animal.ageYears ?? 0} years • ${animal.sex}',
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primaryLight,
                              child: Icon(Icons.pets, color: AppTheme.primaryTeal, size: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: AppTheme.borderSubtle),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.agriculture_rounded, size: 16, color: AppTheme.textMuted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${animal.farmName ?? ''} • ${animal.villageName ?? ''}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        if (animal.ownerName != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: AppTheme.textMuted),
                              const SizedBox(width: 6),
                              Text(
                                'Keeper: ${animal.ownerName} (${animal.contactNumber ?? 'N/A'})',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                        if (animal.tagRfid != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.qr_code_rounded, size: 16, color: AppTheme.textMuted),
                              const SizedBox(width: 6),
                              Text(
                                'RFID: ${animal.tagRfid}',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4338CA),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                        label: const Text('AI Intelligence', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClinicalIntelligenceScreen(
                                animalId: animal.id,
                                animalName: animal.name,
                                animalCode: animal.animalCode,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                        label: const Text('Record Visit'),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VisitEntryScreen(
                                preselectedAnimalId: animal.id,
                                preselectedAnimalCode: animal.animalCode,
                                preselectedAnimalName: animal.name,
                              ),
                            ),
                          );
                          if (result == true) {
                            _loadData();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Longitudinal History Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Longitudinal Clinical Timeline',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    FutureBuilder<List<VisitModel>>(
                      future: _visitsFuture,
                      builder: (context, snap) {
                        final count = snap.hasData ? snap.data!.length : 0;
                        return Text(
                          '$count encounters recorded',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Timeline Encounters List
                FutureBuilder<List<VisitModel>>(
                  future: _visitsFuture,
                  builder: (context, vSnapshot) {
                    if (vSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppTheme.primaryTeal)));
                    }
                    if (vSnapshot.hasError) {
                      return Text('Error loading visits: ${vSnapshot.error}', style: const TextStyle(color: AppTheme.alertRed));
                    }
                    final visits = vSnapshot.data ?? [];
                    if (visits.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(child: Text('No historical visits recorded for this animal yet.', style: TextStyle(color: AppTheme.textMuted))),
                        ),
                      );
                    }

                    return Column(
                      children: visits.map((v) => _buildTimelineItem(v)).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(VisitModel v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and severity row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 16, color: AppTheme.primaryTeal),
                      const SizedBox(width: 6),
                      Text(
                        v.visitDate,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (v.temperatureCelsius != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: v.temperatureCelsius! > 39.5 ? AppTheme.alertBg : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${v.temperatureCelsius}°C',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: v.temperatureCelsius! > 39.5 ? AppTheme.alertRed : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      StatusBadge.severity(v.severity),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Presenting complaint
              Text(
                v.presentingComplaint,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),

              // Symptoms Chips
              if (v.symptoms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: v.symptoms.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: Text(
                        _formatSymptom(s),
                        style: const TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Physical Observations
              if (v.observations != null && v.observations!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.remove_red_eye_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          v.observations!,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Treatment notes
              if (v.treatmentNotes != null && v.treatmentNotes!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.medication_outlined, size: 14, color: AppTheme.secondaryEmerald),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Treatment: ${v.treatmentNotes!}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],

              // Follow up
              if (v.followUpNotes != null && v.followUpNotes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.assignment_turned_in_outlined, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Follow-up: ${v.followUpNotes!}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatSymptom(String code) {
    return code
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
        .join(' ');
  }
}
