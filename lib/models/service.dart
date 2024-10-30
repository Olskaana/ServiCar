import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String id;
  String vehicleId;
  String description;
  DateTime date;
  double cost;

  Service({required this.id, required this.vehicleId, required this.description, required this.date, required this.cost});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'description': description,
      'date': date.toIso8601String(),
      'cost': cost,
    };
  }

  factory Service.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Service(
      id: doc.id,
      vehicleId: data['vehicleId'],
      description: data['description'],
      date: DateTime.parse(data['date']),
      cost: data['cost'],
    );
  }
}
