import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Authentication binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
