// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../../data/services/firebase_service_passenger.dart';
// import '../../../core/constants/app_constants.dart';
//
// class PassengerHomeController extends GetxController {
//   final FirebaseServicePassenger _firebaseService =
//       Get.find<FirebaseServicePassenger>();
//
//   var availableDrivers = <Map<String, dynamic>>[].obs;
//   var filteredDrivers = <Map<String, dynamic>>[].obs;
//   var markers = <Marker>{}.obs;
//   var selectedFilter = 'All'.obs;
//   var userPosition = Rxn<Position>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _getUserLocation();
//     _listenToDrivers();
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition();
//     userPosition.value = position;
//   }
//
//   void _listenToDrivers() {
//     _firebaseService.getAvailableDrivers().listen((drivers) {
//       availableDrivers.value = drivers;
//       applyFilter(selectedFilter.value);
//     });
//   }
//
//   void applyFilter(String filter) {
//     selectedFilter.value = filter;
//
//     // Filter by Radius (100m) AND Vehicle Type
//     filteredDrivers.value = availableDrivers.where((d) {
//       // 1. Check Distance
//       if (userPosition.value == null)
//         return true; // Show all if user position unknown? Or empty?
//       // User said: "user k 100 meters k radius men koi driver avaible hogaa to tabhi usko waha riders show hon gy"
//
//       var loc = d['location'];
//       double distance = Geolocator.distanceBetween(
//         userPosition.value!.latitude,
//         userPosition.value!.longitude,
//         loc['lat'],
//         loc['lng'],
//       );
//
//       bool isWithinRadius =
//           distance <= AppConstants.passengerSearchRadiusMeters;
//       if (!isWithinRadius) return false;
//
//       // 2. Check Vehicle Type
//       if (filter == 'All') return true;
//       List vehicles = d['vehicles'] ?? [];
//       return vehicles.any((v) => v['type'] == filter);
//     }).toList();
//
//     _updateMarkers();
//   }
//
//   void _updateMarkers() {
//     markers.clear();
//     for (var driver in filteredDrivers) {
//       var loc = driver['location'];
//       var vehicles = driver['vehicles'] as List;
//
//       String vehicleType = vehicles.isNotEmpty ? vehicles[0]['type'] : 'Car';
//
//       markers.add(
//         Marker(
//           markerId: MarkerId(driver['driverId']),
//           position: LatLng(loc['lat'], loc['lng']),
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             vehicleType == 'Bike'
//                 ? BitmapDescriptor.hueBlue
//                 : vehicleType == 'Rickshaw'
//                 ? BitmapDescriptor.hueOrange
//                 : BitmapDescriptor.hueRed,
//           ),
//           onTap: () => _showDriverDetails(driver),
//         ),
//       );
//     }
//   }
//
//   void _showDriverDetails(Map<String, dynamic> driver) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Driver: ${driver['personal']['name']}",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text("Phone: ${driver['personal']['phone']}"),
//             const Divider(),
//             const Text(
//               "Vehicles:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             ...(driver['vehicles'] as List).map(
//               (v) => Text("${v['type']} - ${v['company']} (${v['color']})"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class UserController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   var selectIndex = 0.obs;
//   var currentPosition = const LatLng(33.6844, 73.0479).obs;
//   var markers = <Marker>{}.obs;
//   var selectedVehicle = "All".obs;
//
//   BitmapDescriptor? carIcon;
//   BitmapDescriptor? bikeIcon;
//   BitmapDescriptor? rickshawIcon;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadIcons();
//   }
//
//   Future<void> _loadIcons() async {
//     try {
//       // Configuration size thora bara rakha hai taake nazar aaye
//       carIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(100, 100)), 'assets/sport-car.png');
//       bikeIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(100, 100)), 'assets/bicycle.png');
//       rickshawIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(100, 100)), 'assets/tricycle.png');
//     } catch (e) {
//       print("Error loading icons: $e");
//     }
//     _setupDriverStream(); // Icons load hon ya na hon, stream lazmi chalani hai
//   }
//
//   void _setupDriverStream() {
//     // Note: .snapshots() real-time listener hai, filter change par ye khud update hoga
//     _firestore.collection('driver')
//         .where('status', isEqualTo: 'online')
//         .snapshots()
//         .listen((snapshot) {
//       _updateMarkers(snapshot.docs);
//     });
//   }
//
//   void _updateMarkers(List<DocumentSnapshot<Map<String, dynamic>>> docs) {
//     var newMarkers = <Marker>{};
//
//     for (var doc in docs) {
//       var data = doc.data()!;
//       String vType = data['vehicleType'] ?? 'Car';
//       double lat = data['lat'] ?? 0.0;
//       double lng = data['lng'] ?? 0.0;
//
//       if (selectedVehicle.value == "All" || vType == selectedVehicle.value) {
//         newMarkers.add(
//           Marker(
//             markerId: MarkerId(doc.id),
//             position: LatLng(lat, lng),
//             icon: _getCorrectIcon(vType), // Yahan icon check hoga
//             infoWindow: InfoWindow(title: "$vType Driver"),
//           ),
//         );
//       }
//     }
//     markers.value = newMarkers; // assignAll ki jagah direct value update karein
//     markers.refresh(); // Forcefully UI update
//   }
//
//   BitmapDescriptor _getCorrectIcon(String type) {
//     if (type == 'Bike' && bikeIcon != null) return bikeIcon!;
//     if (type == 'Rickshaw' && rickshawIcon != null) return rickshawIcon!;
//     if (type == 'Car' && carIcon != null) return carIcon!;
//
//     // Agar icon abhi load nahi hua toh default red marker
//     return BitmapDescriptor.defaultMarker;
//   }
//
//   void updateFilter(String type) {
//     selectedVehicle.value = type;
//
//     // Sirf stream ko refresh karne ke liye dobara fetch karne ki logic
//     _firestore.collection('driver')
//         .where('status', isEqualTo: 'online')
//         .get()
//         .then((snapshot) => _updateMarkers(snapshot.docs));
//
//     Get.back();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController extends GetxController {
  GoogleMapController? mapController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String mapsApiKey = "AIzaSyA11c06EwJ7SahxA5FvRF2-_rgI0TPZDwo";
  final String placesApiKey = "AIzaSyDJLHhKn8tpu8yqaOjSzIxfWnjnpm_5Tzo";

  var selectIndex = 0.obs;
  var currentPosition = const LatLng(33.6844, 73.0479).obs;
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;
  var selectedVehicle = "All".obs;
  var searchPredictions = <dynamic>[].obs;
  var isRideRequested = false.obs;

  // New Ride Variables
  var currentRideId = "".obs;
  var rideStatus = "".obs;
  var driverDetails = {}.obs;
  StreamSubscription<DocumentSnapshot>? _rideSubscription;

  BitmapDescriptor? carIcon;
  BitmapDescriptor? bikeIcon;
  BitmapDescriptor? rickshawIcon;
  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1. Load icons FIRST
    await _loadIcons();
    // 2. Add user marker
    _addUserMarker();
    // 3. Only AFTER icons are ready → start listening to drivers
    _setupDriverStream();
  }

  Future<BitmapDescriptor> _getResizedIcon(String path, int width) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
      return BitmapDescriptor.fromBytes(bytes);
    } catch (e) {
      print("Failed to load icon $path → $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> _loadIcons() async {
    carIcon = await _getResizedIcon('assets/sport-car.png', 100);
    bikeIcon = await _getResizedIcon('assets/bicycle.png', 90);
    rickshawIcon = await _getResizedIcon('assets/tricycle.png', 100);
  }

  BitmapDescriptor _getCorrectIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bike':
        return bikeIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'rickshaw':
        return rickshawIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'car':
      default:
        return carIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  void _addUserMarker() {
    markers.add(Marker(
      markerId: const MarkerId("user_location"),
      position: currentPosition.value,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: "You are here"),
    ));
  }

  void _setupDriverStream() {
    _firestore
        .collection('driver')
        .where('status', isEqualTo: 'online')
        .snapshots()
        .listen((snapshot) {
      _refreshMarkers(snapshot.docs);
    });
  }

  void _refreshMarkers(List<DocumentSnapshot<Map<String, dynamic>>> docs) {
    final newMarkers = <Marker>{};

    // Always keep user marker
    newMarkers.add(Marker(
      markerId: const MarkerId("user_location"),
      position: currentPosition.value,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));

    for (var doc in docs) {
      final data = doc.data()!;
      final vType = (data['vehicleType'] as String?)?.trim() ?? 'Car';

      // Apply current filter
      if (selectedVehicle.value == "All" || vType == selectedVehicle.value) {
        final lat = (data['lat'] as num?)?.toDouble() ?? 0.0;
        final lng = (data['lng'] as num?)?.toDouble() ?? 0.0;

        newMarkers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          icon: _getCorrectIcon(vType),
          anchor: const Offset(0.5, 0.5),
          rotation: (data['heading'] as num?)?.toDouble() ?? 0.0,
          infoWindow: InfoWindow(title: "$vType Driver"),
        ));
      }
    }

    markers.assignAll(newMarkers);
  }

  void updateFilter(String type) {
    selectedVehicle.value = type;
    // Force immediate refresh with current data
    _firestore
        .collection('driver')
        .where('status', isEqualTo: 'online')
        .get()
        .then((snap) => _refreshMarkers(snap.docs));

    Get.back(); // close bottom sheet if open
  }

  // ────────────────────────────────────────────────
  // Search & Route logic (unchanged but included for completeness)
  // ────────────────────────────────────────────────

  Future<void> searchLocation(String query) async {
    if (query.trim().isEmpty) {
      searchPredictions.clear();
      return;
    }
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$placesApiKey";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        searchPredictions.value = json.decode(res.body)['predictions'] ?? [];
      }
    } catch (e) {
      print("Place autocomplete error: $e");
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$placesApiKey";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final result = json.decode(res.body)['result'];
        final loc = result['geometry']['location'];
        final dest = LatLng(loc['lat'], loc['lng']);
        await drawRoute(dest);
        searchPredictions.clear();
      }
    } catch (e) {
      print("Place details error: $e");
    }
  }

  Future<void> drawRoute(LatLng destination) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${currentPosition.value.latitude},${currentPosition.value.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "OK") {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polyPoints = _decodePoly(points);

          polylines.assign(Polyline(
            polylineId: const PolylineId("route"),
            points: polyPoints,
            color: Colors.blueAccent,
            width: 6,
          ));

          markers.add(Marker(
            markerId: const MarkerId("destination"),
            position: destination,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));

          markers.refresh();
        }
      }
    } catch (e) {
      print("Directions error: $e");
    }
  }

  List<LatLng> _decodePoly(String poly) {
    // your existing polyline decode logic
    var list = poly.codeUnits;
    var lList = <double>[];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) result = ~result;
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    final res = <LatLng>[];
    for (var i = 0; i < lList.length; i += 2) {
      res.add(LatLng(lList[i], lList[i + 1]));
    }
    return res;
  }

  // --- PASSENGER RIDE LOGIC ---

  Future<void> requestRide() async {
    if (currentPosition.value == null) {
      Get.snackbar("Error", "Location not available");
      return;
    }

    // 1. Prepare Data
    var pickup = {
      "lat": currentPosition.value.latitude,
      "lng": currentPosition.value.longitude,
      "address": "Current Location"
    };

    var dropoff = {"lat": 0.0, "lng": 0.0, "address": "Select Destination"};

    // Agar destination selected hai to use karein
    if (markers.any((m) => m.markerId.value == "destination")) {
      var destMarker =
          markers.firstWhere((m) => m.markerId.value == "destination");
      dropoff = {
        "lat": destMarker.position.latitude,
        "lng": destMarker.position.longitude,
        "address": "Destination"
      };
    } else {
      Get.snackbar("Alert", "Please select a destination first.");
      return;
    }

    try {
      DocumentReference docRef = await _firestore.collection('requests').add({
        'userId': _auth.currentUser?.uid,
        'userName': _auth.currentUser?.displayName ?? "Passenger",
        'pickup': pickup,
        'dropoff': dropoff,
        'status': 'searching',
        'createdAt': FieldValue.serverTimestamp(),
        'vehicleType': selectedVehicle.value,
        'fare': '250',
      });

      currentRideId.value = docRef.id;
      isRideRequested.value = true;
      rideStatus.value = "searching";

      _listenToRideStatus(docRef.id);

      Get.snackbar("Success", "Ride Requested! Waiting for driver...");
    } catch (e) {
      Get.snackbar("Error", "Failed to request ride: $e");
    }
  }

  void _listenToRideStatus(String requestId) {
    _rideSubscription = _firestore
        .collection('requests')
        .doc(requestId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        String newStatus = data?['status'] ?? "searching";
        rideStatus.value = newStatus;

        if (newStatus == "accepted") {
          driverDetails.value = data?['driver'] ?? {};
          Get.snackbar("Ride Accepted", "Driver is on the way!");
        }
      }
    });
  }

  Future<void> cancelRide() async {
    if (currentRideId.value.isEmpty) return;

    try {
      await _firestore.collection('requests').doc(currentRideId.value).delete();
      isRideRequested.value = false;
      rideStatus.value = "";
      driverDetails.clear();
      _rideSubscription?.cancel();
      Get.snackbar("Cancelled", "Ride request cancelled.");
    } catch (e) {
      Get.snackbar("Error", "Failed to cancel ride.");
    }
  }

  @override
  void onClose() {
    _rideSubscription?.cancel();
    super.onClose();
  }
}
