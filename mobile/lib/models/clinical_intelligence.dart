class ClinicalIntelligenceModel {
  final int animalId;
  final String animalCode;
  final String animalName;
  final String species;
  final String? breed;
  final String? farmName;
  final String? villageName;
  final String source; // LIVE_LLM or DETERMINISTIC_FALLBACK
  final String? modelName;
  final String clinicalSummary;
  final List<String> historicalFindings;
  final List<String> recurringSymptoms;
  final String? symptomChangesOverTime;
  final List<String> riskIndicators;
  final List<String> possibleConditionsToConsider;
  final List<String> recommendedObservations;
  final String? suggestedFollowUp;
  final String? veterinaryReviewRecommendation;
  final String disclaimer;

  ClinicalIntelligenceModel({
    required this.animalId,
    required this.animalCode,
    required this.animalName,
    required this.species,
    this.breed,
    this.farmName,
    this.villageName,
    required this.source,
    this.modelName,
    required this.clinicalSummary,
    required this.historicalFindings,
    required this.recurringSymptoms,
    this.symptomChangesOverTime,
    required this.riskIndicators,
    required this.possibleConditionsToConsider,
    required this.recommendedObservations,
    this.suggestedFollowUp,
    this.veterinaryReviewRecommendation,
    required this.disclaimer,
  });

  bool get isLiveLlm => source.toUpperCase().contains('LIVE');

  factory ClinicalIntelligenceModel.fromJson(Map<String, dynamic> json) {
    List<String> toStrList(dynamic val) {
      if (val == null || val is! List) return [];
      return val.map((e) => e.toString()).toList();
    }

    return ClinicalIntelligenceModel(
      animalId: json['animalId'] as int? ?? 0,
      animalCode: json['animalCode'] as String? ?? '',
      animalName: json['animalName'] as String? ?? '',
      species: json['species'] as String? ?? '',
      breed: json['breed'] as String?,
      farmName: json['farmName'] as String?,
      villageName: json['villageName'] as String?,
      source: json['source'] as String? ?? 'DETERMINISTIC_FALLBACK',
      modelName: json['modelName'] as String?,
      clinicalSummary: json['clinicalSummary'] as String? ?? 'No clinical summary available.',
      historicalFindings: toStrList(json['historicalFindings']),
      recurringSymptoms: toStrList(json['recurringSymptoms']),
      symptomChangesOverTime: json['symptomChangesOverTime'] as String?,
      riskIndicators: toStrList(json['riskIndicators']),
      possibleConditionsToConsider: toStrList(json['possibleConditionsToConsider']),
      recommendedObservations: toStrList(json['recommendedObservations']),
      suggestedFollowUp: json['suggestedFollowUp'] as String?,
      veterinaryReviewRecommendation: json['veterinaryReviewRecommendation'] as String?,
      disclaimer: json['disclaimer'] as String? ?? 'AI-generated clinical decision support. Final assessment remains with a qualified veterinarian.',
    );
  }
}
