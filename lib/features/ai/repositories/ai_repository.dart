import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';

class AIQueryResponse {
  final String result;
  final List<double> embeddings;

  AIQueryResponse({required this.result, required this.embeddings});

  factory AIQueryResponse.fromJson(Map<String, dynamic> json) {
    return AIQueryResponse(
      result: json['result'] ?? '',
      embeddings: (json['embeddings'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}

class AIRepository {
  final Dio _dio = DioClient().dio;

  Future<AIQueryResponse> sendAiQuery(String prompt) async {
    try {
      final response = await _dio.post(
        ApiConstants.aiQuery,
        data: {'prompt': prompt},
      );

      return AIQueryResponse.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? 'AI query processing failed';
      throw Exception(errorMessage);
    }
  }
}