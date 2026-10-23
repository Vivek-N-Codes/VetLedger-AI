import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/farm.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
import '../services/locale_service.dart';
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
                  LocaleService.code == 'mr'
                      ? 'नवीन जनावर जोडा (${_farm!.name})'
                      : (LocaleService.code == 'hi' ? 'नया पशु जोड़ें (${_farm!.name})' : 'Add Animal to ${_farm!.name}'),
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
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'जनावराचे नाव *' : (LocaleService.code == 'hi' ? 'पशु का नाम *' : 'Animal Name *'),
                      hintText: LocaleService.code == 'mr' ? 'उदा. गौरी, कपिला' : (LocaleService.code == 'hi' ? 'उदा. गौरी, कपिला' : 'e.g., Gauri, Bella'),
                      prefixIcon: const Icon(Icons.badge_rounded, color: AppTheme.primaryTeal),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? (LocaleService.code == 'mr' ? 'नाव आवश्यक आहे' : (LocaleService.code == 'hi' ? 'नाम आवश्यक है' : 'Name is required'))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: species,
                    decoration: InputDecoration(
                      labelText: '${LocaleService.t('species')} *',
                      prefixIcon: const Icon(Icons.category_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: [
                      DropdownMenuItem(value: 'CATTLE', child: Text(LocaleService.translateSpecies('CATTLE'))),
                      DropdownMenuItem(value: 'BUFFALO', child: Text(LocaleService.translateSpecies('BUFFALO'))),
                      DropdownMenuItem(value: 'GOAT', child: Text(LocaleService.translateSpecies('GOAT'))),
                      DropdownMenuItem(value: 'SHEEP', child: Text(LocaleService.translateSpecies('SHEEP'))),
                    ],
                    onChanged: (val) => setDialogState(() => species = val ?? 'CATTLE'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: breedCtrl,
                          decoration: InputDecoration(
                            labelText: LocaleService.t('breed'),
                            hintText: 'e.g., Murrah, Gir',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: ageCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: LocaleService.code == 'mr' ? 'वय (वर्षे)' : (LocaleService.code == 'hi' ? 'आयु (वर्ष)' : 'Age (Years)'),
                            hintText: 'e.g., 3.5',
                          ),
                          validator: (v) {
                            if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                              return LocaleService.code == 'mr' ? 'अवैध संख्या' : (LocaleService.code == 'hi' ? 'अमान्य संख्या' : 'Invalid number');
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: sex,
                    decoration: InputDecoration(
                      labelText: '${LocaleService.code == 'mr' ? 'लिंग' : (LocaleService.code == 'hi' ? 'लिंग' : 'Sex')} *',
                      prefixIcon: const Icon(Icons.male_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: [
                      DropdownMenuItem(value: 'FEMALE', child: Text(LocaleService.translateSex('FEMALE'))),
                      DropdownMenuItem(value: 'MALE', child: Text(LocaleService.translateSex('MALE'))),
                    ],
                    onChanged: (val) => setDialogState(() => sex = val ?? 'FEMALE'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: tagCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'इअर टॅग / RFID (ऐच्छिक)' : (LocaleService.code == 'hi' ? 'ईयर टैग / आरएफआईडी (वैकल्पिक)' : 'Ear Tag / RFID (Optional)'),
                      hintText: 'e.g., IN-98214-A',
                      prefixIcon: const Icon(Icons.qr_code_rounded, color: AppTheme.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'शारीरिक ओळख व खुणा' : (LocaleService.code == 'hi' ? 'शारीरिक पहचान और निशान' : 'Physical ID & Markings'),
                      hintText: LocaleService.code == 'mr' ? 'उदा. कपाळावर पांढरा टिळा, डावा कान कापलेला' : (LocaleService.code == 'hi' ? 'उदा. माथे पर सफेद तारा' : 'e.g., White star on forehead'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(LocaleService.code == 'mr' ? 'रद्द करा' : (LocaleService.code == 'hi' ? 'रद्द करें' : 'Cancel')),
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
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleService.code == 'mr' ? 'जनावर फार्मवर यशस्वीरीत्या नोंदवले!' : (LocaleService.code == 'hi' ? 'पशु सफलतापूर्वक पंजीकृत हुआ!' : 'Animal registered to farm successfully!')),
                          backgroundColor: AppTheme.successGreen,
                        ),
                      );
                    }
                    _loadFarmDetail();
                    AppDataSync.notifyDataChanged();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.alertRed),
                      );
                    }
                  }
                }
              },
              child: Text(LocaleService.code == 'mr' ? 'नोंदणी करा' : (LocaleService.code == 'hi' ? 'पंजीकृत करें' : 'Register')),
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
        appBar: AppBar(title: Text(LocaleService.code == 'mr' ? 'फार्म प्रोफाइल' : (LocaleService.code == 'hi' ? 'फार्म प्रोफ़ाइल' : 'Farm Profile'))),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppTheme.alertRed, size: 48),
              const SizedBox(height: 12),
              Text('Error: $_error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadFarmDetail, child: Text(LocaleService.code == 'mr' ? 'पुन्हा प्रयत्न करा' : (LocaleService.code == 'hi' ? 'पुनः प्रयास करें' : 'Retry'))),
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
            tooltip: LocaleService.code == 'mr' ? 'रिफ्रेश करा' : (LocaleService.code == 'hi' ? 'ताज़ा करें' : 'Refresh'),
            onPressed: _loadFarmDetail,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          LocaleService.code == 'mr' ? 'नवीन जनावर' : (LocaleService.code == 'hi' ? 'नया पशु' : 'Add Animal'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
                                  farm.ownerName ?? (LocaleService.code == 'mr' ? 'मालक नेमलेले नाही' : (LocaleService.code == 'hi' ? 'मालिक अनिर्धारित' : 'Owner Unassigned')),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            if (farm.ownerPhone != null && farm.ownerPhone!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${LocaleService.code == 'mr' ? 'मोबाईल:' : (LocaleService.code == 'hi' ? 'मोबाइल:' : 'Phone:')} ${farm.ownerPhone}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.receipt_long_rounded, size: 16),
                        label: Text(
                          LocaleService.code == 'mr' ? 'खातेवही' : (LocaleService.code == 'hi' ? 'बहीखाता' : 'Owner Ledger'),
                          style: const TextStyle(fontSize: 12),
                        ),
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
              Tab(
                text: LocaleService.code == 'mr'
                    ? 'नोंदणीकृत जनावरे (${farm.animals.length})'
                    : (LocaleService.code == 'hi' ? 'पंजीकृत पशु (${farm.animals.length})' : 'Registered Animals (${farm.animals.length})'),
              ),
              Tab(
                text: LocaleService.code == 'mr'
                    ? 'तपासणी इतिहास (${farm.recentVisits.length})'
                    : (LocaleService.code == 'hi' ? 'नैदानिक इतिहास (${farm.recentVisits.length})' : 'Clinical History (${farm.recentVisits.length})'),
              ),
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
                            Text(LocaleService.code == 'mr' ? 'या फार्मवर अद्याप कोणतीही जनावरे नोंदवलेली नाहीत.' : (LocaleService.code == 'hi' ? 'इस फार्म पर अभी कोई पशु पंजीकृत नहीं है।' : 'No animals registered to this farm yet.')),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: Text(LocaleService.code == 'mr' ? 'पहिले जनावर नोंदवा' : (LocaleService.code == 'hi' ? 'पहला पशु जोड़ें' : 'Register First Animal')),
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
                                '${LocaleService.translateSpecies(animal.species)} • ${animal.breed ?? 'Native'} • ${LocaleService.translateSex(animal.sex)} • ${animal.ageYears != null ? '${animal.ageYears} ${LocaleService.code == 'mr' ? 'वर्षे' : (LocaleService.code == 'hi' ? 'वर्ष' : 'yrs')}' : (LocaleService.code == 'mr' ? 'वय अज्ञात' : 'Age unknown')}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.note_add_rounded, color: AppTheme.primaryTeal, size: 20),
                                    tooltip: '${LocaleService.code == 'mr' ? 'तपासणी नोंदवा' : (LocaleService.code == 'hi' ? 'दौरा दर्ज करें' : 'Log Visit')} (${animal.name})',
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
                    ? Center(child: Text(LocaleService.code == 'mr' ? 'या फार्मसाठी अद्याप कोणतीही तपासणी नोंदवलेली नाही.' : (LocaleService.code == 'hi' ? 'इस फार्म के लिए अभी कोई नैदानिक दौरा दर्ज नहीं है।' : 'No clinical visits recorded for this farm yet.')))
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
                                        v.animalName ?? '${LocaleService.code == 'mr' ? 'जनावर' : 'Animal'} #${v.animalId}',
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
                                    LocaleService.translateAdvisory(v.presentingComplaint),
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
                                          child: Text(LocaleService.translateSymptom(s), style: const TextStyle(fontSize: 11)),
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
                                          '${LocaleService.code == 'mr' ? 'आकारणी' : (LocaleService.code == 'hi' ? 'शुल्क' : 'Billed')}: ₹${v.totalCharge.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: v.paymentStatus == 'PAID' ? AppTheme.successBg : AppTheme.warningBg,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            LocaleService.translatePaymentStatus(v.paymentStatus),
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
