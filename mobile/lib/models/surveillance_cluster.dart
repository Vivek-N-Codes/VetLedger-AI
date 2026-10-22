import 'animal.dart';

class SurveillanceCluster {
  final String clusterId;
  final int villageId;
  final String villageName;
  final int observationWindowDays;
  final String windowStartDate;
  final String windowEndDate;
  final int distinctAnimalCount;
  final int affectedFarmCount;
  final List<String> sharedSymptoms;
  final double baselineAnimalCount;
  final double elevationFactor;
  final String riskLevel;
  final String riskTitle;
  final String rationale;
  final String veterinaryNotice;

  SurveillanceCluster({
    required this.clusterId,
    required this.villageId,
    required this.villageName,
    required this.observationWindowDays,
    required this.windowStartDate,
    required this.windowEndDate,
    required this.distinctAnimalCount,
    required this.affectedFarmCount,
    required this.sharedSymptoms,
    required this.baselineAnimalCount,
    required this.elevationFactor,
    required this.riskLevel,
    required this.riskTitle,
    required this.rationale,
    required this.veterinaryNotice,
  });

  factory SurveillanceCluster.fromJson(Map<String, dynamic> json) {
    List<String> syms = [];
    if (json['sharedSymptoms'] != null) {
      syms = (json['sharedSymptoms'] as List).map((e) => e.toString()).toList();
    }
    return SurveillanceCluster(
      clusterId: json['clusterId'] as String? ?? '',
      villageId: json['villageId'] as int? ?? 0,
      villageName: json['villageName'] as String? ?? '',
      observationWindowDays: json['observationWindowDays'] as int? ?? 14,
      windowStartDate: json['windowStartDate'] as String? ?? '',
      windowEndDate: json['windowEndDate'] as String? ?? '',
      distinctAnimalCount: json['distinctAnimalCount'] as int? ?? 0,
      affectedFarmCount: json['affectedFarmCount'] as int? ?? 0,
      sharedSymptoms: syms,
      baselineAnimalCount: (json['baselineAnimalCount'] as num?)?.toDouble() ?? 1.0,
      elevationFactor: (json['elevationFactor'] as num?)?.toDouble() ?? 1.0,
      riskLevel: json['riskLevel'] as String? ?? 'WATCH',
      riskTitle: json['riskTitle'] as String? ?? 'Surveillance Notice',
      rationale: json['rationale'] as String? ?? '',
      veterinaryNotice: json['veterinaryNotice'] as String? ?? 'Preliminary statistical signal.',
    );
  }
}

class ClusterDetailModel {
  final String clusterId;
  final int villageId;
  final String villageName;
  final int observationWindowDays;
  final String windowStartDate;
  final String windowEndDate;
  final int distinctAnimalCount;
  final int affectedFarmCount;
  final List<String> sharedSymptoms;
  final double baselineAnimalCount;
  final double elevationFactor;
  final String riskLevel;
  final String riskTitle;
  final String rationale;
  final String veterinaryNotice;
  final List<AnimalSummary> affectedAnimals;
  final List<AffectedFarmModel> affectedFarms;
  final Map<String, int> symptomCounts;
  final List<int> supportingVisitIds;
  final List<String> recommendedFieldActions;

  ClusterDetailModel({
    required this.clusterId,
    required this.villageId,
    required this.villageName,
    required this.observationWindowDays,
    required this.windowStartDate,
    required this.windowEndDate,
    required this.distinctAnimalCount,
    required this.affectedFarmCount,
    required this.sharedSymptoms,
    required this.baselineAnimalCount,
    required this.elevationFactor,
    required this.riskLevel,
    required this.riskTitle,
    required this.rationale,
    required this.veterinaryNotice,
    required this.affectedAnimals,
    required this.affectedFarms,
    required this.symptomCounts,
    required this.supportingVisitIds,
    required this.recommendedFieldActions,
  });

  factory ClusterDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> syms = [];
    if (json['sharedSymptoms'] != null) {
      syms = (json['sharedSymptoms'] as List).map((e) => e.toString()).toList();
    }

    List<AnimalSummary> animals = [];
    if (json['affectedAnimals'] != null) {
      animals = (json['affectedAnimals'] as List)
          .map((a) => AnimalSummary.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    List<AffectedFarmModel> farms = [];
    if (json['affectedFarms'] != null) {
      farms = (json['affectedFarms'] as List)
          .map((f) => AffectedFarmModel.fromJson(f as Map<String, dynamic>))
          .toList();
    }

    Map<String, int> symCounts = {};
    if (json['symptomCounts'] != null) {
      (json['symptomCounts'] as Map<String, dynamic>).forEach((k, v) {
        symCounts[k] = (v as num).toInt();
      });
    }

    List<int> visitIds = [];
    if (json['supportingVisitIds'] != null) {
      visitIds = (json['supportingVisitIds'] as List).map((e) => (e as num).toInt()).toList();
    }

    List<String> actions = [];
    if (json['recommendedFieldActions'] != null) {
      actions = (json['recommendedFieldActions'] as List).map((e) => e.toString()).toList();
    }

    return ClusterDetailModel(
      clusterId: json['clusterId'] as String? ?? '',
      villageId: json['villageId'] as int? ?? 0,
      villageName: json['villageName'] as String? ?? '',
      observationWindowDays: json['observationWindowDays'] as int? ?? 14,
      windowStartDate: json['windowStartDate'] as String? ?? '',
      windowEndDate: json['windowEndDate'] as String? ?? '',
      distinctAnimalCount: json['distinctAnimalCount'] as int? ?? 0,
      affectedFarmCount: json['affectedFarmCount'] as int? ?? 0,
      sharedSymptoms: syms,
      baselineAnimalCount: (json['baselineAnimalCount'] as num?)?.toDouble() ?? 1.0,
      elevationFactor: (json['elevationFactor'] as num?)?.toDouble() ?? 1.0,
      riskLevel: json['riskLevel'] as String? ?? 'WATCH',
      riskTitle: json['riskTitle'] as String? ?? 'Surveillance Notice',
      rationale: json['rationale'] as String? ?? '',
      veterinaryNotice: json['veterinaryNotice'] as String? ?? '',
      affectedAnimals: animals,
      affectedFarms: farms,
      symptomCounts: symCounts,
      supportingVisitIds: visitIds,
      recommendedFieldActions: actions,
    );
  }
}

class AffectedFarmModel {
  final int farmId;
  final String farmCode;
  final String farmName;
  final String ownerName;
  final String? contactNumber;
  final int affectedAnimalCount;

  AffectedFarmModel({
    required this.farmId,
    required this.farmCode,
    required this.farmName,
    required this.ownerName,
    this.contactNumber,
    required this.affectedAnimalCount,
  });

  factory AffectedFarmModel.fromJson(Map<String, dynamic> json) {
    return AffectedFarmModel(
      farmId: json['farmId'] as int? ?? 0,
      farmCode: json['farmCode'] as String? ?? '',
      farmName: json['farmName'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      contactNumber: json['contactNumber'] as String?,
      affectedAnimalCount: json['affectedAnimalCount'] as int? ?? 0,
    );
  }
}

class PopulationOverview {
  final int windowDays;
  final int activeAnimalsWithVisits;
  final int clusterAffectedAnimals;
  final int activeFarms;
  final int clusterAffectedFarms;
  final int totalVisitsInWindow;
  final int clusterSyndromeVisits;
  final double syndromeElevationRatio;
  final String clarificationNote;

  PopulationOverview({
    required this.windowDays,
    required this.activeAnimalsWithVisits,
    required this.clusterAffectedAnimals,
    required this.activeFarms,
    required this.clusterAffectedFarms,
    required this.totalVisitsInWindow,
    required this.clusterSyndromeVisits,
    required this.syndromeElevationRatio,
    required this.clarificationNote,
  });

  factory PopulationOverview.fromJson(Map<String, dynamic> json) {
    int clusterAnimals = json['clusterAffectedAnimals'] as int? ?? 0;
    double elevRatio = (json['syndromeElevationRatio'] as num?)?.toDouble() ?? 1.0;
    if (json['activeClusters'] is List && (json['activeClusters'] as List).isNotEmpty) {
      final first = (json['activeClusters'] as List).first;
      if (clusterAnimals == 0 && first['distinctAnimalCount'] != null) {
        clusterAnimals = first['distinctAnimalCount'] as int;
      }
      if (elevRatio == 1.0 && first['elevationFactor'] != null) {
        elevRatio = (first['elevationFactor'] as num).toDouble();
      }
    }

    return PopulationOverview(
      windowDays: json['windowDays'] as int? ?? 14,
      activeAnimalsWithVisits: json['activeAnimalsWithVisits'] as int? ?? json['animalsWithVisitsInWindow'] as int? ?? 0,
      clusterAffectedAnimals: clusterAnimals,
      activeFarms: json['activeFarms'] as int? ?? json['farmsWithVisitsInWindow'] as int? ?? 0,
      clusterAffectedFarms: json['clusterAffectedFarms'] as int? ?? 0,
      totalVisitsInWindow: json['totalVisitsInWindow'] as int? ?? 0,
      clusterSyndromeVisits: json['clusterSyndromeVisits'] as int? ?? 0,
      syndromeElevationRatio: elevRatio,
      clarificationNote: json['clarificationNote'] as String? ?? json['verifiedDiscrepancyExplanation'] as String? ?? json['dataCoverageNote'] as String? ?? '',
    );
  }
}

