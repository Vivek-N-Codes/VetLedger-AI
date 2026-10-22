import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/animal.dart';
import '../models/clinical_intelligence.dart';
import '../models/dashboard_stats.dart';
import '../models/surveillance_cluster.dart';
import '../models/visit.dart';

class ApiService {
  static String? _customBaseUrl;

  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }
    // Check if defined via --dart-define=API_URL=...
    const fromDefine = String.fromEnvironment('API_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    // Determine target platform default
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }
    try {
      if (Platform.isAndroid) {
        // Standard Android emulator loopback alias to host machine
        return 'http://10.0.2.2:8080/api';
      }
    } catch (_) {}
    return 'http://localhost:8080/api';
  }

  static void setCustomBaseUrl(String url) {
    _customBaseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Health
  static Future<Map<String, dynamic>> getHealth() async {
    final response = await http.get(Uri.parse('$baseUrl/health')).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Health check failed: HTTP ${response.statusCode}');
  }

  // Dashboard Stats
  static Future<DashboardStats> getDashboardStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return DashboardStats.fromJson(data);
    }
    throw Exception('Failed to load dashboard: HTTP ${response.statusCode} - ${response.body}');
  }

  // Animals Search & List
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

  // Animal Detail
  static Future<AnimalDetail> getAnimalDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/animals/$id')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AnimalDetail.fromJson(data);
    }
    throw Exception('Failed to load animal detail: HTTP ${response.statusCode}');
  }

  // Animal Visits Timeline
  static Future<List<VisitModel>> getAnimalVisits(int animalId) async {
    final response = await http.get(Uri.parse('$baseUrl/animals/$animalId/visits')).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => VisitModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load animal visits: HTTP ${response.statusCode}');
  }

  // Record Clinical Visit
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

  // AI Clinical Intelligence
  static Future<ClinicalIntelligenceModel> getClinicalIntelligence(int animalId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals/$animalId/clinical-intelligence'),
      headers: _headers,
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ClinicalIntelligenceModel.fromJson(data);
    }
    throw Exception('Failed to generate clinical intelligence: HTTP ${response.statusCode}');
  }

  // Surveillance Clusters
  static Future<List<SurveillanceCluster>> getSurveillanceClusters({int windowDays = 14}) async {
    final uri = Uri.parse('$baseUrl/surveillance/clusters?windowDays=$windowDays');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((e) => SurveillanceCluster.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load surveillance clusters: HTTP ${response.statusCode}');
  }

  // Cluster Detail
  static Future<ClusterDetailModel> getClusterDetail(String clusterId, {int windowDays = 14}) async {
    final uri = Uri.parse('$baseUrl/surveillance/clusters/$clusterId?windowDays=$windowDays');
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ClusterDetailModel.fromJson(data);
    }
    throw Exception('Failed to load cluster details: HTTP ${response.statusCode}');
  }

  // Lookup data: villages, farms, symptoms
  static Future<List<Map<String, dynamic>>> getVillages() async {
    final response = await http.get(Uri.parse('$baseUrl/villages')).timeout(const Duration(seconds: 5));
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
    // Hardcoded fallback list if network is down
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
