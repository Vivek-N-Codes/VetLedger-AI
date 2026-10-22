import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/animal.dart';
import '../models/clinical_follow_up.dart';
import '../models/clinical_intelligence.dart';
import '../models/dashboard_stats.dart';
import '../models/farm.dart';
import '../models/owner_ledger.dart';
import '../models/surveillance_cluster.dart';
import '../models/visit.dart';

class ApiService {
  static String? _customBaseUrl;

  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }
    const fromDefine = String.fromEnvironment('API_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    const defaultCloudApi = 'https://vetledger-backend.onrender.com/api';
    if (kIsWeb) {
      final origin = Uri.base.origin;
      if (origin.isNotEmpty && !origin.startsWith('file://') && !origin.contains('localhost')) {
        return '$origin/api';
      }
      return defaultCloudApi;
    }
    return defaultCloudApi;
  }

  static void setCustomBaseUrl(String url) {
    _customBaseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // -------------------------------------------------------------
  // HEALTH & DASHBOARD
  // -------------------------------------------------------------
  static Future<Map<String, dynamic>> getHealth() async {
    final response = await http.get(Uri.parse('$baseUrl/health')).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Health check failed: HTTP ${response.statusCode}');
  }

  static Future<DashboardStats> getDashboardStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return DashboardStats.fromJson(data);
    }
    throw Exception('Failed to load dashboard: HTTP ${response.statusCode} - ${response.body}');
  }

  // -------------------------------------------------------------
  // ANIMALS
  // -------------------------------------------------------------
  static Future<List<AnimalSummary>> getAnimals({
    String? search,
    int? villageId,
    int? farmId,
    String? species,
  }) async {
    final params = <String, String>{};
    if (search != null && search.trim().isNotEmpty) params['search'] = search.trim();
    if (villageId != null) params['villageId'] = villageId.toString();
    if (farmId != null) params['farmId'] = farmId.toString();
    if (species != null && species.trim().isNotEmpty) params['species'] = species.trim();

    final uri = Uri.parse('$baseUrl/animals').replace(queryParameters: params.isNotEmpty ? params : null);
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => AnimalSummary.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load animals: HTTP ${response.statusCode}');
  }

  static Future<AnimalDetail> getAnimalDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/animals/$id')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AnimalDetail.fromJson(data);
    }
    throw Exception('Failed to load animal detail: HTTP ${response.statusCode}');
  }

  static Future<AnimalDetail> registerAnimal(CreateAnimalRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AnimalDetail.fromJson(data);
    }
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Failed to register animal: HTTP ${response.statusCode}');
  }

  static Future<List<VisitModel>> getAnimalVisits(int animalId) async {
    final response = await http.get(Uri.parse('$baseUrl/animals/$animalId/visits')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => VisitModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load animal visits: HTTP ${response.statusCode}');
  }

  // -------------------------------------------------------------
  // FARMS
  // -------------------------------------------------------------
  static Future<List<FarmSummary>> getFarmsList({int? villageId, String? search}) async {
    final params = <String, String>{};
    if (villageId != null) params['villageId'] = villageId.toString();
    if (search != null && search.trim().isNotEmpty) {
      params['query'] = search.trim();
      params['search'] = search.trim();
    }

    final uri = Uri.parse('$baseUrl/farms').replace(queryParameters: params.isNotEmpty ? params : null);
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => FarmSummary.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load farms: HTTP ${response.statusCode}');
  }

  static Future<FarmDetail> getFarmDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/farms/$id')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FarmDetail.fromJson(data);
    }
    throw Exception('Failed to load farm details: HTTP ${response.statusCode}');
  }

  static Future<FarmDetail> createFarm(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/farms'),
      headers: _headers,
      body: jsonEncode(payload),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FarmDetail.fromJson(data);
    }
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Failed to create farm: HTTP ${response.statusCode}');
  }

  // -------------------------------------------------------------
  // VISITS & CLINICAL INTELLIGENCE
  // -------------------------------------------------------------
  static Future<VisitModel> createVisit(CreateVisitDto request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/visits'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return VisitModel.fromJson(data);
    }
    throw Exception('Failed to record visit: HTTP ${response.statusCode} - ${response.body}');
  }

  static Future<ClinicalIntelligenceModel> getClinicalIntelligence(int animalId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals/$animalId/clinical-intelligence'),
      headers: _headers,
    ).timeout(const Duration(seconds: 14));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ClinicalIntelligenceModel.fromJson(data);
    }
    throw Exception('Failed to generate clinical intelligence: HTTP ${response.statusCode}');
  }

  static Future<ClinicalIntelligenceModel> analyzeDraftVisit(AnalyzeDraftRequest draft) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals/draft-analysis'),
      headers: _headers,
      body: jsonEncode(draft.toJson()),
    ).timeout(const Duration(seconds: 14));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ClinicalIntelligenceModel.fromJson(data);
    }
    throw Exception('Failed to analyze visit draft: HTTP ${response.statusCode} - ${response.body}');
  }

  // -------------------------------------------------------------
  // SURVEILLANCE & POPULATION HEALTH
  // -------------------------------------------------------------
  static Future<List<SurveillanceCluster>> getSurveillanceClusters({int windowDays = 14}) async {
    final uri = Uri.parse('$baseUrl/surveillance/clusters?windowDays=$windowDays');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => SurveillanceCluster.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load surveillance clusters: HTTP ${response.statusCode}');
  }

  static Future<ClusterDetailModel> getClusterDetail(String clusterId, {int windowDays = 14}) async {
    final uri = Uri.parse('$baseUrl/surveillance/clusters/$clusterId?windowDays=$windowDays');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ClusterDetailModel.fromJson(data);
    }
    throw Exception('Failed to load cluster details: HTTP ${response.statusCode}');
  }

  static Future<PopulationOverview> getPopulationOverview({int windowDays = 14}) async {
    final uri = Uri.parse('$baseUrl/surveillance/overview?windowDays=$windowDays');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return PopulationOverview.fromJson(data);
    }
    throw Exception('Failed to load population overview: HTTP ${response.statusCode}');
  }

  // -------------------------------------------------------------
  // OWNER FINANCIAL LEDGER
  // -------------------------------------------------------------
  static Future<List<OwnerLedgerSummary>> getOwnerLedgers({String? search}) async {
    final params = <String, String>{};
    if (search != null && search.trim().isNotEmpty) params['search'] = search.trim();

    final uri = Uri.parse('$baseUrl/ledger/owners').replace(queryParameters: params.isNotEmpty ? params : null);
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => OwnerLedgerSummary.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load owner ledgers: HTTP ${response.statusCode}');
  }

  static Future<OwnerLedgerDetail> getOwnerLedgerDetail(int ownerId) async {
    final uri = Uri.parse('$baseUrl/ledger/owners/$ownerId');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return OwnerLedgerDetail.fromJson(data);
    }
    throw Exception('Failed to load owner ledger detail: HTTP ${response.statusCode}');
  }

  static Future<PaymentReceipt> recordPayment(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ledger/payments'),
      headers: _headers,
      body: jsonEncode(payload),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return PaymentReceipt.fromJson(data);
    }
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Failed to record payment: HTTP ${response.statusCode}');
  }

  static Future<PaymentReceipt> getPaymentReceipt(int paymentId) async {
    final uri = Uri.parse('$baseUrl/ledger/payments/$paymentId/receipt');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return PaymentReceipt.fromJson(data);
    }
    throw Exception('Failed to load payment receipt: HTTP ${response.statusCode}');
  }

  // -------------------------------------------------------------
  // CLINICAL FOLLOW-UPS
  // -------------------------------------------------------------
  static Future<List<ClinicalFollowUpModel>> getFollowUps({String? status}) async {
    final uri = status != null
        ? Uri.parse('$baseUrl/follow-ups?status=$status')
        : Uri.parse('$baseUrl/follow-ups');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => ClinicalFollowUpModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load follow ups: HTTP ${response.statusCode}');
  }

  static Future<ClinicalFollowUpModel> updateFollowUpStatus(int id, String status, {String? notes}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/follow-ups/$id/status'),
      headers: _headers,
      body: jsonEncode({'status': status, 'notes': notes}),
    ).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ClinicalFollowUpModel.fromJson(data);
    }
    throw Exception('Failed to update follow-up status: HTTP ${response.statusCode}');
  }

  // -------------------------------------------------------------
  // LOOKUPS & SEARCH
  // -------------------------------------------------------------
  static Future<List<Map<String, dynamic>>> getVillages() async {
    final response = await http.get(Uri.parse('$baseUrl/villages')).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getOwners({int? villageId}) async {
    final uri = villageId != null
        ? Uri.parse('$baseUrl/owners?villageId=$villageId')
        : Uri.parse('$baseUrl/owners');
    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getFarms({int? villageId}) async {
    final uri = villageId != null
        ? Uri.parse('$baseUrl/farms?villageId=$villageId')
        : Uri.parse('$baseUrl/farms');
    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<List<Map<String, String>>> getStandardSymptoms() async {
    final response = await http.get(Uri.parse('$baseUrl/symptoms')).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => Map<String, String>.from(e as Map)).toList();
    }
    return [
      {'code': 'FEVER', 'label': 'Fever / Hyperthermia'},
      {'code': 'NASAL_DISCHARGE', 'label': 'Nasal Discharge'},
      {'code': 'REDUCED_APPETITE', 'label': 'Reduced Appetite'},
      {'code': 'COUGH', 'label': 'Cough / Respiratory Rales'},
      {'code': 'DIARRHEA', 'label': 'Diarrhea / Scouring'},
      {'code': 'LETHARGY', 'label': 'Lethargy / Dull Demeanor'},
      {'code': 'EXCESSIVE_SALIVATION', 'label': 'Excessive Salivation'},
      {'code': 'REDUCED_MILK_PRODUCTION', 'label': 'Reduced Milk Yield'},
    ];
  }
}
