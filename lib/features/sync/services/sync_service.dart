import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class SyncService {
  final Dio _dio = DioClient().dio;

  /// Triggers an active evaluation mesh run on the backend for the user's latest unverified telemetry
  Future<Map<String, dynamic>> triggerActiveEvaluation() async {
    try {
      final response = await _dio.post('/api/commander/evaluate'); // Adjust endpoint to match your router
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to trigger synchronization evaluation.');
    }
  }

  /// Pushes external app telemetry (e.g., from local sensors, health package, or git hooks) to the backend
  Future<Map<String, dynamic>> pushExternalTelemetry({
    required String sourceType,
    required String rawTitle,
    required String rawDescription,
  }) async {
    try {
      final response = await _dio.post('/api/telemetry/ingest', data: {
        'sourceType': sourceType,
        'rawTitle': rawTitle,
        'rawDescription': rawDescription,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Telemetry sync failed.');
    }
  }

  /// Fetches the dynamic GitHub webhook bridge URL for code synchronization
  Future<String> fetchWebhookBridgeUrl() async {
    try {
      final response = await _dio.get('/api/users/webhook-bridge');
      return response.data['webhookUrl'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to fetch webhook bridge URL.');
    }
  }
}