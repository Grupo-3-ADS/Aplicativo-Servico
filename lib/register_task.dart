import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/model.dart';
import 'package:table_calendar/table_calendar.dart';

List<Service> listService = [];

class RegisterService extends StatefulWidget {
  final Service? service;
  final int? editIndex;

  const RegisterService({Key? key, this.service, this.editIndex}) : super(key: key);

  @override
  _RegisterServiceState createState() => _RegisterServiceState();
}

class _RegisterServiceState extends State<RegisterService> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  TextEditingController _horarioController = TextEditingController();
  TextEditingController _contatoController = TextEditingController();
  final List<String> _categorias = ['Manutenção de Hardware', 'Instalação de Softwares', 'Formatação'];
  String? _categoriaSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editIndex != null ? 'Editar Serviço' : 'Adicionar Serviço'),
      ),
      body: SingleChildScrollView(
        // Adiciona um SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sizeBox(),
              serviceNome(),
              sizeBox(),
              serviceDescricao(),
              sizeBox(),
              serviceValor(),
              sizeBox(),
              serviceHorario(),
              sizeBox(),
              serviceCategoria(),
              sizeBox(),
              serviceContato(),
              sizeBox()
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(33, 0, 0, 10),
          child: ElevatedButton(
            onPressed: () async {
              final dbProvider = DatabaseProvider();
              if (widget.editIndex != null) {
                Service newService = Service(
                  widget.service!.id,
                  _nomeController.text,
                  _descricaoController.text,
                  double.tryParse(_valorController.text) ?? 0.0,
                  _horarioController.text,
                  _categoriaSelecionada,
                  _contatoController.text
                );
                await dbProvider.updateService(newService);
                listService[widget.editIndex!] = newService;
              } else {
                Service newService = Service(
                  null,
                  _nomeController.text,
                  _descricaoController.text,
                  double.tryParse(_valorController.text) ?? 0.0,
                  _horarioController.text,
                  _categoriaSelecionada,
                  _contatoController.text
                );
                await dbProvider.saveService(newService);
                listService.add(newService);
              }
              Navigator.pop(context); // Retorna para a tela anterior
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            child: Text(widget.editIndex != null ? 'Salvar' : 'Adicionar'),
          ),
        ),
      ),
    );
  }

  Widget sizeBox() {
    return SizedBox(
      height: 15,
    );
  }

  Widget serviceNome() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _nomeController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome',
            icon: Icon(Icons.add)),
      ),
    );
  }

  Widget serviceDescricao() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _descricaoController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Descrição',
            icon: Icon(Icons.description)),
      ),
    );
  }

  Widget serviceContato() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _contatoController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Contato',
            icon: Icon(Icons.phone)),
      ),
    );
  }

  Widget serviceHorario() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _horarioController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Horário',
            icon: Icon(Icons.timelapse)),
      ),
    );
  }

  Widget serviceValor() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _valorController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Valor',
          icon: Icon(Icons.money)
        ),
      )
    );
  }

  Widget serviceCategoria() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: DropdownButtonFormField<String>(
        value: _categoriaSelecionada,
        onChanged: (String? newValue) {
          setState(() {
            _categoriaSelecionada = newValue;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Categoria',
          icon: Icon(Icons.category),
        ),
        items: _categorias.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
