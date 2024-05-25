import 'package:flutter/material.dart';
import 'package:lista_tarefas/login.dart';
import 'package:lista_tarefas/providers/user_provider.dart';
import 'package:lista_tarefas/register_service.dart';
import 'package:lista_tarefas/service_list.dart';
import 'package:lista_tarefas/utils/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serviços',
      theme: ThemeData(
          primaryColor: Colors.green[600], // Cor base personalizada
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.green[400], // Personalizando a cor terciária
                secondary: Colors.green[200], // Personalizando a cor secundária
                tertiary: Colors.green[50],
              ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green[400],
          )),
      home: const LoginPage(),
      routes: {
        '/register': (context) => const RegisterService(),
        '/list': (context) => const ServiceList(),
      },
    );
  }
}
