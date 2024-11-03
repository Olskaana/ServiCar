import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  String id;
  String vehicleId;
  String serviceId;
  DateTime date;
  String notes;

  Maintenance({required this.id, required this.vehicleId, required this.serviceId, required this.date, required this.notes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'serviceId': serviceId,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Maintenance.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Maintenance(
      id: doc.id,
      vehicleId: data['vehicleId'],
      serviceId: data['serviceId'],
      date: DateTime.parse(data['date']),
      notes: data['notes'],
    );
  }
}
