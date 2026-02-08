import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/firebase_service_driver.dart';

class DriverAuthController extends GetxController {
  final FirebaseServiceDriver _firebaseService =
      Get.find<FirebaseServiceDriver>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> signUp() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    var user = await _firebaseService.registerDriver(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    isLoading.value = false;

    if (user != null) {
      Get.offNamed('/driver-profile-setup');
    }
  }

  Future<void> login() async {
    // Basic login logic
  }
}
