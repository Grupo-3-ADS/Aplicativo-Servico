import 'package:flutter/material.dart';
import 'package:lista_tarefas/providers/user_provider.dart';
import 'package:lista_tarefas/register_service.dart';
import 'package:lista_tarefas/service_list.dart';
import 'package:lista_tarefas/utils/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Serviços',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          //'/': (context) => const Login(),
          '/register': (context) => const RegisterService(),
          '/list': (context) => const ServiceList(),
        },
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
