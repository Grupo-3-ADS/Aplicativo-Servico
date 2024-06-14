import 'package:flutter/material.dart';
import 'package:services/login.dart';
import 'package:services/register_service.dart';
import 'package:services/service_list.dart';

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
          primaryColor: Color.fromARGB(255, 0, 17, 255),
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color.fromARGB(255, 0, 17, 255),
                secondary: Color.fromARGB(255, 255, 0, 0),
                tertiary: Color.fromARGB(255, 204, 204, 204),
              ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 0, 17, 255),
          )),
      home: const LoginPage(),
      routes: {
        '/register': (context) => const RegisterService(),
        '/list': (context) => const ServiceList(),
      },
    );
  }
}
