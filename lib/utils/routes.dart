import 'package:flutter/material.dart';
import 'package:lista_tarefas/register_task.dart';
import 'package:lista_tarefas/task_list.dart';

class Routes {
  static const String login = '/login';
  static const String client = '/client';
  static const String provider = '/provider';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
      //return MaterialPageRoute(builder: (_) => LoginScreen());
      case client:
        return MaterialPageRoute(builder: (_) => ServiceList());
      case provider:
      //return MaterialPageRoute(builder: (_) => ProviderList());
      default:
        return MaterialPageRoute(builder: (_) => RegisterService());
      //return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
