import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../providers/api_client.dart';
import '../endpoints.dart';
import '../services/storage_service.dart';

/// Authentication repository
class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      // Save tokens
      final accessToken =
          response.data['accessToken'] ?? response.data['token'];
      final refreshToken = response.data['refreshToken'];

      if (accessToken != null) {
        await _storage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      // Parse and save user data
      final user = UserModel.fromJson(response.data['user'] ?? response.data);
      await _storage.saveUserId(user.id);
      await _storage.saveUserEmail(user.email);

      return user;
    } on DioException catch (e) {
      throw e.message ?? 'Login failed';
    } catch (e) {
      throw 'Login failed: $e';
    }
  }

  /// Register new user
  Future<UserModel> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
        },
      );

      // Save tokens
      final accessToken =
          response.data['accessToken'] ?? response.data['token'];
      final refreshToken = response.data['refreshToken'];

      if (accessToken != null) {
        await _storage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      // Parse and save user data
      final user = UserModel.fromJson(response.data['user'] ?? response.data);
      await _storage.saveUserId(user.id);
      await _storage.saveUserEmail(user.email);

      return user;
    } on DioException catch (e) {
      throw e.message ?? 'Registration failed';
    } catch (e) {
      throw 'Registration failed: $e';
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call logout API (optional)
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // Continue with local logout even if API fails
      print('Logout API failed: $e');
    } finally {
      // Clear local storage
      await _storage.clearAll();
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storage.isAuthenticated();
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to get user profile';
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }
}
