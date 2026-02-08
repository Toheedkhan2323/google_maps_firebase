// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'passenger_home_controller.dart';
// import '../../../global_widgets/custom_button.dart';
// import '../../../data/services/theme_service.dart';
//
// class PassengerHomeView extends GetView<PassengerHomeController> {
//   const PassengerHomeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Find a Ride"),
//         leading: IconButton(
//           icon: const Icon(Icons.brightness_4),
//           onPressed: () => Get.find<ThemeService>().switchTheme(),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Obx(
//             () => GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(31.5204, 74.3587), // Placeholder: Lahore
//                 zoom: 12,
//               ),
//               markers: controller.markers.toSet(),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: CustomButton(
//               text: "Find Ride",
//               onPressed: () => _showFilterSheet(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showFilterSheet() {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         color: Colors.white,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Select Vehicle Type",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             _filterTile("All"),
//             _filterTile("Bike"),
//             _filterTile("Rickshaw"),
//             _filterTile("Car"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _filterTile(String type) {
//     return ListTile(
//       title: Text(type),
//       onTap: () {
//         controller.applyFilter(type);
//         Get.back();
//       },
//       trailing: Obx(
//         () => controller.selectedFilter.value == type
//             ? const Icon(Icons.check_circle, color: Colors.green)
//             : const Icon(Icons.circle_outlined),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import 'passenger_home_controller.dart';
//
// class UserHomeView extends GetView<UserController> {
//   const UserHomeView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final UserController controller = Get.put(UserController());
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Find Your Ride")),
//       body: Obx(() => IndexedStack(
//         index: controller.selectIndex.value,
//         children: [
//           _buildUserMapTab(controller),
//           const Center(child: Text("Booking History", style: TextStyle(fontSize: 20))),
//           const Center(child: Text("User Settings", style: TextStyle(fontSize: 20))),
//         ],
//       )),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//         currentIndex: controller.selectIndex.value,
//         onTap: (index) => controller.selectIndex.value = index,
//         selectedItemColor: Colors.blueAccent,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.map), label: "Explore"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "Rides"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//         ],
//       )),
//     );
//   }
//
//   Widget _buildUserMapTab(UserController controller) {
//     return Stack(
//       children: [
//         Obx(() => GoogleMap(
//           initialCameraPosition:  CameraPosition(
//             //
//               target: LatLng(controller.currentPosition.value.latitude, controller.currentPosition.value.longitude), zoom: 14),
//           markers: controller.markers.value,
//           myLocationEnabled: true,
//         )),
//
//         // Vehicle Filter Button
//         Positioned(
//           bottom: 20, left: 50, right: 50,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black, foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//             ),
//             icon: const Icon(Icons.directions_car),
//             label: Obx(() => Text("Filter: ${controller.selectedVehicle.value}")),
//             onPressed: () => _showFilterSheet(controller),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showFilterSheet(UserController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: ["All", "Car", "Bike", "Rickshaw"].map((type) => ListTile(
//             title: Text(type),
//             onTap: () => controller.updateFilter(type),
//             leading: Icon(type == "All" ? Icons.apps : Icons.drive_eta),
//           )).toList(),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'passenger_home_controller.dart'; // Apna path check karlein
//
// class UserHomeView extends GetView<UserController> {
//   const UserHomeView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final UserController controller = Get.put(UserController());
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Find Your Ride")),
//       body: Obx(() => IndexedStack(
//         index: controller.selectIndex.value,
//         children: [
//           _buildUserMapTab(controller),
//           const Center(child: Text("Booking History", style: TextStyle(fontSize: 20))),
//           const Center(child: Text("User Settings", style: TextStyle(fontSize: 20))),
//         ],
//       )),
//       bottomNavigationBar: Obx(() => BottomNavigationBar(
//         currentIndex: controller.selectIndex.value,
//         onTap: (index) => controller.selectIndex.value = index,
//         selectedItemColor: Colors.blueAccent,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.map), label: "Explore"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "Rides"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//         ],
//       )),
//     );
//   }
//
//   Widget _buildUserMapTab(UserController controller) {
//     return Stack(
//       children: [
//         Obx(() => GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(
//                 controller.currentPosition.value.latitude,
//                 controller.currentPosition.value.longitude
//             ),
//             zoom: 14,
//           ),
//           // Markers ko toList() karke refresh ensure karein
//           markers: controller.markers.value,
//           myLocationEnabled: true,
//           zoomControlsEnabled: false,
//           mapType: MapType.normal,
//         )),
//
//         // Vehicle Filter Button
//         Positioned(
//           bottom: 20, left: 50, right: 50,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//             ),
//             icon: const Icon(Icons.directions_car),
//             label: Obx(() => Text("Filter: ${controller.selectedVehicle.value}")),
//             onPressed: () => _showFilterSheet(controller),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // --- MUKAMMAL UPDATED FILTER SHEET ---
//   void _showFilterSheet(UserController controller) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25))
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(bottom: 15, left: 5),
//               child: Text("Select Ride Type",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//
//             // 1. All Vehicles
//             _filterTile(controller, "All", Icons.apps, isAsset: false),
//
//             // 2. Car (Custom Image)
//             _filterTile(controller, "Car", 'assets/sport-car.png', isAsset: true),
//
//             // 3. Bike (Custom Image)
//             _filterTile(controller, "Bike", 'assets/bicycle.png', isAsset: true),
//
//             // 4. Rickshaw (Custom Image)
//             _filterTile(controller, "Rickshaw", 'assets/tricycle.png', isAsset: true),
//
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper Widget for Tiles
//   Widget _filterTile(UserController controller, String type, dynamic iconPath, {required bool isAsset}) {
//     return Obx(() {
//       bool isSelected = controller.selectedVehicle.value == type;
//       return ListTile(
//         leading: isAsset
//             ? Image.asset(iconPath, width: 35, height: 35)
//             : Icon(iconPath, color: Colors.blue, size: 30),
//         title: Text(type,
//             style: TextStyle(
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? Colors.blueAccent : Colors.black87
//             )),
//         trailing: isSelected
//             ? const Icon(Icons.check_circle, color: Colors.blueAccent)
//             : null,
//         onTap: () => controller.updateFilter(type),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         tileColor: isSelected ? Colors.blue.withOpacity(0.05) : null,
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'passenger_home_controller.dart';

class UserHomeView extends GetView<UserController> {
  const UserHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return Scaffold(
      // --- BOTTOM NAVIGATION BAR ADDED ---
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectIndex.value,
        onTap: (index) => controller.selectIndex.value = index,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Rides"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      )),

      // IndexedStack use kiya hai taake tabs switch ho sakein
      body: Obx(() => IndexedStack(
        index: controller.selectIndex.value,
        children: [
          _buildMapStack(controller, context), // Map Tab
          const Center(child: Text("Ride History Screen", style: TextStyle(fontSize: 20))), // History Tab
          const Center(child: Text("User Settings Screen", style: TextStyle(fontSize: 20))), // Settings Tab
        ],
      )),
    );
  }

  // Map wali UI ko alag function mein kar diya taake code saaf rahe
  Widget _buildMapStack(UserController controller, BuildContext context) {
    return Stack(
      children: [
        // 1. GOOGLE MAP LAYER
        Obx(() => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: controller.currentPosition.value,
            zoom: 14,
          ),
          markers: controller.markers.value,
          polylines: controller.polylines.value,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
        )),

        // 2. SEARCH BAR & SUGGESTIONS
        Positioned(
          top: 50,
          left: 15,
          right: 15,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 2))
                  ],
                ),
                child: TextField(
                  onChanged: (val) => controller.searchLocation(val),
                  decoration: InputDecoration(
                    hintText: "Where to go?",
                    prefixIcon: const Icon(Icons.location_on, color: Colors.blueAccent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controller.searchPredictions.clear(),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              Obx(() => controller.searchPredictions.isNotEmpty
                  ? Container(
                margin: const EdgeInsets.only(top: 5),
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: controller.searchPredictions.length,
                  itemBuilder: (context, index) {
                    var p = controller.searchPredictions[index];
                    return ListTile(
                      leading: const Icon(Icons.history_outlined),
                      title: Text(
                        p['description'],
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        controller.getPlaceDetails(p['place_id']);
                        controller.searchPredictions.clear();
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              )
                  : const SizedBox()),
            ],
          ),
        ),

        // 3. VEHICLE FILTER BUTTON (Bottom)
        Positioned(
          bottom: 30,
          left: 60,
          right: 60,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 10,
            ),
            icon: const Icon(Icons.directions_car_filled),
            label: Obx(() => Text(
              "Filter: ${controller.selectedVehicle.value}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            onPressed: () => _showFilterSheet(context, controller),
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context, UserController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Vehicle Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _filterTile(controller, "All", Icons.apps, isAsset: false),
            _filterTile(controller, "Car", 'assets/sport-car.png', isAsset: true),
            _filterTile(controller, "Bike", 'assets/bicycle.png', isAsset: true),
            _filterTile(controller, "Rickshaw", 'assets/tricycle.png', isAsset: true),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _filterTile(UserController controller, String type, dynamic iconPath, {required bool isAsset}) {
    return Obx(() {
      bool isSelected = controller.selectedVehicle.value == type;
      return ListTile(
        leading: isAsset
            ? Image.asset(iconPath, width: 30, height: 30)
            : Icon(iconPath, color: Colors.blueAccent),
        title: Text(
          type,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blueAccent : Colors.black,
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
        onTap: () => controller.updateFilter(type),
      );
    });
  }
}