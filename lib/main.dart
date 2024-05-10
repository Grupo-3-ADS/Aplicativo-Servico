import 'package:flutter/material.dart';
import 'package:lista_tarefas/register_task.dart';
import 'package:lista_tarefas/task_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serviços',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Lista de Tarefas'),
      routes: {
        '/register': (context) => const RegisterService(),
        '/list': (context) => const ServiceList(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nome do usuário aqui'),
              accountEmail: Text('email@usuario.com'),
              currentAccountPicture: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('../assets/images/1.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Adicionar Tarefa'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Listar Tarefas'),
              onTap: () {
                Navigator.pushNamed(context, '/list');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem-vindo à sua lista de tarefas!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Adicionar Tarefa'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              child: const Text('Listar Tarefas'),
            ),
          ],
        ),
      ),
    );
  }
}
