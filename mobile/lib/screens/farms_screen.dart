import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
import '../services/locale_service.dart';
import '../theme/app_theme.dart';
import 'farm_profile_screen.dart';

class FarmsScreen extends StatefulWidget {
  const FarmsScreen({super.key});

  @override
  State<FarmsScreen> createState() => _FarmsScreenState();
}

class _FarmsScreenState extends State<FarmsScreen> {
  List<FarmSummary> _allFarms = [];
  List<FarmSummary> _filteredFarms = [];
  List<Map<String, dynamic>> _villages = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  int? _selectedVillageId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    AppDataSync.changeNotifier.addListener(_refreshFarms);
  }

  @override
  void dispose() {
    AppDataSync.changeNotifier.removeListener(_refreshFarms);
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchQuery.trim().toLowerCase();
    setState(() {
      _filteredFarms = _allFarms.where((f) {
        // Village filter
        if (_selectedVillageId != null && f.villageId != _selectedVillageId) {
          return false;
        }
        // Query match
        if (query.isEmpty) return true;
        final nameMatch = f.name.toLowerCase().contains(query);
        final codeMatch = f.farmCode.toLowerCase().contains(query);
        final ownerMatch = f.ownerName != null && f.ownerName!.toLowerCase().contains(query);
        final villageMatch = f.villageName.toLowerCase().contains(query);
        final addressMatch = f.address != null && f.address!.toLowerCase().contains(query);
        return nameMatch || codeMatch || ownerMatch || villageMatch || addressMatch;
      }).toList();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        ApiService.getFarmsList(villageId: _selectedVillageId, search: _searchQuery),
        ApiService.getVillages(),
      ]);
      if (mounted) {
        setState(() {
          _allFarms = results[0] as List<FarmSummary>;
          _villages = results[1] as List<Map<String, dynamic>>;
          _isLoading = false;
          _error = null;
          _applyFilters();
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

  Future<void> _refreshFarms() async {
    try {
      final farms = await ApiService.getFarmsList(
        villageId: _selectedVillageId,
        search: _searchQuery,
      );
      if (mounted) {
        setState(() {
          _allFarms = farms;
          _error = null;
          _applyFilters();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  void _showAddFarmDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final ownerNameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    int? dialogVillageId = _villages.isNotEmpty ? _villages.first['id'] as int : null;
    int? dialogOwnerId;
    List<Map<String, dynamic>> owners = [];

    try {
      owners = await ApiService.getOwners();
    } catch (_) {}

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.add_business_rounded, color: AppTheme.primaryTeal),
              const SizedBox(width: 10),
              Text(
                LocaleService.code == 'mr' ? 'नवीन फार्म / गोठा नोंदणी' : (LocaleService.code == 'hi' ? 'नया फार्म पंजीकरण' : 'Register New Farm'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'फार्म / गोठ्याचे नाव *' : (LocaleService.code == 'hi' ? 'फार्म / डेयरी का नाम *' : 'Farm Name *'),
                      hintText: LocaleService.code == 'mr' ? 'उदा. आनंद डेअरी फार्म' : (LocaleService.code == 'hi' ? 'उदा. आनंद डेयरी फार्म' : 'e.g., Green Meadows Dairy'),
                      prefixIcon: const Icon(Icons.business_rounded, color: AppTheme.primaryTeal),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? (LocaleService.code == 'mr' ? 'कृपया फार्मचे नाव टाका' : (LocaleService.code == 'hi' ? 'कृपया फार्म का नाम दर्ज करें' : 'Please enter a farm name'))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: dialogVillageId,
                    decoration: InputDecoration(
                      labelText: '${LocaleService.t('village')} *',
                      prefixIcon: const Icon(Icons.location_city_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: _villages.map((v) {
                      return DropdownMenuItem<int>(
                        value: v['id'] as int,
                        child: Text(v['name']?.toString() ?? ''),
                      );
                    }).toList(),
                    onChanged: (val) => setDialogState(() => dialogVillageId = val),
                    validator: (v) => v == null
                        ? (LocaleService.code == 'mr' ? 'कृपया गाव निवडा' : (LocaleService.code == 'hi' ? 'कृपया गांव चुनें' : 'Please select a village'))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: ownerNameCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'शेतकरी / मालकाचे नाव *' : (LocaleService.code == 'hi' ? 'किसान / मालिक का नाम *' : 'Farmer / Owner Name *'),
                      hintText: LocaleService.code == 'mr' ? 'उदा. रमेश पाटील, सुनीता देशमुख' : (LocaleService.code == 'hi' ? 'उदा. रमेश पाटिल, सुनीता देशमुख' : 'e.g., Ramesh Patil, Sunita Deshmukh'),
                      prefixIcon: const Icon(Icons.person_rounded, color: AppTheme.primaryTeal),
                    ),
                    onChanged: (_) {
                      setDialogState(() => dialogOwnerId = null);
                    },
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? (LocaleService.code == 'mr' ? 'कृपया मालकाचे नाव टाका' : (LocaleService.code == 'hi' ? 'कृपया मालिक का नाम दर्ज करें' : 'Please enter the farmer/owner name'))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'मोबाईल नंबर' : (LocaleService.code == 'hi' ? 'मोबाइल नंबर' : 'Farmer Contact Number'),
                      hintText: 'e.g., +91 98220 12345',
                      prefixIcon: const Icon(Icons.phone_rounded, color: AppTheme.primaryTeal),
                    ),
                  ),
                  if (owners.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: dialogOwnerId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: LocaleService.code == 'mr' ? 'किंवा नोंदणीकृत शेतकऱ्यांमधून निवडा' : (LocaleService.code == 'hi' ? 'या पंजीकृत किसानों में से चुनें' : 'Or Autofill From Registered Farmers'),
                        prefixIcon: const Icon(Icons.person_search_rounded, color: AppTheme.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      items: owners.map((o) {
                        return DropdownMenuItem<int>(
                          value: o['id'] as int,
                          child: Text(
                            '${o['name']} (${o['phone'] ?? (LocaleService.code == 'mr' ? 'फोन नाही' : 'No phone')})',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          final selected = owners.firstWhere((o) => o['id'] == val);
                          setDialogState(() {
                            dialogOwnerId = val;
                            ownerNameCtrl.text = selected['name']?.toString() ?? '';
                            phoneCtrl.text = selected['phone']?.toString() ?? '';
                          });
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'पत्ता / खूण' : (LocaleService.code == 'hi' ? 'पता / लैंडमार्क' : 'Address / Landmark'),
                      hintText: LocaleService.code == 'mr' ? 'उदा. गट क्र. ४२, मुख्य रस्ता' : (LocaleService.code == 'hi' ? 'उदा. प्लॉट 42, मुख्य मार्ग' : 'e.g., Plot 42, North Canal Road'),
                      prefixIcon: const Icon(Icons.place_outlined, color: AppTheme.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: LocaleService.code == 'mr' ? 'नोंदी / सुविधा' : (LocaleService.code == 'hi' ? 'नोट्स / सुविधाएं' : 'Notes / Facilities'),
                      hintText: LocaleService.code == 'mr' ? 'उदा. २० जनावरांचा गोठा, सायलेज शेड' : (LocaleService.code == 'hi' ? 'उदा. 20 पशु डेयरी, साइलेज शेड' : 'e.g., 20 head milking parlor, silage pit'),
                      prefixIcon: const Icon(Icons.notes_rounded, color: AppTheme.primaryTeal),
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
                    final farmName = nameCtrl.text.trim();
                    final ownerName = ownerNameCtrl.text.trim();
                    final phone = phoneCtrl.text.trim();
                    await ApiService.createFarm({
                      'farmName': farmName,
                      'name': farmName,
                      'villageId': dialogVillageId,
                      'ownerName': ownerName,
                      'contactNumber': phone.isNotEmpty ? phone : null,
                      'ownerId': dialogOwnerId,
                      'address': addressCtrl.text.trim().isNotEmpty ? addressCtrl.text.trim() : null,
                      'notes': notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                    });
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleService.code == 'mr' ? 'फार्म "$farmName" यशस्वीरीत्या नोंदवले!' : (LocaleService.code == 'hi' ? 'फार्म "$farmName" सफलतापूर्वक पंजीकृत!' : 'Farm "$farmName" registered for $ownerName!')),
                          backgroundColor: AppTheme.successGreen,
                        ),
                      );
                    }
                    _refreshFarms();
                    AppDataSync.notifyDataChanged();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: AppTheme.alertRed,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(LocaleService.code == 'mr' ? 'फार्म जतन करा' : (LocaleService.code == 'hi' ? 'फार्म सहेजें' : 'Save Farm')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleService.code == 'mr' ? 'गोठे व फार्म व्यवस्थापन' : (LocaleService.code == 'hi' ? 'फार्म प्रबंधन' : 'Farm Management'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: LocaleService.code == 'mr' ? 'रिफ्रेश करा' : (LocaleService.code == 'hi' ? 'ताज़ा करें' : 'Refresh'),
            onPressed: _refreshFarms,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_rounded),
        label: Text(
          LocaleService.code == 'mr' ? 'नवीन फार्म' : (LocaleService.code == 'hi' ? 'नया फार्म' : 'Add Farm'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _showAddFarmDialog,
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: LocaleService.code == 'mr' ? 'फार्मचे नाव, कोड किंवा मालक शोधा...' : (LocaleService.code == 'hi' ? 'फार्म का नाम, कोड या मालिक खोजें...' : 'Search by farm name, code, or owner...'),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryTeal),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              _searchQuery = '';
                              _applyFilters();
                            },
                          )
                        : null,
                    isDense: true,
                  ),
                  onChanged: (val) {
                    _searchQuery = val;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 10),
                // Village filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text(LocaleService.t('all_villages')),
                        selected: _selectedVillageId == null,
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primaryTeal,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedVillageId = null;
                              _applyFilters();
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ..._villages.map((v) {
                        final vId = v['id'] as int;
                        final isSel = _selectedVillageId == vId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(v['name']?.toString() ?? ''),
                            selected: isSel,
                            selectedColor: AppTheme.primaryLight,
                            checkmarkColor: AppTheme.primaryTeal,
                            onSelected: (selected) {
                              setState(() {
                                _selectedVillageId = selected ? vId : null;
                                _applyFilters();
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderSubtle),

          // Content body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppTheme.alertRed, size: 48),
                              const SizedBox(height: 12),
                              Text('Failed to load farms:\n$_error', textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              ElevatedButton(onPressed: _loadInitialData, child: Text(LocaleService.code == 'mr' ? 'पुन्हा प्रयत्न करा' : (LocaleService.code == 'hi' ? 'पुनः प्रयास करें' : 'Retry'))),
                            ],
                          ),
                        ),
                      )
                    : _filteredFarms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.agriculture_rounded, size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? (LocaleService.code == 'mr' ? 'कोणतेही फार्म "$_searchQuery" शी जुळत नाही' : (LocaleService.code == 'hi' ? 'कोई फार्म "$_searchQuery" से मेल नहीं खाता' : 'No farms match "$_searchQuery"'))
                                      : (LocaleService.code == 'mr' ? 'कोणतेही फार्म नोंदवलेले नाही' : (LocaleService.code == 'hi' ? 'कोई फार्म पंजीकृत नहीं है' : 'No farms registered yet')),
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: Text(LocaleService.code == 'mr' ? 'नवीन फार्म जोडा' : (LocaleService.code == 'hi' ? 'नया फार्म जोड़ें' : 'Register New Farm')),
                                  onPressed: _showAddFarmDialog,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshFarms,
                            color: AppTheme.primaryTeal,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 80),
                              itemCount: _filteredFarms.length,
                              itemBuilder: (ctx, idx) {
                                final farm = _filteredFarms[idx];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: const BorderSide(color: AppTheme.borderSubtle),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FarmProfileScreen(farmId: farm.id),
                                        ),
                                      ).then((_) => _refreshFarms());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  farm.name,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.primaryLight,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.pets_rounded, size: 14, color: AppTheme.primaryTeal),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${farm.totalAnimals} ${LocaleService.code == 'mr' ? 'जनावरे' : (LocaleService.code == 'hi' ? 'पशु' : 'head')}',
                                                      style: const TextStyle(
                                                        color: AppTheme.primaryTeal,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: Colors.grey.shade300),
                                                ),
                                                child: Text(
                                                  farm.farmCode,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: 'monospace',
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textSecondary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.location_city_rounded, size: 14, color: AppTheme.textMuted),
                                              const SizedBox(width: 4),
                                              Text(
                                                farm.villageName,
                                                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.person_outline_rounded, size: 15, color: AppTheme.textMuted),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  '${LocaleService.code == 'mr' ? 'मालक' : (LocaleService.code == 'hi' ? 'मालिक' : 'Owner')}: ${farm.ownerName ?? (LocaleService.code == 'mr' ? 'नेमलेले नाही' : (LocaleService.code == 'hi' ? 'अनिर्धारित' : 'Not Assigned'))}${farm.ownerPhone != null && farm.ownerPhone!.isNotEmpty ? ' (${farm.ownerPhone})' : ''}',
                                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (farm.address != null && farm.address!.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.place_outlined, size: 15, color: AppTheme.textMuted),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    farm.address!,
                                                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
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
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
