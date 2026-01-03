import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

/// Authentication controller
class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observable state
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> checkAuthStatus() async {
    try {
      final authenticated = await _authRepository.isAuthenticated();
      isAuthenticated.value = authenticated;

      if (authenticated) {
        // Load user profile
        await loadUserProfile();
      }
    } catch (e) {
      print('Auth check error: $e');
      isAuthenticated.value = false;
    }
  }

  /// Load current user profile
  Future<void> loadUserProfile() async {
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
      isAuthenticated.value = true;
    } catch (e) {
      print('Load profile error: $e');
      errorMessage.value = e.toString();
    }
  }

  /// Login with email and password
  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authRepository.login(
        email: email,
        password: password,
      );

      currentUser.value = user;
      isAuthenticated.value = true;

      // Navigate to dashboard
      Get.offAllNamed(Routes.DASHBOARD);

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      currentUser.value = user;
      isAuthenticated.value = true;

      // Navigate to dashboard
      Get.offAllNamed(Routes.DASHBOARD);

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authRepository.logout();

      currentUser.value = null;
      isAuthenticated.value = false;

      // Navigate to login
      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}
