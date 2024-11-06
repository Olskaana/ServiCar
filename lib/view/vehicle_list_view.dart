// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firestore_services.dart';
import 'add_edit_vehicle_view.dart';
import 'vehicle_detail_view.dart';

class VehicleListView extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veículos'),
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
          return ListView.separated(
            itemCount: vehicles.length,
            separatorBuilder: (context, index) => Divider(height: 2, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];

              Color cardColor = vehicle.isCompleted ? Colors.green[100]! : Colors.red[100]!;

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: cardColor,
                child: ListTile(
                  leading: Icon(
                    Icons.directions_car,
                    color: Color(0xFF1D3557),
                  ),
                  title: Text(vehicle.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text('Modelo: ${vehicle.model}', style: TextStyle(color: Colors.grey[700])),
                      Text('Ano: ${vehicle.year}', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailView(vehicleId: vehicle.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditVehicleView()),
          );
        },
        tooltip: 'Adicionar Veículo',
        backgroundColor: Color(0xFFFFB703),
        child: Icon(Icons.add),
      ),
    );
  }
}
