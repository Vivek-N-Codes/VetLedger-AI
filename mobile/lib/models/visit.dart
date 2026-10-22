class VisitModel {
  final int id;
  final int animalId;
  final String? animalCode;
  final String? animalName;
  final String? farmName;
  final String? villageName;
  final String visitDate;
  final String presentingComplaint;
  final String? observations;
  final String severity;
  final double? temperatureCelsius;
  final String? treatmentNotes;
  final String? followUpNotes;
  final List<String> symptoms;

  VisitModel({
    required this.id,
    required this.animalId,
    this.animalCode,
    this.animalName,
    this.farmName,
    this.villageName,
    required this.visitDate,
    required this.presentingComplaint,
    this.observations,
    required this.severity,
    this.temperatureCelsius,
    this.treatmentNotes,
    this.followUpNotes,
    required this.symptoms,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    List<String> syms = [];
    if (json['symptoms'] != null) {
      syms = (json['symptoms'] as List).map((e) => e.toString()).toList();
    }
    return VisitModel(
      id: json['id'] as int? ?? 0,
      animalId: json['animalId'] as int? ?? 0,
      animalCode: json['animalCode'] as String?,
      animalName: json['animalName'] as String?,
      farmName: json['farmName'] as String?,
      villageName: json['villageName'] as String?,
      visitDate: json['visitDate'] as String? ?? '',
      presentingComplaint: json['presentingComplaint'] as String? ?? '',
      observations: json['observations'] as String?,
      severity: json['severity'] as String? ?? 'MODERATE',
      temperatureCelsius: json['temperatureCelsius'] != null ? (json['temperatureCelsius'] as num).toDouble() : null,
      treatmentNotes: json['treatmentNotes'] as String?,
      followUpNotes: json['followUpNotes'] as String?,
      symptoms: syms,
    );
  }
}

class CreateVisitDto {
  final int animalId;
  final String visitDate;
  final String presentingComplaint;
  final String? observations;
  final String severity;
  final double? temperatureCelsius;
  final String? treatmentNotes;
  final String? followUpNotes;
  final List<String> symptoms;

  CreateVisitDto({
    required this.animalId,
    required this.visitDate,
    required this.presentingComplaint,
    this.observations,
    required this.severity,
    this.temperatureCelsius,
    this.treatmentNotes,
    this.followUpNotes,
    required this.symptoms,
  });

  Map<String, dynamic> toJson() {
    return {
      'animalId': animalId,
      'visitDate': visitDate,
      'presentingComplaint': presentingComplaint,
      'observations': observations,
      'severity': severity,
      'temperatureCelsius': temperatureCelsius,
      'treatmentNotes': treatmentNotes,
      'followUpNotes': followUpNotes,
      'symptoms': symptoms,
    };
  }
}
