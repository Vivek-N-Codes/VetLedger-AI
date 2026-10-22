import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/farm.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
import '../theme/app_theme.dart';
import 'animal_profile_screen.dart';
import 'ledger_screen.dart';
import 'visit_entry_screen.dart';

class FarmProfileScreen extends StatefulWidget {
  final int farmId;

  const FarmProfileScreen({super.key, required this.farmId});

  @override
  State<FarmProfileScreen> createState() => _FarmProfileScreenState();
}

class _FarmProfileScreenState extends State<FarmProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FarmDetail? _farm;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFarmDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFarmDetail() async {
    setState(() => _isLoading = true);
    try {
      final detail = await ApiService.getFarmDetail(widget.farmId);
      if (mounted) {
        setState(() {
          _farm = detail;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _showAddAnimalDialog() {
    if (_farm == null) return;
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final breedCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String species = 'CATTLE';
    String sex = 'FEMALE';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.pets_rounded, color: AppTheme.primaryTeal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Add Animal to ${_farm!.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Animal Name *',
                      hintText: 'e.g., Gauri, Bella',
                      prefixIcon: Icon(Icons.badge_rounded, color: AppTheme.primaryTeal),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: species,
                    decoration: const InputDecoration(
                      labelText: 'Species *',
                      prefixIcon: Icon(Icons.category_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'CATTLE', child: Text('Cattle')),
                      DropdownMenuItem(value: 'BUFFALO', child: Text('Buffalo')),
                      DropdownMenuItem(value: 'GOAT', child: Text('Goat')),
                      DropdownMenuItem(value: 'SHEEP', child: Text('Sheep')),
                    ],
                    onChanged: (val) => setDialogState(() => species = val ?? 'CATTLE'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: breedCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Breed',
                            hintText: 'e.g., Murrah, Gir',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: ageCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Age (Years)',
                            hintText: 'e.g., 3.5',
                          ),
                          validator: (v) {
                            if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: sex,
                    decoration: const InputDecoration(
                      labelText: 'Sex *',
                      prefixIcon: Icon(Icons.male_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                      DropdownMenuItem(value: 'MALE', child: Text('Male')),
                    ],
                    onChanged: (val) => setDialogState(() => sex = val ?? 'FEMALE'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: tagCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ear Tag / RFID (Optional)',
                      hintText: 'e.g., IN-98214-A',
                      prefixIcon: Icon(Icons.qr_code_rounded, color: AppTheme.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Physical ID & Markings',
                      hintText: 'e.g., White star on forehead, notched left ear',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  try {
                    final req = CreateAnimalRequest(
                      name: nameCtrl.text.trim(),
                      species: species,
                      breed: breedCtrl.text.trim().isNotEmpty ? breedCtrl.text.trim() : null,
                      ageYears: ageCtrl.text.trim().isNotEmpty ? double.tryParse(ageCtrl.text.trim()) : null,
                      sex: sex,
                      farmId: _farm!.id,
                      tagRfid: tagCtrl.text.trim().isNotEmpty ? tagCtrl.text.trim() : null,
                      notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                    );
                    await ApiService.registerAnimal(req);
                    if (ctx.mounted) Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Animal registered to farm successfully!'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                    _loadFarmDetail();
                    AppDataSync.notifyDataChanged();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.alertRed),
                    );
                  }
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Farm Profile')),
        body: const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal)),
      );
    }

    if (_error != null || _farm == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Farm Profile')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppTheme.alertRed, size: 48),
              const SizedBox(height: 12),
              Text('Error: $_error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadFarmDetail, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final farm = _farm!;

    return Scaffold(
      appBar: AppBar(
        title: Text(farm.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _loadFarmDetail,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Animal', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _showAddAnimalDialog,
      ),
      body: Column(
        children: [
          // Farm Header Card
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.agriculture_rounded, color: AppTheme.primaryTeal, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farm.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                farm.farmCode,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.textMuted),
                              Text(farm.villageName, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Owner & Contact Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person_rounded, size: 16, color: AppTheme.primaryTeal),
                                const SizedBox(width: 6),
                                Text(
                                  farm.ownerName ?? 'Owner Unassigned',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            if (farm.ownerPhone != null && farm.ownerPhone!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Phone: ${farm.ownerPhone}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.receipt_long_rounded, size: 16),
                        label: const Text('Owner Ledger', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          side: const BorderSide(color: AppTheme.primaryTeal),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LedgerScreen(initialOwnerId: farm.ownerId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (farm.address != null && farm.address!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(farm.address!, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryTeal,
            unselectedLabelColor: AppTheme.textMuted,
            indicatorColor: AppTheme.primaryTeal,
            tabs: [
              Tab(text: 'Registered Animals (${farm.animals.length})'),
              Tab(text: 'Clinical History (${farm.recentVisits.length})'),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Animals list
                farm.animals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pets_rounded, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text('No animals registered to this farm yet.'),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Register First Animal'),
                              onPressed: _showAddAnimalDialog,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: farm.animals.length,
                        itemBuilder: (ctx, idx) {
                          final animal = farm.animals[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primaryLight,
                                child: Text(
                                  animal.species.isNotEmpty ? animal.species[0].toUpperCase() : 'A',
                                  style: const TextStyle(color: AppTheme.primaryTeal, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(animal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${animal.species} • ${animal.breed ?? 'Native'} • ${animal.sex} • ${animal.ageYears != null ? '${animal.ageYears} yrs' : 'Age unknown'}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.note_add_rounded, color: AppTheme.primaryTeal, size: 20),
                                    tooltip: 'Log Visit for ${animal.name}',
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
                                        _loadFarmDetail();
                                        AppDataSync.notifyDataChanged();
                                      }
                                    },
                                  ),
                                  const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnimalProfileScreen(animalId: animal.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                // Recent visits
                farm.recentVisits.isEmpty
                    ? const Center(child: Text('No clinical visits recorded for this farm yet.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: farm.recentVisits.length,
                        itemBuilder: (ctx, idx) {
                          final v = farm.recentVisits[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        v.animalName ?? 'Animal #${v.animalId}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        v.visitDate,
                                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    v.presentingComplaint,
                                    style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                                  ),
                                  if (v.symptoms.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: v.symptoms.map((s) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceBackground,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppTheme.borderSubtle),
                                          ),
                                          child: Text(s, style: const TextStyle(fontSize: 11)),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                  if (v.totalCharge > 0) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Billed: ₹${v.totalCharge.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: v.paymentStatus == 'PAID' ? AppTheme.successBg : AppTheme.warningBg,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            v.paymentStatus,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: v.paymentStatus == 'PAID' ? AppTheme.successGreen : AppTheme.warningAmber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
