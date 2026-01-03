import 'package:dio/dio.dart';
import '../endpoints.dart';
import '../services/storage_service.dart';

/// API Client for handling all network requests
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final StorageService _storage = StorageService();

  /// Initialize Dio with interceptors
  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Auth Interceptor - Add token to requests
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip token for auth endpoints
        if (options.path.contains('/auth/login') ||
            options.path.contains('/auth/register')) {
          return handler.next(options);
        }

        // Add token to header
        final token = await _storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized - Token expired
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the request with new token
            final newToken = await _storage.getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          } else {
            // Refresh failed - logout user
            await _storage.clearAll();
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Logging Interceptor - Log requests/responses in debug mode
  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('DATA: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
        );
        print('DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print(
          'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
        );
        print('MESSAGE: ${error.message}');
        return handler.next(error);
      },
    );
  }

  /// Error Interceptor - Handle common errors
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String message;

        if (error.response != null) {
          // Server responded with error
          switch (error.response!.statusCode) {
            case 400:
              message = error.response!.data['message'] ?? 'Bad request';
              break;
            case 401:
              message = 'Unauthorized - Please login again';
              break;
            case 403:
              message = 'Forbidden - Access denied';
              break;
            case 404:
              message = 'Resource not found';
              break;
            case 500:
              message = 'Server error - Please try again later';
              break;
            default:
              message = 'Something went wrong';
          }
        } else {
          // Network error
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            message = 'Connection timeout - Please check your internet';
          } else if (error.type == DioExceptionType.connectionError) {
            message = 'No internet connection';
          } else {
            message = 'Network error - Please try again';
          }
        }

        // Attach user-friendly message
        error = error.copyWith(message: message);

        return handler.next(error);
      },
    );
  }

  /// Refresh access token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await _storage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        return true;
      }

      return false;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
