import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firestore_services.dart';
import 'add_edit_vehicle_view.dart';
import 'vehicle_detail_view.dart';

class VehicleListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Veículos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditVehicleScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Vehicle>>(
        stream: _firestoreService.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum veículo encontrado.'));
          }
          final vehicles = snapshot.data!;
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle.name),
                subtitle: Text(vehicle.model),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailScreen(vehicleId: vehicle.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
