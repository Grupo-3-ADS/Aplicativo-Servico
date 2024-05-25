import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/service.dart';
import 'package:lista_tarefas/services/database_provider.dart';
import 'package:lista_tarefas/register_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  late DatabaseProvider database;
  List<Service> services = [];
  String userRole = '';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = await prefs.getInt('userId');
    userRole = await prefs.getString('userRole') ?? "";

    if (userRole == "Prestador") {
      database.getServices(userId).then((list) {
        setState(() {
          services = list;
        });
      });
    } else {
      database.getAllServices().then((list) {
        setState(() {
          services = list;
        });
      });
    }
  }

  void editService(int index) async {
    if (userRole == "Prestador") {
      Service service = services[index];
      Service? newService = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RegisterService(service: service, editIndex: index),
        ),
      );
      if (newService != null) {
        setState(() {
          services[index] = newService;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            userRole == "Prestador" ? 'Meus Serviços' : 'Serviços Disponíveis'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          Service service = services[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.purple),
            onDismissed: (direction) {
              if (userRole == "Prestador") {
                database.deleteService(service.id!);
                setState(() {
                  services.removeAt(index);
                });
              }
            },
            child: ListTile(
              leading: CircleAvatar(child: Text(index.toString())),
              title: Text('Serviço: ${service.nome}'),
              subtitle: Text(
                'Descrição: ${service.descricao} - '
                'Valor: ${service.valor} - '
                'Horário: ${service.horario} - '
                'Categoria: ${service.categoria} - '
                'Contato: ${service.contato}',
              ),
              onTap: userRole == "Prestador" ? () => editService(index) : null,
            ),
          );
        },
      ),
      floatingActionButton: userRole == "Prestador"
          ? FloatingActionButton(
              onPressed: () async {
                Service? newService = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterService()),
                );
                if (newService != null) {
                  setState(() {
                    services.add(newService);
                  });
                }
              },
              tooltip: 'Adicionar novo',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
