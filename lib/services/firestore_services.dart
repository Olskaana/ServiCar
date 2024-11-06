import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

//Classe que vai gerenciar a interação com o firestore entre veículos, manutenção e serviços
class FirestoreService {

  //Instancia o firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Adicionar um novo veículo ao banco
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      DocumentReference ref = await _db.collection('vehicles').add(vehicle.toMap());
      //Armazena o id gerado automaticamente pelo Firestore
      vehicle.id = ref.id;
    } catch (e) {
      throw Exception('Erro ao adicionar veículo: $e');
    }
  }

  //Atualiza um veículo existente no banco com base no id
  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _db.collection('vehicles').doc(vehicle.id).update(vehicle.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar veículo: $e');
    }
  }

  //Exclui um veículo do banco com base no id
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _db.collection('vehicles').doc(vehicleId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir veículo: $e');
    }
  }

  //Retorna em tempo real a lista de veículos
  Stream<List<Vehicle>> getVehicles() {
    return _db.collection('vehicles').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Vehicle.fromDocument(doc)).toList());
  }

  //Faz uma busca específica de um veículo pelo seu id
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

}
