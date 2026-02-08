import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/services/firebase_service_driver.dart';

class DriverVehiclesController extends GetxController {
  final FirebaseServiceDriver _firebaseService =
      Get.find<FirebaseServiceDriver>();

  Stream<QuerySnapshot> getVehicles() {
    return _firebaseService.getDriverVehicles();
  }
}
