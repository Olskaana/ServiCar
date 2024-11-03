import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firestore_services.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle;

  AddEditVehicleScreen({this.vehicle});

  @override
  _AddEditVehicleScreenState createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  late String _name;
  late String _model;
  late int _year;

  @override
  void initState() {
    super.initState();
    _name = widget.vehicle?.name ?? '';
    _model = widget.vehicle?.model ?? '';
    _year = widget.vehicle?.year ?? 0;
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final vehicle = Vehicle(
        id: widget.vehicle?.id ?? '',
        name: _name,
        model: _model,
        year: _year,
      );
      if (widget.vehicle == null) {
        _firestoreService.addVehicle(vehicle);
      } else {
        _firestoreService.updateVehicle(vehicle);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Adicionar Veículo' : 'Editar Veículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                initialValue: _model,
                decoration: InputDecoration(labelText: 'Modelo'),
                onSaved: (value) => _model = value!,
                validator: (value) => value!.isEmpty ? 'Informe o modelo' : null,
              ),
              TextFormField(
                initialValue: _year.toString(),
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _year = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Informe o ano' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.vehicle == null ? 'Adicionar' : 'Salvar'),
                onPressed: _saveVehicle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
