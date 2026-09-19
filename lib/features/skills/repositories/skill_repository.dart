import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class SkillRepository {
  final Dio _dio = DioClient().dio;

  /// Fetches the full attribute matrix, XP distributions, and detailed skill levels
  Future<Map<String, dynamic>> fetchUserMatrix() async {
    try {
      final response = await _dio.get('/api/users/matrix');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to load skill matrix.');
    }
  }

  /// Manually submit a verified skill entry
  Future<Map<String, dynamic>> submitSkill({
    required String name,
    required String description,
    required String attribute,
  }) async {
    try {
      final response = await _dio.post('/api/skills/submit', data: {
        'name': name,
        'description': description,
        'attribute': attribute,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Skill guard validation failed.');
    }
  }
}