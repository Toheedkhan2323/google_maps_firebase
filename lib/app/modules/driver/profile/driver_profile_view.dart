import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_field.dart';
import 'driver_profile_controller.dart';

class DriverProfileView extends GetView<DriverProfileController> {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Vehicle Setup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              "Personal Details",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.nameController,
              labelText: "Full Name",
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: controller.phoneController,
              labelText: "Phone Number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: controller.ageController,
              labelText: "Age",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedGender.value,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => controller.selectedGender.value = val!,
              ),
            ),

            const SizedBox(height: 30),
            const CustomText(
              "Vehicle Registration",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedVehicleType.value,
                decoration: const InputDecoration(
                  labelText: "Vehicle Type",
                  border: OutlineInputBorder(),
                ),
                items: ['Bike', 'Rickshaw', 'Car']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => controller.selectedVehicleType.value = val!,
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: controller.companyController,
              labelText: "Vehicle Company (e.g. Toyota)",
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: controller.colorController,
              labelText: "Vehicle Color",
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: controller.licenseController,
              labelText: "License Number",
            ),

            const SizedBox(height: 40),
            Obx(
              () => CustomButton(
                text: "Save & Continue",
                isLoading: controller.isLoading.value,
                onPressed: () => controller.saveProfile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
