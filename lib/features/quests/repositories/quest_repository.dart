import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../shared/models/quest_model.dart';

class QuestRepository {
  final Dio _dio = DioClient().dio;

  Future<List<UserQuest>> fetchUserQuests() async {
    try {
      final response = await _dio.get('${ApiConstants.profile}/quests'); // or your specific quest endpoint
      final list = response.data['quests'] as List<dynamic>? ?? [];
      return list.map((e) => UserQuest.fromJson(e)).toList();
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? 'Failed to load quests';
      throw Exception(errorMessage);
    }
  }

  Future<void> completeQuest(String userQuestId) async {
    try {
      await _dio.post('${ApiConstants.baseUrl}/quests/$userQuestId/complete');
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? 'Failed to complete quest';
      throw Exception(errorMessage);
    }
  }
}