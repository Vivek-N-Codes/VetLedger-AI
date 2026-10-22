import 'package:flutter/material.dart';
import 'screens/animal_list_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/farms_screen.dart';
import 'screens/ledger_screen.dart';
import 'screens/surveillance_dashboard_screen.dart';
import 'screens/visit_entry_screen.dart';
import 'services/api_service.dart';
import 'services/app_data_sync.dart';
import 'services/locale_service.dart';
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

  @override
  void initState() {
    super.initState();
    LocaleService.currentLocale.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    LocaleService.currentLocale.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Trigger real-time dynamic refresh across all screens
    AppDataSync.notifyDataChanged();
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

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleService.t('app_title'), style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          // Multilingual Selector (EN / HI / MR)
          PopupMenuButton<String>(
            tooltip: LocaleService.t('change_language'),
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryTeal.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate_rounded, size: 16, color: AppTheme.primaryTeal),
                  const SizedBox(width: 5),
                  Text(
                    LocaleService.languageName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                  ),
                ],
              ),
            ),
            onSelected: (code) {
              LocaleService.setLocale(code);
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Text('🇬🇧', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10),
                    Text('English', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'hi',
                child: Row(
                  children: [
                    Text('🇮🇳', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10),
                    Text('हिन्दी (Hindi)', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'mr',
                child: Row(
                  children: [
                    Text('🚩', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10),
                    Text('मराठी (Marathi)', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded, color: AppTheme.primaryTeal),
            tooltip: LocaleService.t('quick_visit'),
            onPressed: _openQuickVisit,
          ),
          IconButton(
            icon: const Icon(Icons.settings_ethernet_rounded, color: AppTheme.textSecondary),
            tooltip: LocaleService.t('backend_settings'),
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: LocaleService.t('dashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.pets_outlined),
            selectedIcon: const Icon(Icons.pets_rounded),
            label: LocaleService.t('animals'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.agriculture_outlined),
            selectedIcon: const Icon(Icons.agriculture_rounded),
            label: LocaleService.t('farms'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics_rounded),
            label: LocaleService.t('surveillance'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: LocaleService.t('ledger'),
          ),
        ],
      ),
    ),
  );
}
}
