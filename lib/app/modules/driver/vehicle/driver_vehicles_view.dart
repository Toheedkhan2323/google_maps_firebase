import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver_vehicles_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/loading_widget.dart';

class DriverVehiclesView extends GetView<DriverVehiclesController> {
  const DriverVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Vehicles")),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: CustomText("No vehicles registered"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Icon(
                    data['type'] == 'Bike'
                        ? Icons.pedal_bike
                        : data['type'] == 'Rickshaw'
                        ? Icons.electric_rickshaw
                        : Icons.directions_car,
                  ),
                  title: Text("${data['company']} (${data['color']})"),
                  subtitle: Text("License: ${data['licenseNo']}"),
                  trailing: Text(data['type']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/driver-profile-edit'), // Go to add/edit
        child: const Icon(Icons.add),
      ),
    );
  }
}
