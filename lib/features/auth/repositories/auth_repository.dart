import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../shared/models/user_model.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;
  final SecureStorageService _storageService = SecureStorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      if (token != null) {
        await _storageService.saveToken(token);
      }

      final user = User.fromJson(response.data['user']);
      return {'user': user, 'token': token};
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? 'Authentication failed';
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      final token = response.data['token'];
      if (token != null) {
        await _storageService.saveToken(token);
      }

      final user = User.fromJson(response.data['user']);
      return {'user': user, 'token': token};
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? 'Registration failed';
      throw Exception(errorMessage);
    }
  }

  Future<User?> fetchProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return User.fromJson(response.data['user']);
    } on DioException {
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }
}