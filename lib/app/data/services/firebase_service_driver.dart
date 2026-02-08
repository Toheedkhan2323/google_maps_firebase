import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseServiceDriver extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Driver Collection
  CollectionReference get _driverCollection => firestore.collection('drivers');

  // Register Driver
  Future<UserCredential?> registerDriver(String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    }
  }

  // Update Personal Profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String age,
  }) async {
    String uid = auth.currentUser!.uid;
    await _driverCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'age': age,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Update Location and Status
  Future<void> updateLocationStatus({
    required double lat,
    required double lng,
    required String status, required String vehicleType, required String uid,
  }) async {
    String uid = auth.currentUser!.uid;
    await _driverCollection.doc(uid).collection('location').doc('current').set({
      'lat': lat,
      'lng': lng,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Add Vehicle Data
  Future<void> addVehicleData({
    required String vehicleType,
    required String color,
    required String company,
    required String licenseNo,
  }) async {
    String uid = auth.currentUser!.uid;
    await _driverCollection.doc(uid).collection('vehicle_data').add({
      'type': vehicleType,
      'color': color,
      'company': company,
      'licenseNo': licenseNo,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get Driver Data
  Stream<DocumentSnapshot> getDriverProfile() {
    return _driverCollection.doc(auth.currentUser!.uid).snapshots();
  }

  // Get All Vehicles
  Stream<QuerySnapshot> getDriverVehicles() {
    return _driverCollection
        .doc(auth.currentUser!.uid)
        .collection('vehicle_data')
        .snapshots();
  }


}
