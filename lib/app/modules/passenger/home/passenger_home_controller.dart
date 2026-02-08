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
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController extends GetxController {
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

  // Icons loading state track karne ke liye
  var isIconsLoaded = false.obs;
  BitmapDescriptor? carIcon, bikeIcon, rickshawIcon;

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    await _loadIcons();
    _addUserMarker();
    _setupDriverStream();
  }

  Future<BitmapDescriptor> _getResizedIcon(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _loadIcons() async {
    try {
      carIcon = await _getResizedIcon('assets/sport-car.png', 110);
      bikeIcon = await _getResizedIcon('assets/bicycle.png', 90);
      rickshawIcon = await _getResizedIcon('assets/tricycle.png', 100);
      isIconsLoaded.value = true;
      // Icons load hone ke baad ek baar markers refresh karein
      markers.refresh();
    } catch (e) {
      print("Error loading icons: $e");
    }
  }

  // --- ICON SELECTION LOGIC FIXED ---
  BitmapDescriptor _getCorrectIcon(String type) {
    if (type == 'Bike') {
      return bikeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else if (type == 'Rickshaw') {
      return rickshawIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else {
      // Default Car show hogi agar kuch na mile
      return carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  void _addUserMarker() {
    markers.add(Marker(
      markerId: const MarkerId("user_location"),
      position: currentPosition.value,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));
  }

  void _setupDriverStream() {
    _firestore.collection('driver').where('status', isEqualTo: 'online').snapshots().listen((snapshot) {
      _refreshMarkers(snapshot.docs);
    });
  }

  // UserController mein refreshMarkers ko aise update karein
  void _refreshMarkers(List<DocumentSnapshot<Map<String, dynamic>>> docs) {
    var newMarkers = <Marker>{};

    // User Marker
    newMarkers.add(Marker(
      markerId: const MarkerId("user_location"),
      position: currentPosition.value,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));

    // Multiple Drivers Loop
    for (var doc in docs) {
      var data = doc.data()!;
      String vType = data['vehicleType'] ?? 'Car';

      if (selectedVehicle.value == "All" || vType == selectedVehicle.value) {
        newMarkers.add(Marker(
          markerId: MarkerId(doc.id), // Firebase ID use karein taake multiple drivers dikhein
          position: LatLng((data['lat'] as num).toDouble(), (data['lng'] as num).toDouble()),
          icon: _getCorrectIcon(vType),
          anchor: const Offset(0.5, 0.5),
          rotation: (data['heading'] ?? 0.0).toDouble(),
        ));
      }
    }
    markers.assignAll(newMarkers);
  }

  // --- UPDATE FILTER FIXED ---
  void updateFilter(String type) {
    selectedVehicle.value = type;

    // Foran markers update karein bina database change ka wait kiye
    _firestore.collection('driver').where('status', isEqualTo: 'online').get().then((snap) {
      _refreshMarkers(snap.docs);
    });

    if (Get.isBottomSheetOpen ?? false) Get.back();
  }

  // --- SEARCH & ROUTE ---
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) { searchPredictions.clear(); return; }
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$placesApiKey";
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      searchPredictions.value = json.decode(res.body)['predictions'];
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$placesApiKey";
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var result = json.decode(res.body)['result'];
      LatLng dest = LatLng(result['geometry']['location']['lat'], result['geometry']['location']['lng']);
      await drawRoute(dest);
      searchPredictions.clear();
    }
  }

  Future<void> drawRoute(LatLng destination) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${currentPosition.value.latitude},${currentPosition.value.longitude}&destination=${destination.latitude},${destination.longitude}&key=$placesApiKey";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == "OK") {
        String encodedPoints = data['routes'][0]['overview_polyline']['points'];
        List<LatLng> polylinePoints = _decodePoly(encodedPoints);

        polylines.assign(Polyline(
          polylineId: const PolylineId("route"),
          points: polylinePoints,
          color: Colors.green,
          width: 5,
        ));

        markers.add(Marker(
          markerId: const MarkerId("destination"),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
        markers.refresh();
      }
    }
  }

  List<LatLng> _decodePoly(String poly) {
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

    List<LatLng> res = <LatLng>[];
    for (var i = 0; i < lList.length; i += 2) {
      res.add(LatLng(lList[i], lList[i + 1]));
    }
    return res;
  }

  Future<void> requestRide(String fare) async {
    if (fare.isEmpty) { Get.snackbar("Fare", "Please enter fare"); return; }
    if (!markers.any((m) => m.markerId.value == "destination")) {
      Get.snackbar("Error", "Please select destination first");
      return;
    }
    var dest = markers.firstWhere((m) => m.markerId.value == "destination");
    try {
      await _firestore.collection('ride_requests').add({
        'userId': _auth.currentUser?.uid ?? "anonymous",
        'pickup_lat': currentPosition.value.latitude,
        'pickup_lng': currentPosition.value.longitude,
        'dest_lat': dest.position.latitude,
        'dest_lng': dest.position.longitude,
        'fare': fare,
        'status': 'pending',
        'vehicle': selectedVehicle.value,
        'time': FieldValue.serverTimestamp(),
      });
      isRideRequested.value = true;
    } catch (e) { print("Request error: $e"); }
  }
}