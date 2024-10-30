import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String id;
  String name;
  String model;
  int year;

  Vehicle({required this.id, required this.name, required this.model, required this.year});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'year': year,
    };
  }

  factory Vehicle.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      id: doc.id,
      name: data['name'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
    );
  }
}
