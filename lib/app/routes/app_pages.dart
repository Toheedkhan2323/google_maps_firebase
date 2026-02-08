import 'package:get/get.dart';
import 'package:google_maps_firebase/app/modules/driver/auth/driver_auth_controller.dart';
import '../modules/driver/auth/home/driver_view.dart';
import '../modules/driver/profile/driver_profile_controller.dart';
import '../modules/driver/profile/driver_profile_view.dart';
import '../modules/driver/home/driver_home_controller.dart';
import '../modules/driver/home/driver_home_view.dart';
import '../modules/driver/vehicle/driver_vehicles_controller.dart';
import '../modules/driver/vehicle/driver_vehicles_view.dart';
import '../modules/passenger/home/passenger_home_controller.dart';
import '../modules/passenger/home/passenger_home_view.dart';

class AppPages {
  // Sabse pehle user ko selection screen dikhegi
  static const initial = '/auth-selection';

  static final List<GetPage> routes = [
    // --- AUTH SELECTION SCREEN ---
    GetPage(
      name: '/auth-selection',
      page: () => const DriverAuthView(),
    ),

    // --- DRIVER AUTH (Sign Up / Login) ---
    GetPage(
      name: '/driver-auth',
      page: () => const DriverAuthView(), // Aapka signup page jahan signUp() call hota hai
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DriverAuthController());
      }),
    ),

    // --- DRIVER PROFILE SETUP ---
    GetPage(
      name: '/driver-profile-setup',
      page: () => const DriverProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DriverProfileController());
      }),
    ),

    // --- DRIVER HOME ---
    GetPage(
      name: '/driver-home',
      page: () => const DriverHomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DriverHomeController());
      }),
    ),

    // --- DRIVER VEHICLES ---
    GetPage(
      name: '/driver-vehicles',
      page: () => const DriverVehiclesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DriverVehiclesController());
      }),
    ),

    // --- PASSENGER / USER HOME ---
    GetPage(
      name: '/user-home',
      page: () => const UserHomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => UserController());
      }),
    ),
  ];
}
