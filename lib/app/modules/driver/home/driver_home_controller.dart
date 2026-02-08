// // // import 'dart:async';
// // // import 'package:get/get.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import '../../../data/services/firebase_service_driver.dart';
// // // import '../../../core/constants/app_constants.dart';
// // //
// // // class DriverHomeController extends GetxController {
// // //   final FirebaseServiceDriver _firebaseService =
// // //       Get.find<FirebaseServiceDriver>();
// // //
// // //   var isServiceOn = false.obs;
// // //   var currentPosition = Rxn<Position>();
// // //   Position? _lastUpdatedPosition;
// // //   Timer? _locationTimer;
// // //
// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     _checkPermission();
// // //   }
// // //
// // //   Future<void> _checkPermission() async {
// // //     bool serviceEnabled;
// // //     LocationPermission permission;
// // //
// // //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // //     if (!serviceEnabled) return;
// // //
// // //     permission = await Geolocator.checkPermission();
// // //     if (permission == LocationPermission.denied) {
// // //       permission = await Geolocator.requestPermission();
// // //       if (permission == LocationPermission.denied) return;
// // //     }
// // //   }
// // //
// // //   void toggleService(bool value) {
// // //     isServiceOn.value = value;
// // //     _updateStatusInFirebase();
// // //
// // //     if (isServiceOn.value) {
// // //       _startLocationUpdates();
// // //     } else {
// // //       _stopLocationUpdates();
// // //     }
// // //   }
// // //
// // //   void _startLocationUpdates() {
// // //     _locationTimer = Timer.periodic(
// // //       Duration(seconds: AppConstants.locationUpdateInterval),
// // //       (timer) async {
// // //         if (isServiceOn.value) {
// // //           Position position = await Geolocator.getCurrentPosition();
// // //           currentPosition.value = position;
// // //
// // //           // Calculate distance from last update
// // //           double distance = 0;
// // //           if (_lastUpdatedPosition != null) {
// // //             distance = Geolocator.distanceBetween(
// // //               _lastUpdatedPosition!.latitude,
// // //               _lastUpdatedPosition!.longitude,
// // //               position.latitude,
// // //               position.longitude,
// // //             );
// // //           }
// // //
// // //           // Update ONLY if distance > 3 meters or first time
// // //           if (_lastUpdatedPosition == null ||
// // //               distance >= AppConstants.driverUpdateDistance) {
// // //             _lastUpdatedPosition = position;
// // //             _firebaseService.updateLocationStatus(
// // //               lat: position.latitude,
// // //               lng: position.longitude,
// // //               status: 'on',
// // //             );
// // //           }
// // //         }
// // //       },
// // //     );
// // //   }
// // //
// // //   void _stopLocationUpdates() {
// // //     _locationTimer?.cancel();
// // //     _firebaseService.updateLocationStatus(
// // //       lat: currentPosition.value?.latitude ?? 0.0,
// // //       lng: currentPosition.value?.longitude ?? 0.0,
// // //       status: 'off',
// // //     );
// // //   }
// // //
// // //   void _updateStatusInFirebase() {
// // //     _firebaseService.updateLocationStatus(
// // //       lat: currentPosition.value?.latitude ?? 0.0,
// // //       lng: currentPosition.value?.longitude ?? 0.0,
// // //       status: isServiceOn.value ? 'on' : 'off',
// // //     );
// // //   }
// // //
// // //   @override
// // //   void onClose() {
// // //     _locationTimer?.cancel();
// // //     super.onClose();
// // //   }
// // // }
// //
// //
// // import 'dart:async';
// // import 'package:get/get.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import '../../../data/services/firebase_service_driver.dart';
// // import '../../../core/constants/app_constants.dart';
// //
// // class DriverHomeController extends GetxController {
// //   final FirebaseServiceDriver _firebaseService = Get.find<FirebaseServiceDriver>();
// //
// //   var isServiceOn = false.obs;
// //   var currentPosition = Rxn<Position>();
// //
// //   GoogleMapController? mapController;
// //   StreamSubscription<Position>? _positionStream;
// //   Position? _lastUpdatedPosition;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _checkPermission();
// //   }
// //
// //   Future<void> _checkPermission() async {
// //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) return;
// //
// //     LocationPermission permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //     }
// //   }
// //
// //   void toggleService(bool value) {
// //     isServiceOn.value = value;
// //     if (isServiceOn.value) {
// //       _startLocationUpdates();
// //     } else {
// //       _stopLocationUpdates();
// //     }
// //   }
// //
// //   void _startLocationUpdates() {
// //     const locationSettings = LocationSettings(
// //       accuracy: LocationAccuracy.high,
// //       distanceFilter: 5, // 5 meters move hone par update karega
// //     );
// //
// //     _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
// //         .listen((Position position) {
// //       currentPosition.value = position;
// //
// //       // Map ko move karne ke liye
// //       _animateMap(position);
// //
// //       // Firebase sync logic
// //       _syncLocationWithFirebase(position);
// //     });
// //   }
// //
// //   void _animateMap(Position position) {
// //     mapController?.animateCamera(
// //       CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
// //     );
// //   }
// //
// //   void _syncLocationWithFirebase(Position position) {
// //     double distance = 0;
// //     if (_lastUpdatedPosition != null) {
// //       distance = Geolocator.distanceBetween(
// //         _lastUpdatedPosition!.latitude, _lastUpdatedPosition!.longitude,
// //         position.latitude, position.longitude,
// //       );
// //     }
// //
// //     if (_lastUpdatedPosition == null || distance >= 10) { // 10 meters threshold
// //       _lastUpdatedPosition = position;
// //       _firebaseService.updateLocationStatus(
// //         lat: position.latitude,
// //         lng: position.longitude,
// //         status: 'on',
// //       );
// //     }
// //   }
// //
// //   void _stopLocationUpdates() {
// //     _positionStream?.cancel();
// //     _firebaseService.updateLocationStatus(
// //       lat: currentPosition.value?.latitude ?? 0.0,
// //       lng: currentPosition.value?.longitude ?? 0.0,
// //       status: 'off',
// //     );
// //   }
// //
// //   @override
// //   void onClose() {
// //     _positionStream?.cancel();
// //     mapController?.dispose();
// //     super.onClose();
// //   }
// // }
//
// import 'dart:async';
// import 'package:flutter/material.dart'; // Colors ke liye zaroori hai
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../data/services/firebase_service_driver.dart';
//
// class DriverHomeController extends GetxController {
//   final FirebaseServiceDriver _service = FirebaseServiceDriver();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Islamabad default coordinates
//   final LatLng islamabadPos = const LatLng(33.6844, 73.0479);
//
//   var currentPosition = Rxn<LatLng>();
//   var selectIndex = 0.obs;
//   var isOnline = false.obs;
//   var vehicleType = 'Car'.obs;
//   var markers = <Marker>{}.obs;
//
//   StreamSubscription<Position>? _locationSubscription;
//   GoogleMapController? mapController;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // 1. Pehle Islamabad ka marker dikhao (Default)
//     _setInitialMarker();
//     // 2. Phir permission mango aur real location lo
//     _handlePermissionAndLocation();
//   }
//
//   // --- MASLA FIX: Permission aur Marker Logic ---
//   void _setInitialMarker() {
//     markers.add(
//       Marker(
//         markerId: const MarkerId("driver_initial"),
//         position: islamabadPos,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         infoWindow: const InfoWindow(title: "Starting Point (Islamabad)"),
//       ),
//     );
//   }
//
//   Future<void> _handlePermissionAndLocation() async {
//     LocationPermission permission;
//
//     // GPS on hai ya nahi check karein
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return;
//     }
//
//     // Permission check aur request
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission(); // Yahan popup aayega
//       if (permission == LocationPermission.denied) {
//         Get.snackbar("Permission", "Please allow location to see marker",
//             snackPosition: SnackPosition.BOTTOM);
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       await Geolocator.openAppSettings();
//       return;
//     }
//
//     // Real location lena
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     LatLng realPos = LatLng(position.latitude, position.longitude);
//
//     currentPosition.value = realPos;
//     _updateMarker(realPos); // Marker update karein
//     mapController?.animateCamera(CameraUpdate.newLatLngZoom(realPos, 15));
//   }
//
//   void _updateMarker(LatLng pos) {
//     markers.clear(); // Purana marker hatayein
//     markers.add(
//       Marker(
//         markerId: const MarkerId("driver_self"),
//         position: pos,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         infoWindow: const InfoWindow(title: "My Current Location"),
//       ),
//     );
//     markers.refresh();
//   }
//
//   void onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   void toggleOnlineStatus() {
//     isOnline.value = !isOnline.value;
//     if (isOnline.value) {
//       _startTracking();
//     } else {
//       _stopTracking();
//     }
//   }
//
//   void _startTracking() {
//     _locationSubscription = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
//     ).listen((Position position) {
//       LatLng pos = LatLng(position.latitude, position.longitude);
//       currentPosition.value = pos;
//       _updateMarker(pos);
//       mapController?.animateCamera(CameraUpdate.newLatLng(pos));
//       _sendDataToFirebase(position, "online");
//     });
//   }
//
//   void _sendDataToFirebase(Position pos, String status) {
//     String? uid = _auth.currentUser?.uid;
//     if (uid != null) {
//       _service.updateLocationStatus(
//         uid: uid,
//         lat: pos.latitude,
//         lng: pos.longitude,
//         status: status,
//         vehicleType: vehicleType.value,
//       );
//     }
//   }
//
//   void _stopTracking() {
//     _locationSubscription?.cancel();
//     if (currentPosition.value != null) {
//       _sendDataToFirebase(
//           Position(
//               latitude: currentPosition.value!.latitude,
//               longitude: currentPosition.value!.longitude,
//               timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0
//           ),
//           "offline"
//       );
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isOnline = false.obs;
  var currentPosition = Rxn<Position>();
  GoogleMapController? mapController;
  var markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)
    ).listen((Position position) {
      currentPosition.value = position;

      // Marker update karein jab bhi location badle
      _updateDriverMarker(position);

      if (isOnline.value) {
        _updateLocationInFirebase(position);
      }
    });
  }

  // --- Naya Function: Map par Marker dikhane ke liye ---
  void _updateDriverMarker(Position position) {
    markers.clear(); // Purana marker hatayein
    markers.add(
      Marker(
        markerId: const MarkerId("my_location"),
        position: LatLng(position.latitude, position.longitude),
        rotation: position.heading, // Car ki direction dikhane ke liye
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: "Your Location"),
      ),
    );
    markers.refresh(); // UI update karein
  }

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
    if (isOnline.value && currentPosition.value != null) {
      _updateLocationInFirebase(currentPosition.value!);
      _updateDriverMarker(currentPosition.value!); // Online hote hi marker refresh
    } else {
      // Offline hone par marker ka rang badal sakte hain ya hide kar sakte hain
      _firestore.collection('driver').doc(_auth.currentUser!.uid).update({'status': 'offline'});
    }
  }

  void _updateLocationInFirebase(Position position) {
    _firestore.collection('driver').doc(_auth.currentUser!.uid).set({
      'lat': position.latitude,
      'lng': position.longitude,
      'heading': position.heading,
      'status': 'online',
      'vehicleType': 'Car',
      'lastUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}