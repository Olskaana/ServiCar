// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/vehicle_list_view.dart';
import 'firebase_options.dart';

void main() async {

  //Garante a inicialização correta dos widgets Flutter antes de configurar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  //Inicializa o firebase na plataforma atual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Maintenance Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1D3557),
        hintColor: Color(0xFFFFB703),
        scaffoldBackgroundColor: Color(0xFFF1FAEE),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1D3557),
          titleTextStyle: TextStyle(
            color: Colors.white, 
            fontSize: 20, fontWeight: 
            FontWeight.bold
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFFB703),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: VehicleListView(), //Tela que inicia o aplicativo
    );
  }
}
