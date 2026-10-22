class AnimalSummary {
  final int id;
  final String animalCode;
  final String name;
  final String species;
  final String? breed;
  final double? ageYears;
  final String sex;
  final int? farmId;
  final String? farmName;
  final int? villageId;
  final String? villageName;
  final String? lastVisitDate;
  final String? lastVisitComplaint;
  final int totalVisits;

  AnimalSummary({
    required this.id,
    required this.animalCode,
    required this.name,
    required this.species,
    this.breed,
    this.ageYears,
    required this.sex,
    this.farmId,
    this.farmName,
    this.villageId,
    this.villageName,
    this.lastVisitDate,
    this.lastVisitComplaint,
    required this.totalVisits,
  });

  factory AnimalSummary.fromJson(Map<String, dynamic> json) {
    return AnimalSummary(
      id: json['id'] as int? ?? 0,
      animalCode: json['animalCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      species: json['species'] as String? ?? 'Cattle',
      breed: json['breed'] as String?,
      ageYears: json['ageYears'] != null ? (json['ageYears'] as num).toDouble() : null,
      sex: json['sex'] as String? ?? 'FEMALE',
      farmId: json['farmId'] as int?,
      farmName: json['farmName'] as String?,
      villageId: json['villageId'] as int?,
      villageName: json['villageName'] as String?,
      lastVisitDate: json['lastVisitDate'] as String?,
      lastVisitComplaint: json['lastVisitComplaint'] as String?,
      totalVisits: json['totalVisits'] as int? ?? 0,
    );
  }
}

class AnimalDetail {
  final int id;
  final String animalCode;
  final String name;
  final String species;
  final String? breed;
  final double? ageYears;
  final String sex;
  final int? farmId;
  final String? farmCode;
  final String? farmName;
  final String? ownerName;
  final String? contactNumber;
  final int? villageId;
  final String? villageName;
  final String? tagRfid;
  final String? notes;
  final List<dynamic> visits;

  AnimalDetail({
    required this.id,
    required this.animalCode,
    required this.name,
    required this.species,
    this.breed,
    this.ageYears,
    required this.sex,
    this.farmId,
    this.farmCode,
    this.farmName,
    this.ownerName,
    this.contactNumber,
    this.villageId,
    this.villageName,
    this.tagRfid,
    this.notes,
    required this.visits,
  });

  factory AnimalDetail.fromJson(Map<String, dynamic> json) {
    return AnimalDetail(
      id: json['id'] as int? ?? 0,
      animalCode: json['animalCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      species: json['species'] as String? ?? 'Cattle',
      breed: json['breed'] as String?,
      ageYears: json['ageYears'] != null ? (json['ageYears'] as num).toDouble() : null,
      sex: json['sex'] as String? ?? 'FEMALE',
      farmId: json['farmId'] as int?,
      farmCode: json['farmCode'] as String?,
      farmName: json['farmName'] as String?,
      ownerName: json['ownerName'] as String?,
      contactNumber: json['contactNumber'] as String?,
      villageId: json['villageId'] as int?,
      villageName: json['villageName'] as String?,
      tagRfid: json['tagRfid'] as String?,
      notes: json['notes'] as String?,
      visits: json['visits'] as List<dynamic>? ?? [],
    );
  }
}

class CreateAnimalRequest {
  final String name;
  final String species;
  final String? breed;
  final double? ageYears;
  final String sex;
  final int farmId;
  final String? tagRfid;
  final String? notes;

  CreateAnimalRequest({
    required this.name,
    required this.species,
    this.breed,
    this.ageYears,
    required this.sex,
    required this.farmId,
    this.tagRfid,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'breed': breed,
      'ageYears': ageYears,
      'sex': sex,
      'farmId': farmId,
      'tagRfid': tagRfid,
      'notes': notes,
    };
  }
}

