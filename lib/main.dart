// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get_storage/get_storage.dart';
// import 'app/core/theme/app_themes.dart';
// import 'app/data/services/theme_service.dart';
// import 'app/routes/app_pages.dart';
// import 'app/data/services/firebase_service_driver.dart';
// import 'app/data/services/firebase_service_passenger.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//
//   // Note: Firebase.initializeApp() will fail without google-services.json
//   // I am providing the professional structure.
//   // You need to add google-services.json and enable Firebase in your project.
//   try {
//     await Firebase.initializeApp();
//   } catch (e) {
//     debugPrint("Firebase not initialized: $e");
//   }
//
//   // Initialize Services
//   Get.put(FirebaseServiceDriver());
//   Get.put(FirebaseServicePassenger());
//   Get.put(ThemeService());
//
//   runApp(
//     GetMaterialApp(
//       title: "RideApp",
//       initialRoute: AppPages.initial,
//       getPages: AppPages.routes,
//       debugShowCheckedModeBanner: false,
//       theme: AppThemes.lightTheme,
//       darkTheme: AppThemes.darkTheme,
//       themeMode: ThemeService().theme,
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_firebase/app/modules/driver/home/driver_home_view.dart';
import 'package:google_maps_firebase/app/modules/passenger/home/passenger_home_view.dart';

import 'app/core/theme/app_themes.dart';
import 'app/data/services/theme_service.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/firebase_service_driver.dart';
import 'app/data/services/firebase_service_passenger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Firebase initialize karo with proper error handling
  try {
    await Firebase.initializeApp();
    debugPrint("Firebase initialized successfully");
  } catch (e) {
    debugPrint("Firebase not initialized: $e");
    // Production mein yahan error screen ya fallback logic daal sakte ho
  }

  // Services register karo
  Get.put(FirebaseServiceDriver());
  Get.put(FirebaseServicePassenger());
  Get.put(ThemeService());

  runApp(const RideApp());
}

// Yeh class add kar di gayi hai
class RideApp extends StatelessWidget {
  const RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "RideApp",
      home:
      UserHomeView(),
     //DriverHomeView(),
     //  initialRoute: AppPages.initial,
     //  getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeService().theme,   // ya Get.find<ThemeService>().themeMode agar .obs hai
    );
  }
}