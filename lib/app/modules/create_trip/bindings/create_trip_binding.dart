import 'package:get/get.dart';
import '../controllers/create_trip_controller.dart';

class CreateTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTripController>(() => CreateTripController());
  }
}
