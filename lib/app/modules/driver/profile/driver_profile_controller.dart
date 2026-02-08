import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/firebase_service_driver.dart';

class DriverProfileController extends GetxController {
  final FirebaseServiceDriver _firebaseService =
      Get.find<FirebaseServiceDriver>();

  // Profile Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  var selectedGender = 'Male'.obs;

  // Vehicle Controllers
  var selectedVehicleType = 'Car'.obs;
  final colorController = TextEditingController();
  final companyController = TextEditingController();
  final licenseController = TextEditingController();

  var isLoading = false.obs;

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      await _firebaseService.updateProfile(
        name: nameController.text,
        email: Get.find<FirebaseServiceDriver>().auth.currentUser!.email ?? "",
        phone: phoneController.text,
        gender: selectedGender.value,
        age: ageController.text,
      );

      await _firebaseService.addVehicleData(
        vehicleType: selectedVehicleType.value,
        color: colorController.text,
        company: companyController.text,
        licenseNo: licenseController.text,
      );

      Get.offAllNamed('/driver-home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
