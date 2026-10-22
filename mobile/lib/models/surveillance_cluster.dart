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
