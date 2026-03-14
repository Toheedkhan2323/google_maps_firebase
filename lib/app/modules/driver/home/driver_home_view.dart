// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'driver_home_controller.dart';
// // import '../../../global_widgets/custom_text.dart';
// // import '../../../data/services/theme_service.dart';
// //
// // class DriverHomeView extends GetView<DriverHomeController> {
// //   const DriverHomeView({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Driver Dashboard"),
// //         leading: IconButton(
// //           icon: const Icon(Icons.brightness_6),
// //           onPressed: () => Get.find<ThemeService>().switchTheme(),
// //         ),
// //         actions: [
// //           Obx(
// //             () => Switch(
// //               value: controller.isServiceOn.value,
// //               onChanged: (val) => controller.toggleService(val),
// //               activeColor: Colors.green,
// //             ),
// //           ),
// //         ],
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           children: [
// //             const DrawerHeader(
// //               decoration: BoxDecoration(color: Colors.blue),
// //               child: CustomText(
// //                 "Driver Menu",
// //                 color: Colors.white,
// //                 fontSize: 24,
// //               ),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.person),
// //               title: const Text("Edit Profile"),
// //               onTap: () => Get.toNamed('/driver-profile-edit'),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.directions_car),
// //               title: const Text("My Vehicles"),
// //               onTap: () => Get.toNamed('/driver-vehicles'),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.logout),
// //               title: const Text("Logout"),
// //               onTap: () {
// //                 // Logout logic
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Obx(
// //               () => CustomText(
// //                 controller.isServiceOn.value
// //                     ? "You are ONLINE"
// //                     : "You are OFFLINE",
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.bold,
// //                 color: controller.isServiceOn.value ? Colors.green : Colors.red,
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Obx(
// //               () => CustomText(
// //                 "Current Location: ${controller.currentPosition.value?.latitude ?? 'N/A'}, ${controller.currentPosition.value?.longitude ?? 'N/A'}",
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'driver_home_controller.dart';
// import '../../../global_widgets/custom_text.dart';
//
// class DriverHomeView extends GetView<DriverHomeController> {
//   const DriverHomeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     //final controller = Get.put(DriverHomeController());
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       drawer: _buildDrawer(),
//       appBar: _buildAppBar(),
//       body: Stack(
//         children: [
//           // --- 1. Map Layer ---
//           Obx(() => GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(
//                 controller.currentPosition.value?.latitude ?? 0.0,
//                 controller.currentPosition.value?.longitude ?? 0.0,
//               ),
//               zoom: 15,
//             ),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//             onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
//             markers: Set<Marker>.of({
//               Marker(markerId: MarkerId("current position"),
//               )
//             }),
//           )),
//
//           // --- 2. Top Status Banner ---
//           SafeArea(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Obx(() => Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: controller.isServiceOn.value ? Colors.green : Colors.red,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
//                 ),
//                 child: CustomText(
//                   controller.isServiceOn.value ? "YOU ARE ONLINE" : "YOU ARE OFFLINE",
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )),
//             ),
//           ),
//
//           // --- 3. Bottom Dashboard Card ---
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: _buildBottomCard(),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildFAB(),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: Builder(builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.white,
//             child: IconButton(
//               icon: const Icon(Icons.menu, color: Colors.black),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildBottomCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStat("Earnings", "\$0.00"),
//               const SizedBox(height: 30, child: VerticalDivider()),
//               _buildStat("Trips", "0"),
//               const SizedBox(height: 30, child: VerticalDivider()),
//               _buildStat("Rating", "5.0 ★"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStat(String label, String value) {
//     return Column(
//       children: [
//         CustomText(label, fontSize: 12, color: Colors.grey),
//         CustomText(value, fontSize: 16, fontWeight: FontWeight.bold),
//       ],
//     );
//   }
//
//   Widget _buildFAB() {
//     return Obx(() => FloatingActionButton.extended(
//       onPressed: () => controller.toggleService(!controller.isServiceOn.value),
//       backgroundColor: controller.isServiceOn.value ? Colors.orange : Colors.blue,
//       label: Text(controller.isServiceOn.value ? "STOP SERVICE" : "START SERVICE"),
//       icon: Icon(controller.isServiceOn.value ? Icons.stop : Icons.play_arrow),
//     ));
//   }
//
//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         children: [
//           const UserAccountsDrawerHeader(
//             accountName: Text("Driver Name"),
//             accountEmail: Text("driver@service.com"),
//             currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
//           ),
//           ListTile(
//             leading: const Icon(Icons.history),
//             title: const Text("Ride History"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text("Logout"),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/modules/driver/view/driver_home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_firebase/app/modules/driver/home/driver_home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller ko initialize karna agar binding se nahi aa raha
    final controller = Get.put(DriverHomeController());

    return Scaffold(
      // Side Menu
      drawer: _buildDriverDrawer(),

      body: Stack(
        children: [
          // 1. GOOGLE MAP
          Obx(() => GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(33.6844, 73.0479),
                zoom: 14
            ),
            markers: Set.from(controller.markers),
            onMapCreated: (c) => controller.mapController = c,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          )),

          // 2. CUSTOM APP BAR (Menu Button)
          Positioned(
            top: 50,
            left: 20,
            child: Builder(builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.menu, color: Colors.black),
              ),
            )),
          ),

          // 3. ONLINE/OFFLINE STATUS BAR
          Positioned(
            top: 110, left: 20, right: 20,
            child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: controller.isOnline.value ? Colors.green : Colors.grey[800],
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        controller.isOnline.value ? Icons.wifi : Icons.wifi_off,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        controller.isOnline.value ? "YOU ARE ONLINE" : "YOU ARE OFFLINE",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Switch(
                    value: controller.isOnline.value,
                    onChanged: (val) => controller.toggleOnlineStatus(),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.black26,
                  ),
                ],
              ),
            )),
          ),

          // 4. INCOMING REQUESTS PANEL
          Obx(() {
            if (!controller.isOnline.value || controller.incomingRequests.isEmpty) {
              return const SizedBox.shrink();
            }
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 280,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 15),
                    const Text("New Ride Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.incomingRequests.length,
                        itemBuilder: (context, index) {
                          var req = controller.incomingRequests[index];
                          var data = req.data() as Map<String, dynamic>;

                          return Card(
                            elevation: 0,
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white)),
                              title: Text(data['passengerName'] ?? "Passenger", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(data['pickup']['address'] ?? "No Address", maxLines: 1),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                                // YE BUTTON NAVIGATE KAREGA (Controller ke through)
                                onPressed: () => controller.acceptRide(req.id),
                                child: const Text("ACCEPT", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Side Drawer Widget
  Widget _buildDriverDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.amber, child: Icon(Icons.person, size: 40)),
                const SizedBox(height: 10),
                const Text("Driver Partner", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(controller.isOnline.value ? "Active" : "Inactive", style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text("Earnings"), onTap: () {}),
          ListTile(leading: const Icon(Icons.history), title: const Text("Trip History"), onTap: () {}),
          ListTile(leading: const Icon(Icons.settings), title: const Text("Settings"), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Logout"), onTap: () {}),
        ],
      ),
    );
  }
}     