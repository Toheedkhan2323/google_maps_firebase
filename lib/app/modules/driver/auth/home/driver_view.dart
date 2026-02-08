import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_firebase/app/modules/driver/auth/driver_auth_controller.dart';
class DriverAuthView extends GetView<DriverAuthController> {
  const DriverAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    DriverAuthController driverAuthController=Get.put((DriverAuthController()));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Driver Registration"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Join us to start earning as a driver.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Email Field
            TextField(
              controller: driverAuthController.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              controller: driverAuthController.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),

            // Sign Up Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: driverAuthController.isLoading.value
                    ? null
                    : () => driverAuthController.signUp(),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "SIGN UP",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),

            const SizedBox(height: 20),

            // Switch to Login (Simple Text)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    // Yahan login toggle logic daal sakte hain
                    Get.snackbar("Notice", "Login logic can be added here");
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}