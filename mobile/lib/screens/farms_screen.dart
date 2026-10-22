import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
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
        if (_selectedVillageId != null && f.villageId != null && f.villageId != _selectedVillageId) {
          return false;
        }
        // Query match
        if (query.isEmpty) return true;
        final nameMatch = f.name.toLowerCase().contains(query);
        final codeMatch = f.farmCode.toLowerCase().contains(query);
        final ownerMatch = f.ownerName != null && f.ownerName!.toLowerCase().contains(query);
        final villageMatch = f.villageName != null && f.villageName!.toLowerCase().contains(query);
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
          title: const Row(
            children: [
              Icon(Icons.add_business_rounded, color: AppTheme.primaryTeal),
              SizedBox(width: 10),
              Text('Register New Farm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                    decoration: const InputDecoration(
                      labelText: 'Farm Name *',
                      hintText: 'e.g., Green Meadows Dairy',
                      prefixIcon: Icon(Icons.business_rounded, color: AppTheme.primaryTeal),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a farm name' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: dialogVillageId,
                    decoration: const InputDecoration(
                      labelText: 'Village *',
                      prefixIcon: Icon(Icons.location_city_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: _villages.map((v) {
                      return DropdownMenuItem<int>(
                        value: v['id'] as int,
                        child: Text(v['name']?.toString() ?? ''),
                      );
                    }).toList(),
                    onChanged: (val) => setDialogState(() => dialogVillageId = val),
                    validator: (v) => v == null ? 'Please select a village' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: ownerNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Farmer / Owner Name *',
                      hintText: 'e.g., Ramesh Patil, Sunita Deshmukh',
                      prefixIcon: Icon(Icons.person_rounded, color: AppTheme.primaryTeal),
                    ),
                    onChanged: (_) {
                      setDialogState(() => dialogOwnerId = null);
                    },
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter the farmer/owner name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Farmer Contact Number',
                      hintText: 'e.g., +91 98220 12345',
                      prefixIcon: Icon(Icons.phone_rounded, color: AppTheme.primaryTeal),
                    ),
                  ),
                  if (owners.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: dialogOwnerId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Or Autofill From Registered Farmers',
                        prefixIcon: Icon(Icons.person_search_rounded, color: AppTheme.textMuted),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      items: owners.map((o) {
                        return DropdownMenuItem<int>(
                          value: o['id'] as int,
                          child: Text(
                            '${o['name']} (${o['phone'] ?? 'No phone'})',
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
                    decoration: const InputDecoration(
                      labelText: 'Address / Landmark',
                      hintText: 'e.g., Plot 42, North Canal Road',
                      prefixIcon: Icon(Icons.place_outlined, color: AppTheme.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes / Facilities',
                      hintText: 'e.g., 20 head milking parlor, silage pit',
                      prefixIcon: Icon(Icons.notes_rounded, color: AppTheme.primaryTeal),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Farm "$farmName" registered for $ownerName!'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                    _refreshFarms();
                    AppDataSync.notifyDataChanged();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppTheme.alertRed,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save Farm'),
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
        title: const Text('Farm Management', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _refreshFarms,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_rounded),
        label: const Text('Add Farm', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    hintText: 'Search by farm name, code, or owner...',
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
                        label: const Text('All Villages'),
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
                              ElevatedButton(onPressed: _loadInitialData, child: const Text('Retry')),
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
                                  _searchQuery.isNotEmpty ? 'No farms match "$_searchQuery"' : 'No farms registered yet',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text('Register New Farm'),
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
                                                      '${farm.totalAnimals} head',
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
                                              Text(
                                                'Owner: ${farm.ownerName ?? 'Not Assigned'}',
                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                              ),
                                              if (farm.ownerPhone != null && farm.ownerPhone!.isNotEmpty) ...[
                                                const SizedBox(width: 8),
                                                Text(
                                                  '(${farm.ownerPhone})',
                                                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                                ),
                                              ],
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
