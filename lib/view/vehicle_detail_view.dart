import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firestore_services.dart';
import 'add_edit_vehicle_view.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;
  final FirestoreService _firestoreService = FirestoreService();

  VehicleDetailScreen({required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Veículo'),
      ),
      body: FutureBuilder<Vehicle>(
        future: _firestoreService.getVehicleById(vehicleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Veículo não encontrado.'));
          }
          final vehicle = snapshot.data!;
          return Column(
            children: [
              ListTile(
                title: Text('Nome'),
                subtitle: Text(vehicle.name),
              ),
              ListTile(
                title: Text('Modelo'),
                subtitle: Text(vehicle.model),
              ),
              ListTile(
                title: Text('Ano'),
                subtitle: Text(vehicle.year.toString()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Editar'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditVehicleScreen(vehicle: vehicle),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Excluir'),
                    onPressed: () {
                      _firestoreService.deleteVehicle(vehicle.id);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
