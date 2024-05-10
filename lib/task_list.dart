import 'package:flutter/material.dart';
import 'package:lista_tarefas/model.dart';
import 'package:lista_tarefas/register_task.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  late DatabaseProvider database;
  List<dynamic> services = [];

  @override
  void initState() {
    super.initState();
    database = DatabaseProvider();
    _getAllServices();
  }

  void _getAllServices() {
    database.getAllServices().then((list) {
      setState(() {
        services = list;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllServices();
  }

  void editService(int index) async {
    Service service = services[index];
    Service? newService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterService(service: service, editIndex: index),
      ),
    );
    if (newService != null) {
      setState(() {
        services[index] = newService;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SERVIÇOS'),
      ),
      body: ListView.builder(
          itemCount: services.length,
          itemBuilder: (BuildContext context, int index) {
            String nome = services[index].nome;
            String descricao = services[index].descricao;
            double valor = services[index].valor;
            String horario = services[index].horario;
            String categoria = services[index].categoria;
            return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.purple),
                onDismissed: (direction) {
                  Service service = services[index];
                  database.deleteService(service.id!);
                  setState(() {
                    services.removeAt(index);
                  });
                },
                child: ListTile(
                  leading: CircleAvatar(child: Text(index.toString())),
                  title: (Text('Serviço: $nome')),
                  subtitle: Text('Descrição: $descricao' + ' - ' + ' Valor: $valor'),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/register');
        },
        tooltip: 'Adicionar novo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
