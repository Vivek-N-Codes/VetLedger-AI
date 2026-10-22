class ClinicalFollowUpModel {
  final int id;
  final int visitId;
  final int animalId;
  final String animalName;
  final String animalCode;
  final String farmName;
  final String ownerName;
  final String? ownerPhone;
  final String scheduledDate;
  final String? completedDate;
  final String status;
  final String? notes;
  final String? recordedBy;

  ClinicalFollowUpModel({
    required this.id,
    required this.visitId,
    required this.animalId,
    required this.animalName,
    required this.animalCode,
    required this.farmName,
    required this.ownerName,
    this.ownerPhone,
    required this.scheduledDate,
    this.completedDate,
    required this.status,
    this.notes,
    this.recordedBy,
  });

  factory ClinicalFollowUpModel.fromJson(Map<String, dynamic> json) {
    return ClinicalFollowUpModel(
      id: json['id'] as int? ?? 0,
      visitId: json['visitId'] as int? ?? 0,
      animalId: json['animalId'] as int? ?? 0,
      animalName: json['animalName'] as String? ?? '',
      animalCode: json['animalCode'] as String? ?? '',
      farmName: json['farmName'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      ownerPhone: json['ownerPhone'] as String?,
      scheduledDate: json['scheduledDate'] as String? ?? '',
      completedDate: json['completedDate'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      notes: json['notes'] as String?,
      recordedBy: json['recordedBy'] as String?,
    );
  }
}
