import 'visit.dart';

class DashboardStats {
  final int totalAnimals;
  final int totalFarms;
  final int totalVillages;
  final int totalVisits;
  final int activeSurveillanceAlerts;
  final List<VisitModel> recentVisits;
  final List<VillageStat> villageStats;
  final List<FarmStat> farmStats;
  final Map<String, int> topSymptoms;
  final String syntheticDataNotice;

  DashboardStats({
    required this.totalAnimals,
    required this.totalFarms,
    required this.totalVillages,
    required this.totalVisits,
    required this.activeSurveillanceAlerts,
    required this.recentVisits,
    required this.villageStats,
    this.farmStats = const [],
    required this.topSymptoms,
    required this.syntheticDataNotice,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    List<VisitModel> visits = [];
    if (json['recentVisits'] != null) {
      visits = (json['recentVisits'] as List)
          .map((v) => VisitModel.fromJson(v as Map<String, dynamic>))
          .toList();
    }

    List<VillageStat> vStats = [];
    if (json['villageStats'] != null) {
      vStats = (json['villageStats'] as List)
          .map((vs) => VillageStat.fromJson(vs as Map<String, dynamic>))
          .toList();
    }

    List<FarmStat> fStats = [];
    if (json['farmStats'] != null) {
      fStats = (json['farmStats'] as List)
          .map((fs) => FarmStat.fromJson(fs as Map<String, dynamic>))
          .toList();
    }

    Map<String, int> syms = {};
    if (json['topSymptoms'] != null) {
      (json['topSymptoms'] as Map<String, dynamic>).forEach((k, v) {
        syms[k] = (v as num).toInt();
      });
    }

    return DashboardStats(
      totalAnimals: json['totalAnimals'] as int? ?? 0,
      totalFarms: json['totalFarms'] as int? ?? 0,
      totalVillages: json['totalVillages'] as int? ?? 0,
      totalVisits: json['totalVisits'] as int? ?? 0,
      activeSurveillanceAlerts: json['activeSurveillanceAlerts'] as int? ?? 0,
      recentVisits: visits,
      villageStats: vStats,
      farmStats: fStats,
      topSymptoms: syms,
      syntheticDataNotice: json['syntheticDataNotice'] as String? ?? 'All data is synthetic.',
    );
  }
}

class VillageStat {
  final int villageId;
  final String villageName;
  final int farmCount;
  final int animalCount;
  final int recentVisitCount;
  final bool hasAlert;

  VillageStat({
    required this.villageId,
    required this.villageName,
    required this.farmCount,
    required this.animalCount,
    required this.recentVisitCount,
    required this.hasAlert,
  });

  factory VillageStat.fromJson(Map<String, dynamic> json) {
    return VillageStat(
      villageId: json['villageId'] as int? ?? 0,
      villageName: json['villageName'] as String? ?? '',
      farmCount: json['farmCount'] as int? ?? 0,
      animalCount: json['animalCount'] as int? ?? 0,
      recentVisitCount: json['recentVisitCount'] as int? ?? 0,
      hasAlert: json['hasAlert'] as bool? ?? false,
    );
  }
}

class FarmStat {
  final int farmId;
  final String farmCode;
  final String farmName;
  final String villageName;
  final String ownerName;
  final int animalCount;
  final int visitCount;

  FarmStat({
    required this.farmId,
    required this.farmCode,
    required this.farmName,
    required this.villageName,
    required this.ownerName,
    required this.animalCount,
    required this.visitCount,
  });

  factory FarmStat.fromJson(Map<String, dynamic> json) {
    return FarmStat(
      farmId: json['farmId'] as int? ?? 0,
      farmCode: json['farmCode'] as String? ?? '',
      farmName: json['farmName'] as String? ?? '',
      villageName: json['villageName'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      animalCount: json['animalCount'] as int? ?? 0,
      visitCount: json['visitCount'] as int? ?? 0,
    );
  }
}
