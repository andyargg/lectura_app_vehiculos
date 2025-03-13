import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/shared_models.dart';

class VehicleRepository {
  final FirebaseFirestore _firestore;

  VehicleRepository(this._firestore);

  Future<List<Vehicle>> readAll(String id) async {
    QuerySnapshot snapshot = await _firestore.collection('vehicles').get();

    return snapshot.docs.map((doc) => Vehicle.fromFirestore(doc)).toList(); 
  }
}