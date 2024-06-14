import 'package:flutter/material.dart';
import 'package:services/login.dart';
import 'package:services/main.dart';
import 'package:services/models/service.dart';
import 'package:services/services/database_provider.dart';
import 'package:services/register_service.dart';
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
    database = DatabaseProvider();
    _getAllServices();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllServices();
  }

  void editService(int index) async {
    if (userRole != "Prestador") {
      return;
    }
    Service service = services[index];
    Service? newService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterService(
          service: service,
          editIndex: index,
          updateServices: (List<Service> updatedServices) {
            setState(() {
              services = updatedServices;
              _getAllServices();
            });
          },
        ),
      ),
    );
    if (newService != null) {
      setState(() {
        services[index] = newService;
        _getAllServices();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userRole == "Prestador" ? 'Meus Serviços' : 'Serviços Disponíveis'),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          Service service = services[index];
          return userRole == "Prestador"
              ? Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Theme.of(context).colorScheme.secondary),
                  onDismissed: (direction) {
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
                    title: Text('Serviço: ${service.nome}'),
                    subtitle: Text(
                      'Descrição: ${service.descricao} - '
                      'Valor: ${service.valor} - '
                      'Horário: ${service.horario} - '
                      'Categoria: ${service.categoria} - '
                      'Contato: ${service.contato}',
                    ),
                    onTap: () => editService(index),
                  ),
                )
              : ListTile(
                  leading: CircleAvatar(
                    child: Text(index.toString()),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('Serviço: ${service.nome}'),
                  subtitle: Text(
                    'Descrição: ${service.descricao} - '
                    'Valor: ${service.valor} - '
                    'Horário: ${service.horario} - '
                    'Categoria: ${service.categoria} - '
                    'Contato: ${service.contato}',
                  ),
                );
        },
      ),
      floatingActionButton: Stack(
        children: [
          if (userRole == "Prestador")
            Positioned(
              bottom: 16,
              right: 15,
              child: FloatingActionButton(
                heroTag: 'add_service',  // Define um tag único
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
                  _getAllServices();
                },
                tooltip: 'Adicionar novo',
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 50,
            child: FloatingActionButton(
              heroTag: 'logout',  // Define um tag único
              onPressed: () {
                _logout();
              },
              tooltip: 'Logout',
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
