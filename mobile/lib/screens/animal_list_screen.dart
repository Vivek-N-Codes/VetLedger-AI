import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'animal_profile_screen.dart';

class AnimalListScreen extends StatefulWidget {
  final String? initialVillage;

  const AnimalListScreen({super.key, this.initialVillage});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AnimalSummary> _allAnimals = [];
  List<AnimalSummary> _filteredAnimals = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedVillage = 'All';
  String _selectedSpecies = 'All';

  final List<String> _villages = ['All', 'Sangamner', 'Rahata', 'Akole', 'Kopargaon', 'Shrirampur'];
  final List<String> _species = ['All', 'Cattle', 'Buffalo', 'Goat'];

  @override
  void initState() {
    super.initState();
    if (widget.initialVillage != null && _villages.contains(widget.initialVillage)) {
      _selectedVillage = widget.initialVillage!;
    }
    _loadAnimals();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAnimals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final animals = await ApiService.getAnimals();
      setState(() {
        _allAnimals = animals;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredAnimals = _allAnimals.filter((a) {
        // Query match
        final matchesQuery = query.isEmpty ||
            a.animalCode.toLowerCase().contains(query) ||
            a.name.toLowerCase().contains(query) ||
            (a.breed != null && a.breed!.toLowerCase().contains(query)) ||
            (a.farmName != null && a.farmName!.toLowerCase().contains(query));

        // Village match
        final matchesVillage = _selectedVillage == 'All' ||
            (a.villageName != null && a.villageName!.toLowerCase() == _selectedVillage.toLowerCase());

        // Species match
        final matchesSpecies = _selectedSpecies == 'All' ||
            a.species.toLowerCase() == _selectedSpecies.toLowerCase();

        return matchesQuery && matchesVillage && matchesSpecies;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Health Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Animals',
            onPressed: _loadAnimals,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by animal code, name, breed, or farm...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Village Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _villages.map((village) {
                final isSelected = _selectedVillage == village;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(village),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppTheme.primaryLight,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryTeal : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppTheme.primaryTeal : AppTheme.borderSubtle),
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedVillage = village;
                      });
                      _applyFilters();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 4),

          // Species Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _species.map((spec) {
                final isSelected = _selectedSpecies == spec;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(spec),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppTheme.primaryTeal,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textMuted,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 11,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedSpecies = spec;
                      });
                      _applyFilters();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Header count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${_filteredAnimals.length} of ${_allAnimals.length} animals',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Animal List View
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal));
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 40, color: AppTheme.alertRed),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: _loadAnimals,
              ),
            ],
          ),
        ),
      );
    }
    if (_filteredAnimals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: AppTheme.textMuted),
            SizedBox(height: 12),
            Text('No animals match the filter criteria.', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnimals,
      color: AppTheme.primaryTeal,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _filteredAnimals.length,
        itemBuilder: (context, index) {
          final animal = _filteredAnimals[index];
          return _buildAnimalCard(animal);
        },
      ),
    );
  }

  Widget _buildAnimalCard(AnimalSummary animal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimalProfileScreen(animalId: animal.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        animal.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${animal.totalVisits} visits',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _infoChip(Icons.category_outlined, '${animal.species} • ${animal.breed ?? 'Native'}'),
                  const SizedBox(width: 10),
                  _infoChip(Icons.cake_outlined, '${animal.ageYears ?? 0} yrs'),
                  const SizedBox(width: 10),
                  _infoChip(Icons.male, animal.sex),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: AppTheme.borderSubtle),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.agriculture_rounded, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${animal.farmName ?? ''} (${animal.villageName ?? ''})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (animal.lastVisitDate != null)
                    Text(
                      'Last: ${animal.lastVisitDate}',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppTheme.textMuted),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}

extension ListFilterExtension<T> on List<T> {
  List<T> filter(bool Function(T element) test) {
    final result = <T>[];
    for (final element in this) {
      if (test(element)) result.add(element);
    }
    return result;
  }
}
