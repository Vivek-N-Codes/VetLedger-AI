import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vetledger_mobile/models/animal.dart';
import 'package:vetledger_mobile/models/clinical_intelligence.dart';
import 'package:vetledger_mobile/models/surveillance_cluster.dart';
import 'package:vetledger_mobile/models/visit.dart';
import 'package:vetledger_mobile/widgets/disclaimer_banner.dart';
import 'package:vetledger_mobile/widgets/status_badge.dart';
import 'package:vetledger_mobile/main.dart';

void main() {
  group('Model Deserialization Tests', () {
    test('AnimalSummary fromJson', () {
      final json = {
        'id': 1,
        'animalCode': 'COW-SNG-101',
        'name': 'Lakshmi',
        'species': 'Cattle',
        'breed': 'Gir',
        'ageYears': 4.5,
        'sex': 'FEMALE',
        'farmId': 1,
        'farmName': 'Patil Dairy',
        'villageId': 1,
        'villageName': 'Sangamner',
        'lastVisitDate': '2026-10-22',
        'lastVisitComplaint': 'Fever and off-feed',
        'totalVisits': 3,
      };

      final summary = AnimalSummary.fromJson(json);
      expect(summary.id, 1);
      expect(summary.animalCode, 'COW-SNG-101');
      expect(summary.name, 'Lakshmi');
      expect(summary.species, 'Cattle');
      expect(summary.totalVisits, 3);
    });

    test('VisitModel fromJson', () {
      final json = {
        'id': 10,
        'animalId': 1,
        'animalCode': 'COW-SNG-101',
        'animalName': 'Lakshmi',
        'visitDate': '2026-10-22',
        'presentingComplaint': 'Acute high fever',
        'observations': 'Rales present',
        'severity': 'SEVERE',
        'temperatureCelsius': 40.2,
        'symptoms': ['FEVER', 'NASAL_DISCHARGE', 'REDUCED_APPETITE'],
      };

      final visit = VisitModel.fromJson(json);
      expect(visit.id, 10);
      expect(visit.severity, 'SEVERE');
      expect(visit.temperatureCelsius, 40.2);
      expect(visit.symptoms.length, 3);
      expect(visit.symptoms.contains('FEVER'), isTrue);
    });

    test('ClinicalIntelligenceModel fromJson handles fallback source', () {
      final json = {
        'animalId': 1,
        'animalCode': 'COW-SNG-101',
        'animalName': 'Lakshmi',
        'species': 'Cattle',
        'source': 'DETERMINISTIC_FALLBACK',
        'clinicalSummary': 'Deterministic test summary',
        'historicalFindings': ['Finding 1', 'Finding 2'],
        'recurringSymptoms': ['Fever'],
        'riskIndicators': ['Hyperthermia'],
        'possibleConditionsToConsider': ['BRDC Differential'],
        'recommendedObservations': ['Auscultate lungs'],
        'disclaimer': 'AI-generated clinical decision support.',
      };

      final intel = ClinicalIntelligenceModel.fromJson(json);
      expect(intel.source, 'DETERMINISTIC_FALLBACK');
      expect(intel.isLiveLlm, isFalse);
      expect(intel.recurringSymptoms.length, 1);
    });

    test('SurveillanceCluster fromJson', () {
      final json = {
        'clusterId': 'CLUST-SNG-01',
        'villageId': 1,
        'villageName': 'Sangamner',
        'observationWindowDays': 14,
        'windowStartDate': '2026-10-09',
        'windowEndDate': '2026-10-22',
        'distinctAnimalCount': 17,
        'affectedFarmCount': 6,
        'sharedSymptoms': ['FEVER', 'NASAL_DISCHARGE', 'REDUCED_APPETITE'],
        'baselineAnimalCount': 1.8,
        'elevationFactor': 9.4,
        'riskLevel': 'HIGH',
        'riskTitle': 'Potential Cluster Alert',
        'rationale': '17 animals affected',
        'veterinaryNotice': 'Preliminary signal',
      };

      final cluster = SurveillanceCluster.fromJson(json);
      expect(cluster.clusterId, 'CLUST-SNG-01');
      expect(cluster.distinctAnimalCount, 17);
      expect(cluster.affectedFarmCount, 6);
      expect(cluster.elevationFactor, 9.4);
      expect(cluster.riskLevel, 'HIGH');
    });
  });

  group('Widget Rendering Tests', () {
    testWidgets('StatusBadge renders severity and risk labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StatusBadge.severity('SEVERE'),
                StatusBadge.severity('MILD'),
                StatusBadge.risk('HIGH'),
                StatusBadge.aiSource('DETERMINISTIC_FALLBACK'),
                StatusBadge.aiSource('LIVE_LLM'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('SEVERE'), findsOneWidget);
      expect(find.text('MILD'), findsOneWidget);
      expect(find.text('HIGH PRIORITY'), findsOneWidget);
      expect(find.text('DETERMINISTIC FALLBACK ENGINE'), findsOneWidget);
      expect(find.text('LIVE LLM INTELLIGENCE'), findsOneWidget);
    });

    testWidgets('DisclaimerBanner renders text and warning icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DisclaimerBanner(text: 'Mandatory clinical notice'),
          ),
        ),
      );

      expect(find.text('Mandatory clinical notice'), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
    });

    testWidgets('MainNavigationShell renders bottom navigation destinations', (WidgetTester tester) async {
      await tester.pumpWidget(const VetLedgerApp());

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Farms'), findsOneWidget);
      expect(find.text('Surveillance'), findsOneWidget);
      expect(find.text('Ledger'), findsOneWidget);
    });
  });
}
