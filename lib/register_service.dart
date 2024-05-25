import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/service.dart';
import 'package:lista_tarefas/services/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Service> listService = [];

class RegisterService extends StatefulWidget {
  final Service? service;
  final int? editIndex;

  const RegisterService({Key? key, this.service, this.editIndex})
      : super(key: key);

  @override
  _RegisterServiceState createState() => _RegisterServiceState();
}

class _RegisterServiceState extends State<RegisterService> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  TextEditingController _horarioController = TextEditingController();
  TextEditingController _contatoController = TextEditingController();
  final List<String> _categorias = [
    'Manutenção de Hardware',
    'Instalação de Softwares',
    'Formatação'
  ];
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nomeController.text = widget.service!.nome ?? '';
      _descricaoController.text = widget.service!.descricao ?? '';
      _valorController.text = widget.service!.valor.toString();
      _horarioController.text = widget.service!.horario ?? '';
      _contatoController.text = widget.service!.contato ?? '';
      _categoriaSelecionada = widget.service!.categoria ?? _categorias.first;
    } else {
      _categoriaSelecionada = _categorias.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editIndex != null ? 'Editar Serviço' : 'Adicionar Serviço'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              sizeBox(height: 60), // Espaço extra para evitar sobreposição
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(33, 0, 33, 10),
          child: ElevatedButton(
            onPressed: () async {
              try {
                final dbProvider = DatabaseProvider();
                if (_nomeController.text.isEmpty ||
                    _descricaoController.text.isEmpty ||
                    _valorController.text.isEmpty ||
                    _horarioController.text.isEmpty ||
                    _contatoController.text.isEmpty ||
                    _categoriaSelecionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Por favor, preencha todos os campos')),
                  );
                  return;
                }

                SharedPreferences prefs = await SharedPreferences.getInstance();
                var userId = prefs.getInt('userId');
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao obter ID do usuário')),
                  );
                  return;
                }

                Service newService = Service(
                  widget.service?.id,
                  _nomeController.text,
                  _descricaoController.text,
                  double.tryParse(_valorController.text) ?? 0.0,
                  _horarioController.text,
                  _categoriaSelecionada!,
                  _contatoController.text,
                  userId,
                );

                if (widget.editIndex != null) {
                  if (widget.editIndex! < listService.length) {
                    await dbProvider.updateService(newService);
                    listService[widget.editIndex!] = newService;
                  } else {
                    print('Índice de edição inválido: ${widget.editIndex}');
                  }
                } else {
                  await dbProvider.saveService(newService);
                  listService.add(newService);
                }
                Navigator.pop(context);
              } catch (e) {
                print('Erro ao salvar serviço: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao salvar serviço')),
                );
              }
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

  Widget sizeBox({double height = 15}) {
    return SizedBox(
      height: height,
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
          icon: Icon(Icons.add),
        ),
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
          icon: Icon(Icons.description),
        ),
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
          icon: Icon(Icons.phone),
        ),
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
          icon: Icon(Icons.timelapse),
        ),
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
          icon: Icon(Icons.money),
        ),
      ),
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
