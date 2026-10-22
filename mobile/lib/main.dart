import 'package:flutter/material.dart';
import 'screens/animal_list_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/farms_screen.dart';
import 'screens/ledger_screen.dart';
import 'screens/surveillance_dashboard_screen.dart';
import 'screens/visit_entry_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VetLedgerApp());
}

class VetLedgerApp extends StatelessWidget {
  const VetLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetLedger AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openQuickVisit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VisitEntryScreen(),
      ),
    );
  }

  void _showConnectionConfig() {
    final controller = TextEditingController(text: ApiService.baseUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.settings_ethernet_rounded, color: AppTheme.primaryTeal),
            SizedBox(width: 8),
            Text('Backend Connection'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configure the Spring Boot REST API base URL. Use localhost for desktop/web, 10.0.2.2 for Android emulator, or your LAN IP for physical mobile devices.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Base URL',
                hintText: 'http://localhost:8080/api',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                ApiService.setCustomBaseUrl(newUrl);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('API URL updated: ${ApiService.baseUrl}')),
                );
              }
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Save & Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onNavigateTab: _onTabSelected),
      const AnimalListScreen(),
      const FarmsScreen(),
      const SurveillanceDashboardScreen(),
      const LedgerScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('VetLedger AI', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded, color: AppTheme.primaryTeal),
            tooltip: 'Quick Clinical Visit',
            onPressed: _openQuickVisit,
          ),
          IconButton(
            icon: const Icon(Icons.settings_ethernet_rounded, color: AppTheme.textSecondary),
            tooltip: 'Backend API Settings',
            onPressed: _showConnectionConfig,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets_rounded),
            label: 'Animals',
          ),
          NavigationDestination(
            icon: Icon(Icons.agriculture_outlined),
            selectedIcon: Icon(Icons.agriculture_rounded),
            label: 'Farms',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Surveillance',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Ledger',
          ),
        ],
      ),
    );
  }
}
