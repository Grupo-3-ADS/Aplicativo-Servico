import 'package:flutter/material.dart';
import 'package:lista_tarefas/register_service.dart';
import 'package:lista_tarefas/service_list.dart';

class Routes {
  static const String login = '/login';
  static const String client = '/client';
  static const String provider = '/provider';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
      //return MaterialPageRoute(builder: (_) => LoginScreen());
      case client:
        return MaterialPageRoute(builder: (_) => RegisterService());
      case provider:
      //return MaterialPageRoute(builder: (_) => ProviderList());
      default:
        return MaterialPageRoute(builder: (_) => ServiceList());
      //return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
