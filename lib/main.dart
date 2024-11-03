import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/vehicle_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Manutenção de Veículos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VehicleListScreen(), // Tela inicial
    );
  }
}
