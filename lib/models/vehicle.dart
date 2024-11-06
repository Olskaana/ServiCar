import 'package:cloud_firestore/cloud_firestore.dart';

//Classe do veículo com propriedades e métodos para manipulação no firestore
class Vehicle {
  String id;
  String name;
  String model;
  int year;
  String? service;
  String? maintenance;
  bool isCompleted;

  //Construto da classe Vehicle
  Vehicle({
    required this.id,
    required this.name,
    required this.model,
    required this.year,
    this.service,
    this.maintenance,
    required this.isCompleted,
  });

  //Conversão da instância do veículo em mapa (facilitar o armazenamento no firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'year': year,
      'service': service,
      'maintenance': maintenance,
      'isCompleted': isCompleted,
      
    };
  }

  //Construtor de fábrica para criar uma instância de Vehicle a partir de um documento firestore
  factory Vehicle.fromDocument(DocumentSnapshot doc) {

    //Converção do snapshot do documento em um mapa de dados para acesso aos campos
    final data = doc.data() as Map<String, dynamic>;

    //Criação e retorno de uma instância de Vehicle a partir dos dados do firestore
    return Vehicle(
      id: doc.id,
      name: data['name'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      service: data['service'],
      maintenance: data['maintenance'],
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}
