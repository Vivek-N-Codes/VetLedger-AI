class SymptomTrackerItem {
  final String symptomCode;
  final String displayName;
  final int occurrenceCount;
  final int totalVisits;
  final double percentage;
  final String firstRecordedDate;
  final String lastRecordedDate;
  final String status; // RECURRENT, NEW, HISTORICAL_ONLY, RESOLVED
  final String presentationText;

  SymptomTrackerItem({
    required this.symptomCode,
    required this.displayName,
    required this.occurrenceCount,
    required this.totalVisits,
    required this.percentage,
    required this.firstRecordedDate,
    required this.lastRecordedDate,
    required this.status,
    required this.presentationText,
  });

  factory SymptomTrackerItem.fromJson(Map<String, dynamic> json) {
    return SymptomTrackerItem(
      symptomCode: json['symptomCode'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      occurrenceCount: json['occurrenceCount'] as int? ?? 0,
      totalVisits: json['totalVisits'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      firstRecordedDate: json['firstRecordedDate'] as String? ?? '',
      lastRecordedDate: json['lastRecordedDate'] as String? ?? '',
      status: json['status'] as String? ?? 'HISTORICAL_ONLY',
      presentationText: json['presentationText'] as String? ?? '',
    );
  }
}

class Module1SymptomTracker {
  final int totalHistoricalVisits;
  final List<SymptomTrackerItem> symptomItems;
  final String longitudinalSummary;

  Module1SymptomTracker({
    required this.totalHistoricalVisits,
    required this.symptomItems,
    required this.longitudinalSummary,
  });

  factory Module1SymptomTracker.fromJson(Map<String, dynamic> json) {
    List<SymptomTrackerItem> items = [];
    if (json['symptomItems'] != null) {
      items = (json['symptomItems'] as List)
          .map((i) => SymptomTrackerItem.fromJson(i as Map<String, dynamic>))
          .toList();
    }
    return Module1SymptomTracker(
      totalHistoricalVisits: json['totalHistoricalVisits'] as int? ?? 0,
      symptomItems: items,
      longitudinalSummary: json['longitudinalSummary'] as String? ?? '',
    );
  }
}

class Module2CurrentPresentation {
  final String visitDate;
  final String presentingComplaint;
  final List<String> currentSymptoms;
  final String? symptomOnsetDuration;
  final String severity;
  final String? temperatureCelsius;
  final String? physicalExamFindings;
  final String? priorTreatmentsNoted;
  final String rawDraftSummary;

  Module2CurrentPresentation({
    required this.visitDate,
    required this.presentingComplaint,
    required this.currentSymptoms,
    this.symptomOnsetDuration,
    required this.severity,
    this.temperatureCelsius,
    this.physicalExamFindings,
    this.priorTreatmentsNoted,
    required this.rawDraftSummary,
  });

  factory Module2CurrentPresentation.fromJson(Map<String, dynamic> json) {
    List<String> syms = [];
    if (json['currentSymptoms'] != null) {
      syms = (json['currentSymptoms'] as List).map((e) => e.toString()).toList();
    }
    return Module2CurrentPresentation(
      visitDate: json['visitDate'] as String? ?? '',
      presentingComplaint: json['presentingComplaint'] as String? ?? '',
      currentSymptoms: syms,
      symptomOnsetDuration: json['symptomOnsetDuration'] as String?,
      severity: json['severity'] as String? ?? 'MODERATE',
      temperatureCelsius: json['temperatureCelsius']?.toString(),
      physicalExamFindings: json['physicalExamFindings'] as String?,
      priorTreatmentsNoted: json['priorTreatmentsNoted'] as String?,
      rawDraftSummary: json['rawDraftSummary'] as String? ?? '',
    );
  }
}

class Module3HistoricalComparison {
  final List<String> sharedSymptoms;
  final List<String> newlyRecordedSymptoms;
  final List<String> previouslyRecurringSymptoms;
  final List<String> historicalSymptomsNotPresent;
  final String severityTrajectory;
  final List<String> documentedTreatmentResponses;
  final List<String> missingInformation;

  Module3HistoricalComparison({
    required this.sharedSymptoms,
    required this.newlyRecordedSymptoms,
    required this.previouslyRecurringSymptoms,
    required this.historicalSymptomsNotPresent,
    required this.severityTrajectory,
    required this.documentedTreatmentResponses,
    required this.missingInformation,
  });

  factory Module3HistoricalComparison.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : [];

    return Module3HistoricalComparison(
      sharedSymptoms: toList(json['sharedSymptoms']),
      newlyRecordedSymptoms: toList(json['newlyRecordedSymptoms']),
      previouslyRecurringSymptoms: toList(json['previouslyRecurringSymptoms']),
      historicalSymptomsNotPresent: toList(json['historicalSymptomsNotPresent']),
      severityTrajectory: json['severityTrajectory'] as String? ?? 'STABLE',
      documentedTreatmentResponses: toList(json['documentedTreatmentResponses']),
      missingInformation: toList(json['missingInformation']),
    );
  }
}

class ConditionCandidate {
  final String conditionName;
  final List<String> supportingFindings;
  final List<String> relevantHistoricalEvidence;
  final List<String> findingsAgainst;
  final List<String> missingInformation;
  final List<String> distinguishingTestsOrExams;
  final String? uncertaintyNote;

  ConditionCandidate({
    required this.conditionName,
    required this.supportingFindings,
    required this.relevantHistoricalEvidence,
    required this.findingsAgainst,
    required this.missingInformation,
    required this.distinguishingTestsOrExams,
    this.uncertaintyNote,
  });

  factory ConditionCandidate.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : [];

    return ConditionCandidate(
      conditionName: json['conditionName'] as String? ?? '',
      supportingFindings: toList(json['supportingFindings']),
      relevantHistoricalEvidence: toList(json['relevantHistoricalEvidence']),
      findingsAgainst: toList(json['findingsAgainst']),
      missingInformation: toList(json['missingInformation']),
      distinguishingTestsOrExams: toList(json['distinguishingTestsOrExams']),
      uncertaintyNote: json['uncertaintyNote'] as String?,
    );
  }
}

class Module4ConditionsToConsider {
  final List<ConditionCandidate> candidateConditions;
  final String professionalNotice;

  Module4ConditionsToConsider({
    required this.candidateConditions,
    required this.professionalNotice,
  });

  factory Module4ConditionsToConsider.fromJson(Map<String, dynamic> json) {
    List<ConditionCandidate> list = [];
    if (json['candidateConditions'] != null) {
      list = (json['candidateConditions'] as List)
          .map((c) => ConditionCandidate.fromJson(c as Map<String, dynamic>))
          .toList();
    }
    return Module4ConditionsToConsider(
      candidateConditions: list,
      professionalNotice: json['professionalNotice'] as String? ?? '',
    );
  }
}

class Module5RiskIndicators {
  final List<String> recordedClinicalFacts;
  final List<String> deterministicRuleFlags;
  final List<String> aiInterpretations;
  final String urgencyLevel; // ROUTINE, ELEVATED, CRITICAL_ATTENTION

  Module5RiskIndicators({
    required this.recordedClinicalFacts,
    required this.deterministicRuleFlags,
    required this.aiInterpretations,
    required this.urgencyLevel,
  });

  factory Module5RiskIndicators.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : [];

    return Module5RiskIndicators(
      recordedClinicalFacts: toList(json['recordedClinicalFacts']),
      deterministicRuleFlags: toList(json['deterministicRuleFlags']),
      aiInterpretations: toList(json['aiInterpretations']),
      urgencyLevel: json['urgencyLevel'] as String? ?? 'ROUTINE',
    );
  }
}

class Module6RecommendedNextSteps {
  final List<String> historyToObtain;
  final List<String> observationsToVerify;
  final List<String> examinationsToConsider;
  final List<String> followUpConsiderations;
  final String veterinaryDecisionNotice;

  Module6RecommendedNextSteps({
    required this.historyToObtain,
    required this.observationsToVerify,
    required this.examinationsToConsider,
    required this.followUpConsiderations,
    required this.veterinaryDecisionNotice,
  });

  factory Module6RecommendedNextSteps.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : [];

    return Module6RecommendedNextSteps(
      historyToObtain: toList(json['historyToObtain']),
      observationsToVerify: toList(json['observationsToVerify']),
      examinationsToConsider: toList(json['examinationsToConsider']),
      followUpConsiderations: toList(json['followUpConsiderations']),
      veterinaryDecisionNotice: json['veterinaryDecisionNotice'] as String? ?? '',
    );
  }
}

class Module7ClinicalDecisionTemplate {
  final String? suggestedAssessmentPrompt;
  final String? recommendedFollowUpWindow;
  final String? ownerAdviceGuidance;
  final String practitionerActionNotice;

  Module7ClinicalDecisionTemplate({
    this.suggestedAssessmentPrompt,
    this.recommendedFollowUpWindow,
    this.ownerAdviceGuidance,
    required this.practitionerActionNotice,
  });

  factory Module7ClinicalDecisionTemplate.fromJson(Map<String, dynamic> json) {
    return Module7ClinicalDecisionTemplate(
      suggestedAssessmentPrompt: json['suggestedAssessmentPrompt'] as String?,
      recommendedFollowUpWindow: json['recommendedFollowUpWindow'] as String?,
      ownerAdviceGuidance: json['ownerAdviceGuidance'] as String?,
      practitionerActionNotice: json['practitionerActionNotice'] as String? ?? '',
    );
  }
}

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
  final bool isDraftAnalysis;
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

  // The 7 modular sections
  final Module1SymptomTracker? module1SymptomTracker;
  final Module2CurrentPresentation? module2CurrentPresentation;
  final Module3HistoricalComparison? module3HistoricalComparison;
  final Module4ConditionsToConsider? module4ConditionsToConsider;
  final Module5RiskIndicators? module5RiskIndicators;
  final Module6RecommendedNextSteps? module6RecommendedNextSteps;
  final Module7ClinicalDecisionTemplate? module7ClinicalDecision;

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
    this.isDraftAnalysis = false,
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
    this.module1SymptomTracker,
    this.module2CurrentPresentation,
    this.module3HistoricalComparison,
    this.module4ConditionsToConsider,
    this.module5RiskIndicators,
    this.module6RecommendedNextSteps,
    this.module7ClinicalDecision,
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
      isDraftAnalysis: json['draftAnalysis'] as bool? ?? json['isDraftAnalysis'] as bool? ?? false,
      clinicalSummary: json['clinicalSummary'] as String? ?? 'No clinical summary available.',
      historicalFindings: toStrList(json['historicalFindings']),
      recurringSymptoms: toStrList(json['recurringSymptoms']),
      symptomChangesOverTime: json['symptomChangesOverTime'] as String?,
      riskIndicators: toStrList(json['riskIndicators']),
      possibleConditionsToConsider: toStrList(json['possibleConditionsToConsider']),
      recommendedObservations: toStrList(json['recommendedObservations']),
      suggestedFollowUp: json['suggestedFollowUp'] as String?,
      veterinaryReviewRecommendation: json['veterinaryReviewRecommendation'] as String?,
      disclaimer: json['disclaimer'] as String? ??
          'AI-generated clinical decision support. Final assessment remains with a qualified veterinarian.',
      module1SymptomTracker: json['module1SymptomTracker'] != null
          ? Module1SymptomTracker.fromJson(json['module1SymptomTracker'] as Map<String, dynamic>)
          : null,
      module2CurrentPresentation: json['module2CurrentPresentation'] != null
          ? Module2CurrentPresentation.fromJson(json['module2CurrentPresentation'] as Map<String, dynamic>)
          : null,
      module3HistoricalComparison: json['module3HistoricalComparison'] != null
          ? Module3HistoricalComparison.fromJson(json['module3HistoricalComparison'] as Map<String, dynamic>)
          : null,
      module4ConditionsToConsider: json['module4ConditionsToConsider'] != null
          ? Module4ConditionsToConsider.fromJson(json['module4ConditionsToConsider'] as Map<String, dynamic>)
          : null,
      module5RiskIndicators: json['module5RiskIndicators'] != null
          ? Module5RiskIndicators.fromJson(json['module5RiskIndicators'] as Map<String, dynamic>)
          : null,
      module6RecommendedNextSteps: json['module6RecommendedNextSteps'] != null
          ? Module6RecommendedNextSteps.fromJson(json['module6RecommendedNextSteps'] as Map<String, dynamic>)
          : null,
      module7ClinicalDecision: json['module7ClinicalDecision'] != null
          ? Module7ClinicalDecisionTemplate.fromJson(json['module7ClinicalDecision'] as Map<String, dynamic>)
          : null,
    );
  }
}
