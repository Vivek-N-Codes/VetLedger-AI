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

  // Longitudinal & Clinical workflow enhancements
  final String? symptomOnsetDuration;
  final String? physicalExamFindings;
  final String? treatmentsAdministeredPrior;
  final String? priorTreatmentResponse;
  final String? finalClinicalAssessment;
  final String? actualTreatmentAdministered;
  final String? ownerAdvice;
  final String? followUpDueDate;
  final String? followUpStatus;

  // Financial fields
  final double consultationFee;
  final double serviceFee;
  final double medicineFee;
  final double otherFee;
  final double totalCharge;
  final String paymentStatus;

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
    this.symptomOnsetDuration,
    this.physicalExamFindings,
    this.treatmentsAdministeredPrior,
    this.priorTreatmentResponse,
    this.finalClinicalAssessment,
    this.actualTreatmentAdministered,
    this.ownerAdvice,
    this.followUpDueDate,
    this.followUpStatus,
    this.consultationFee = 0.0,
    this.serviceFee = 0.0,
    this.medicineFee = 0.0,
    this.otherFee = 0.0,
    this.totalCharge = 0.0,
    this.paymentStatus = 'UNPAID',
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
      symptomOnsetDuration: json['symptomOnsetDuration'] as String?,
      physicalExamFindings: json['physicalExamFindings'] as String?,
      treatmentsAdministeredPrior: json['treatmentsAdministeredPrior'] as String?,
      priorTreatmentResponse: json['priorTreatmentResponse'] as String?,
      finalClinicalAssessment: json['finalClinicalAssessment'] as String?,
      actualTreatmentAdministered: json['actualTreatmentAdministered'] as String?,
      ownerAdvice: json['ownerAdvice'] as String?,
      followUpDueDate: json['followUpDueDate'] as String?,
      followUpStatus: json['followUpStatus'] as String?,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      serviceFee: (json['serviceFee'] as num?)?.toDouble() ?? 0.0,
      medicineFee: (json['medicineFee'] as num?)?.toDouble() ?? 0.0,
      otherFee: (json['otherFee'] as num?)?.toDouble() ?? 0.0,
      totalCharge: (json['totalCharge'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] as String? ?? 'UNPAID',
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

  // New clinical workflow fields
  final String? symptomOnsetDuration;
  final String? physicalExamFindings;
  final String? treatmentsAdministeredPrior;
  final String? priorTreatmentResponse;
  final String? finalClinicalAssessment;
  final String? actualTreatmentAdministered;
  final String? ownerAdvice;
  final String? followUpDueDate;
  final String? followUpStatus;

  // Financial fields
  final double consultationFee;
  final double serviceFee;
  final double medicineFee;
  final double otherFee;
  final double totalCharge;

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
    this.symptomOnsetDuration,
    this.physicalExamFindings,
    this.treatmentsAdministeredPrior,
    this.priorTreatmentResponse,
    this.finalClinicalAssessment,
    this.actualTreatmentAdministered,
    this.ownerAdvice,
    this.followUpDueDate,
    this.followUpStatus,
    this.consultationFee = 0.0,
    this.serviceFee = 0.0,
    this.medicineFee = 0.0,
    this.otherFee = 0.0,
    this.totalCharge = 0.0,
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
      'symptomOnsetDuration': symptomOnsetDuration,
      'physicalExamFindings': physicalExamFindings,
      'treatmentsAdministeredPrior': treatmentsAdministeredPrior,
      'priorTreatmentResponse': priorTreatmentResponse,
      'finalClinicalAssessment': finalClinicalAssessment,
      'actualTreatmentAdministered': actualTreatmentAdministered,
      'ownerAdvice': ownerAdvice,
      'followUpDueDate': followUpDueDate,
      'followUpStatus': followUpStatus ?? 'PENDING',
      'consultationFee': consultationFee,
      'serviceFee': serviceFee,
      'medicineFee': medicineFee,
      'otherFee': otherFee,
      'totalCharge': totalCharge,
    };
  }
}

class AnalyzeDraftRequest {
  final int animalId;
  final String? visitDate;
  final String? presentingComplaint;
  final List<String> symptoms;
  final String? symptomOnsetDuration;
  final String? severity;
  final double? temperatureCelsius;
  final String? physicalExamFindings;
  final String? treatmentsAdministeredPrior;

  AnalyzeDraftRequest({
    required this.animalId,
    this.visitDate,
    this.presentingComplaint,
    required this.symptoms,
    this.symptomOnsetDuration,
    this.severity,
    this.temperatureCelsius,
    this.physicalExamFindings,
    this.treatmentsAdministeredPrior,
  });

  Map<String, dynamic> toJson() {
    return {
      'animalId': animalId,
      'visitDate': visitDate,
      'presentingComplaint': presentingComplaint,
      'symptoms': symptoms,
      'symptomOnsetDuration': symptomOnsetDuration,
      'severity': severity ?? 'MODERATE',
      'temperatureCelsius': temperatureCelsius,
      'physicalExamFindings': physicalExamFindings,
      'treatmentsAdministeredPrior': treatmentsAdministeredPrior,
    };
  }
}
