import 'animal.dart';
import 'visit.dart';

class FarmSummary {
  final int id;
  final String farmCode;
  final String name;
  final int? ownerId;
  final String? ownerName;
  final String? ownerPhone;
  final int villageId;
  final String villageName;
  final int totalAnimals;
  final String? address;
  final String? notes;

  FarmSummary({
    required this.id,
    required this.farmCode,
    required this.name,
    this.ownerId,
    this.ownerName,
    this.ownerPhone,
    required this.villageId,
    required this.villageName,
    required this.totalAnimals,
    this.address,
    this.notes,
  });

  factory FarmSummary.fromJson(Map<String, dynamic> json) {
    return FarmSummary(
      id: json['id'] as int? ?? 0,
      farmCode: json['farmCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ownerId: json['ownerId'] as int?,
      ownerName: json['ownerName'] as String?,
      ownerPhone: json['ownerPhone'] as String?,
      villageId: json['villageId'] as int? ?? 0,
      villageName: json['villageName'] as String? ?? '',
      totalAnimals: json['totalAnimals'] as int? ?? 0,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

class FarmDetail {
  final int id;
  final String farmCode;
  final String name;
  final int? ownerId;
  final String? ownerName;
  final String? ownerPhone;
  final int villageId;
  final String villageName;
  final String? address;
  final String? notes;
  final int totalAnimals;
  final List<AnimalSummary> animals;
  final List<VisitModel> recentVisits;

  FarmDetail({
    required this.id,
    required this.farmCode,
    required this.name,
    this.ownerId,
    this.ownerName,
    this.ownerPhone,
    required this.villageId,
    required this.villageName,
    this.address,
    this.notes,
    required this.totalAnimals,
    required this.animals,
    required this.recentVisits,
  });

  factory FarmDetail.fromJson(Map<String, dynamic> json) {
    List<AnimalSummary> anims = [];
    if (json['animals'] != null) {
      anims = (json['animals'] as List)
          .map((a) => AnimalSummary.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    List<VisitModel> visits = [];
    if (json['recentVisits'] != null) {
      visits = (json['recentVisits'] as List)
          .map((v) => VisitModel.fromJson(v as Map<String, dynamic>))
          .toList();
    }

    return FarmDetail(
      id: json['id'] as int? ?? 0,
      farmCode: json['farmCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ownerId: json['ownerId'] as int?,
      ownerName: json['ownerName'] as String?,
      ownerPhone: json['ownerPhone'] as String?,
      villageId: json['villageId'] as int? ?? 0,
      villageName: json['villageName'] as String? ?? '',
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      totalAnimals: json['totalAnimals'] as int? ?? 0,
      animals: anims,
      recentVisits: visits,
    );
  }
}
