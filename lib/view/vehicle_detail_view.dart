// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firestore_services.dart';
import 'add_edit_vehicle_view.dart';

//Tela dos detalhes do veículo
class VehicleDetailView extends StatefulWidget {
  final String vehicleId;

  VehicleDetailView({required this.vehicleId});

  @override
  _VehicleDetailViewState createState() => _VehicleDetailViewState();
}

class _VehicleDetailViewState extends State<VehicleDetailView> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<Vehicle> _vehicleFuture; //Variável para armazenar o futuro do veículo
  late Vehicle _vehicle; //Variável para armazenar o veículo após carregá-lo

  @override
  void initState() {
    super.initState();
    //Exibe na tela os dados do veículo com base no id
    _vehicleFuture = _firestoreService.getVehicleById(widget.vehicleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Veículo'),
      ),
      body: FutureBuilder<Vehicle>(
        //O futuro que carrega o veículo
        future: _vehicleFuture, 
        builder: (context, snapshot) {
          //Exibe um indicador de progresso enquanto os dados estão sendo carregados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          //Se não tiver dados, exibe uma mensagem de erro
          if (!snapshot.hasData) {
            return Center(child: Text('Veículo não encontrado.'));
          }
          //Quando os dados estão prontos, atribui o veículo à variável _vehicle
          _vehicle = snapshot.data!;
          return Column(
            children: [
              //Exibe os detalhes do veículo em uma lista
              ListTile(
                title: Text('Nome'),
                subtitle: Text(_vehicle.name),
              ),
              ListTile(
                title: Text('Modelo'),
                subtitle: Text(_vehicle.model),
              ),
              ListTile(
                title: Text('Ano'),
                subtitle: Text(_vehicle.year.toString()),
              ),
              ListTile(
                title: Text('Serviço necessário'),
                subtitle: Text(_vehicle.service.toString()),
              ),
              ListTile(
                title: Text('Manutenção necessária'),
                subtitle: Text(_vehicle.maintenance.toString()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Botão de edição
                  ElevatedButton(
                    child: Text('Editar'),
                    onPressed: () {
                      //Vai para a tela de edição do veículo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditVehicleView(vehicle: _vehicle),
                        ),
                      );
                    },
                  ),
                  //Botão de exclusão
                  ElevatedButton(
                    child: Text('Excluir'),
                    onPressed: () {
                      //Exclui o veículo
                      _firestoreService.deleteVehicle(_vehicle.id);
                      Navigator.pop(context);
                    },
                  ),
                  //Botão de marcar como completo/pendência
                  ElevatedButton(
                    child: Text(_vehicle.isCompleted ? 'Marcar Pendência' : 'Marcar Completo'),
                    onPressed: () {
                      //Altera o status para completo do carro
                      _vehicle.isCompleted = !_vehicle.isCompleted;
                      //Atualiza o veículo no firestore
                      _firestoreService.updateVehicle(_vehicle);
                      setState(() {
                        //Recarrega os dados do veículo após a atualização
                        _vehicleFuture = _firestoreService.getVehicleById(widget.vehicleId);
                      });
                      //Exibe uma mensagem com a ação realizada
                      final snackBar = SnackBar(
                        content: Text(_vehicle.isCompleted ? 'Serviço marcado como Completo.' : 'Serviço marcado como Pendente.'),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          onPressed: () {
                            //Desfazer a ação
                            _vehicle.isCompleted = !_vehicle.isCompleted;
                            //Reverte a atualização
                            _firestoreService.updateVehicle(_vehicle);
                            setState(() {
                              //Recarrega os dados
                              _vehicleFuture = _firestoreService.getVehicleById(widget.vehicleId);
                            });
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
