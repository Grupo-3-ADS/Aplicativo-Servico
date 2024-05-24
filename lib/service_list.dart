import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/service.dart';
import 'package:lista_tarefas/services/database_provider.dart';
import 'package:lista_tarefas/register_service.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  late DatabaseProvider database;
  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    database = DatabaseProvider();
    await _getAllServices();
  }

  Future<void> _getAllServices() async {
    List<Service> list = await database.getAllServices();
    setState(() {
      services = list;
    });
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _getAllServices();
  }

  void editService(int index) async {
    Service service = services[index];
    Service? newService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterService(
          service: service, 
          editIndex: index,
          updateServices: (List<Service> updatedServices){
            setState(() {
              services = updatedServices;
              _getAllServices();
            });
          }),
      ),
    );
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
            String nome = services[index].nome ?? '';
            String descricao = services[index].descricao ?? '';
            double valor = services[index].valor ?? 0.0;
            String horario = services[index].horario ?? '';
            String categoria = services[index].categoria ?? '';
            String contato = services[index].contato ?? '';
            return Dismissible(
                key: UniqueKey(),
                background:
                    Container(color: Theme.of(context).colorScheme.tertiary),
                onDismissed: (direction) {
                  Service service = services[index];
                  database.deleteService(service.id!);
                  setState(() {
                    services.removeAt(index);
                  });
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(index.toString()),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  title: (Text('Servico: $nome')),
                  subtitle: Text('$descricao - Valor: $valor - Horário: $horario - Categoria: $categoria - Contato: $contato'),
                  onTap: () {
                    editService(index);
                  },
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterService()))
              .then((value) => _getAllServices());
        },
        tooltip: 'Adicionar novo',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
