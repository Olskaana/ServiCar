// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firestore_services.dart';

//Tela de adição e edição do veículo
class AddEditVehicleView extends StatefulWidget {

  //Veículo que vai ser editado, se tiver
  final Vehicle? vehicle; 

  AddEditVehicleView({this.vehicle});

  @override
  _AddEditVehicleViewState createState() => _AddEditVehicleViewState();
}

class _AddEditVehicleViewState extends State<AddEditVehicleView> {
  final _formKey = GlobalKey<FormState>();
  //Instancia o serviço do firestore
  final FirestoreService _firestoreService = FirestoreService();
  late String _name;
  late String _model;
  late int _year;

  String? _selectedService;
  String? _selectedMaintenance;

  //Lista de serviços disponíveis
  final List<String> _services = [
    'Alinhamento de direção',
    'Aplicação de película protetora',
    'Instalação de acessórios (como faróis de LED, defletores)',
    'Instalação de alarmes e sistemas de segurança',
    'Instalação de engate de reboque',
    'Instalação de som automotivo',
    'Lavagem completa (exterior e interior)',
    'Limpeza de sistema de injeção',
    'Limpeza do sistema de ar-condicionado',
    'Manutenção e troca de lâmpadas',
    'Pintura',
    'Polimento',
    'Reparo de arranhões e amassados',
    'Reparo de estofados',
    'Revisão do sistema de escapamento',
    'Retoque',
    'Serviço de detalhamento (detailing)',
    'Substituição de para-brisas',
    'Substituição de rodas (de liga leve ou aço)',
    'Troca de óleo',
    'Troca de pneus',
    'Troca de pastilhas de freio',
    'Troca de fluídos de direção hidráulica',
    'Vitrificação de pintura',
    'Verificação de pneus (profundidade, bolhas, desgaste)',
    'Verificação de sistema de climatização (ar-condicionado e aquecimento)',
    'Descontaminação de pintura',
    'Tratamento de ferrugem',
    'Inspeção veicular'
  ];

  //Lista de manutenções disponíveis
  final List<String> _maintenances = [
    'Ajuste do ponto de ignição',
    'Arrumar motor',
    'Inspeção de freios (discos, tambores, fluído)',
    'Inspeção de mangueiras e correias (tensão e desgaste)',
    'Inspeção de pneus (profundidade, bolhas, desgaste)',
    'Inspeção do estado da bateria e do sistema de carga (alternador, regulador)',
    'Limpeza dos bicos injetores',
    'Manutenção do sistema elétrico',
    'Manutenção do sistema de escape (coletor, catalisador)',
    'Revisão do sistema de transmissão (manual ou automática)',
    'Substituição de elementos de fixação (parafusos, porcas, etc.)',
    'Troca de correia dentada',
    'Troca de fluído de arrefecimento',
    'Troca de óleo de transmissão',
    'Troca de pastilhas de freio',
    'Troca de filtros (óleo, ar, combustível, cabine)',
    'Troca de amortecedores',
    'Verificar e trocar fluido de freio',
    'Verificar e substituir bomba de combustível',
    'Verificar sistema de arrefecimento (radiador, mangueiras)',
    'Verificar sistema de direção (direção hidráulica ou elétrica)',
    'Verificação e manutenção do sistema de climatização (ar-condicionado e aquecimento)',
    'Verificação do funcionamento de luzes e sinais (faróis, lanternas)',
    'Verificação de sinistros e histórico de reparos',
    'Teste de compressão do motor',
    'Atualização de software de módulos eletrônicos'
  ];

  //Inicializa os dados do veículo ao carregar a tela, se um veículo for passado para edição
  @override
  void initState() {
    super.initState();

    //Se houver veículo, usa o nome, se não, usa uma string vazia
    _name = widget.vehicle?.name ?? '';
    //Se houver modelo, usa o modelo, se não, usa uma string vazia
    _model = widget.vehicle?.model ?? '';
    //Se houver veículo, usa o ano, se não, usa um 0
    _year = widget.vehicle?.year ?? 0;
  }

  //Função para salvar e editar o veículo no firestore
  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final vehicle = Vehicle(
        //Se for um veículo editado, se mantém o id, se não fica vazio
        id: widget.vehicle?.id ?? '',
        name: _name,
        model: _model,
        year: _year,
        service: _selectedService,
        maintenance: _selectedMaintenance,
        //Inicia com o veículo não completo
        isCompleted: false,
      );
      //Adiciona ou salva veículo no banco
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Campo para o nome do veículo
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    //Salva o valor
                    onSaved: (value) => _name = value!,
                    //Faz a validação 
                    validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                  ),
                ),
                SizedBox(height: 16),
                //Campo para o modelo do veículo
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    initialValue: _model,
                    decoration: InputDecoration(
                      labelText: 'Modelo',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    //Salva o valor
                    onSaved: (value) => _model = value!,
                    //Faz a validação
                    validator: (value) => value!.isEmpty ? 'Informe o modelo' : null,
                  ),
                ),
                SizedBox(height: 16),
                //Campo para o ano do veículo
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    initialValue: _year.toString(),
                    decoration: InputDecoration(
                      labelText: 'Ano',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    //Tipo de teclado que será exibido quando o usuário interagir com o campo de entrada 
                    keyboardType: TextInputType.number,
                    //Salva o valor que é convertido para INT
                    onSaved: (value) => _year = int.parse(value!),
                    //Faz a validação
                    validator: (value) => value!.isEmpty ? 'Informe o ano' : null,
                  ),
                ),
                SizedBox(height: 20),
                //Dropdown para selecionar o serviço
                Container(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Serviço'),
                    value: _selectedService,
                    isExpanded: true,
                    items: _services.map((service) {
                      return DropdownMenuItem(
                        value: service,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300), 
                          child: Text(service),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        //Atualiza o serviço que foi selecionado
                        _selectedService = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                //Dropdown para selecionar a manutenção
                Container(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Manutenção'),
                    value: _selectedMaintenance,
                    isExpanded: true,
                    items: _maintenances.map((maintenance) {
                      return DropdownMenuItem(
                        value: maintenance,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: Text(maintenance),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        //Atualiza a manutenção selecionada
                        _selectedMaintenance = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                //Botão para adionar ou salvar o veículo
                ElevatedButton(
                  onPressed: _saveVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                  ),
                  child: Text(widget.vehicle == null ? 'Adicionar' : 'Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
