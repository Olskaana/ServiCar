import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';
import '../models/service.dart';
import '../models/maintenance.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addVehicle(Vehicle vehicle) async {
    await _db.collection('vehicles').doc(vehicle.id).set(vehicle.toMap());
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _db.collection('vehicles').doc(vehicle.id).update(vehicle.toMap());
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _db.collection('vehicles').doc(vehicleId).delete();
  }

  Stream<List<Vehicle>> getVehicles() {
    return _db.collection('vehicles').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Vehicle.fromDocument(doc)).toList());

  }
  Future<Vehicle> getVehicleById(String vehicleId) async {
    try {
      DocumentSnapshot doc = await _db.collection('vehicles').doc(vehicleId).get();
      if (doc.exists) {
        return Vehicle.fromDocument(doc);
      } else {
        throw Exception('Veículo não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar veículo: $e');
    }
  }



// Métodos semelhantes para `Service` e `Maintenance`...

}
