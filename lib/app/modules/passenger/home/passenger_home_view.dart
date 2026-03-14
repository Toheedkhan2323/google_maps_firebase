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

class AppColors {
  static const Color primary = Color(0xFFFFC107);
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF222222);
  static const Color text = Colors.white;
  static const Color textLight = Colors.white70;
}
class UserHomePage extends StatelessWidget {
  UserHomePage({super.key});
  final UserController c = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      extendBodyBehindAppBar: true,

      // 1. DRAWER
      drawer: _buildDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.primary),
              onPressed: () {}),
        ],
      ),

      body: Stack(
        children: [
          // GOOGLE MAP (With Live Movement Tracking)
          Obx(() => GoogleMap(
            initialCameraPosition:
            CameraPosition(target: c.currentPosition.value, zoom: 15.4),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: Set.from(c.markers),
            polylines: Set.from(c.polylines),
            onMapCreated: (ctrl) => c.mapController = ctrl,
          )),

          // TOP VEHICLE FILTERS
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _mapFilterChip("All", Icons.apps),
                  _mapFilterChip("Car", Icons.directions_car),
                  _mapFilterChip("Bike", Icons.pedal_bike),
                  _mapFilterChip("Rickshaw", Icons.electric_rickshaw),
                ],
              ),
            ),
          ),

          // BOTTOM PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 110),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    // --- CASE 1: SEARCHING FOR DRIVER ---
                    if (c.rideStatus.value == 'searching') {
                      return Column(
                        children: [
                          const LinearProgressIndicator(color: AppColors.primary),
                          const SizedBox(height: 10),
                          const Text("Searching for a Driver...",
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: c.cancelRide,
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text("Cancel Request",
                                style: TextStyle(color: Colors.red)),
                          )
                        ],
                      );
                    }

                    // --- CASE 2: RIDE ACCEPTED OR DRIVER ARRIVED ---
                    if (c.rideStatus.value == 'accepted' || c.rideStatus.value == 'arrived') {
                      var d = c.driverDetails;
                      return Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              c.rideStatus.value == 'arrived' ? "DRIVER ARRIVED" : "DRIVER IS COMING",
                              style: TextStyle(
                                  color: c.rideStatus.value == 'arrived' ? Colors.green : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(height: 15),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.primary,
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              title: Text(d['name'] ?? "Driver",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "${d['vehicleModel'] ?? 'Car'} • ${d['plateNumber'] ?? 'ABC-123'}",
                                  style: const TextStyle(color: Colors.white70)),
                              trailing: IconButton(
                                icon: const Icon(Icons.phone, color: Colors.green),
                                onPressed: () {}, // Add call logic
                              ),
                            ),

                            // REQUIREMENT: Show OTP ONLY when status is 'arrived'
                            if (c.rideStatus.value == 'arrived') ...[
                              const Divider(color: Colors.white24, height: 20),
                              const Text("GIVE THIS OTP TO DRIVER",
                                  style: TextStyle(color: Colors.white54, fontSize: 11)),
                              const SizedBox(height: 5),
                             
                            ],
                          ],
                        ),
                      );
                    }

                    // --- CASE 3: DEFAULT SEARCH INTERFACE ---
                    return Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          _tabButton("Transport", 0),
                          const SizedBox(width: 12),
                          _tabButton("Delivery", 1),
                        ]),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: c.searchLocation,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Where would you go?",
                            hintStyle: const TextStyle(color: Colors.white38),
                            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.card,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        // Suggestions List
                        if (c.searchPredictions.isNotEmpty)
                          Container(
                            constraints: const BoxConstraints(maxHeight: 180),
                            margin: const EdgeInsets.only(top: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: c.searchPredictions.length,
                              itemBuilder: (_, i) => ListTile(
                                leading: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                                title: Text(c.searchPredictions[i]['description'],
                                    style: const TextStyle(color: Colors.white, fontSize: 13)),
                                onTap: () => c.getPlaceDetails(c.searchPredictions[i]['place_id']),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (c.polylines.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: c.requestRide,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              child: const Text("REQUEST RIDE NOW",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _mapFilterChip(String type, IconData icon) {
    return Obx(() {
      bool isSelected = c.selectedVehicle.value == type;
      return GestureDetector(
        onTap: () => c.updateFilter(type),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.5)),
          ),
          child: Row(children: [
            Icon(icon, size: 18, color: isSelected ? Colors.black : AppColors.primary),
            const SizedBox(width: 6),
            Text(type, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
          ]),
        ),
      );
    });
  }

  Widget _tabButton(String label, int index) {
    return Obx(() {
      bool active = c.selectIndex.value == index;
      return GestureDetector(
        onTap: () => c.selectIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label, style: TextStyle(color: active ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 35, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.black, size: 40)),
                SizedBox(height: 12),
                Text("EasyRide", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.history, color: AppColors.primary), title: const Text("My Rides", style: TextStyle(color: Colors.white)), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: const Text("Logout", style: TextStyle(color: Colors.redAccent)), onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.only(bottom: 25, left: 16, right: 16),
      child: Container(
        height: 70,
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(30)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home_filled, color: AppColors.primary, size: 28),
            Icon(Icons.favorite_border, color: Colors.white54, size: 28),
            Icon(Icons.account_balance_wallet_outlined, color: Colors.white54, size: 28),
            Icon(Icons.person_outline, color: Colors.white54, size: 28),
          ],
        ),
      ),
    );
  }
}