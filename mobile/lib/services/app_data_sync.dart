import 'package:flutter/foundation.dart';

/// Centralized app-wide data synchronization notifier.
/// Fires whenever animals, farms, visits, or payments are created or updated,
/// triggering active screens to immediately fetch fresh data.
class AppDataSync {
  static final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  /// Notify all listening screens to refresh their state
  static void notifyDataChanged() {
    changeNotifier.value++;
  }
}
