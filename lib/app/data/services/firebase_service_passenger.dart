import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseServicePassenger extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of available drivers with status 'on'
  // Note: This requires a composite index or fetching and filtering if not using GeoFlutterFire
  // For simplicity, we filter in the stream if possible or use a collection group query if needed.
  // Actually, the user wants markers where location status is 'on'.

  Stream<List<Map<String, dynamic>>> getAvailableDrivers() {
    // This is a bit tricky with subcollections.
    // Ideally, for efficiency, location/status should be in the main doc or a separate 'online_drivers' collection.
    // Given the user's structure: driver -> location (subcollection), we might need to query location.
    // However, Firestore doesn't support querying across subcollections easily without Collection Group query.

    // For now, let's assume we use a Collection Group query for 'location' where status == 'on'.
    return _firestore
        .collectionGroup('location')
        .where('status', isEqualTo: 'on')
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> drivers = [];
          for (var doc in snapshot.docs) {
            // Get the parent driver doc ID
            String driverId = doc.reference.parent.parent!.id;
            var driverDoc = await _firestore
                .collection('drivers')
                .doc(driverId)
                .get();
            var vehicleDocs = await _firestore
                .collection('drivers')
                .doc(driverId)
                .collection('vehicle_data')
                .get();

            drivers.add({
              'driverId': driverId,
              'personal': driverDoc.data(),
              'location': doc.data(),
              'vehicles': vehicleDocs.docs.map((v) => v.data()).toList(),
            });
          }
          return drivers;
        });
  }
}
