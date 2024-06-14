import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/database.dart';
import 'package:services/service_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 0, 0),
              Color.fromARGB(255, 0, 17, 255)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Digite os dados de acesso nos campos abaixo.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            CupertinoTextField(
              controller: emailController,
              cursorColor: Color.fromARGB(255, 0, 17, 255),
              padding: const EdgeInsets.all(15),
              placeholder: "Digite o seu e-mail",
              placeholderStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )),
            ),
            const SizedBox(height: 5),
            CupertinoTextField(
              controller: passwordController,
              padding: const EdgeInsets.all(15),
              cursorColor: Color.fromARGB(255, 0, 17, 255),
              placeholder: "Digite sua senha",
              obscureText: true,
              placeholderStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  )),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Color.fromARGB(255, 0, 17, 255),
                child: const Text(
                  "Acessar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: _login,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 0.8),
                  borderRadius: BorderRadius.circular(7)),
              child: CupertinoButton(
                child: const Text(
                  "Crie sua conta",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    bool isValid = await DatabaseHelper.instance.verifyUser(
      emailController.text,
      passwordController.text,
    );

    if (isValid) {
      var userId =
          await DatabaseHelper.instance.getUserIdByEmail(emailController.text);

      var userRole = await DatabaseHelper.instance.getUserRoleById(userId);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (userRole != null) {
        await prefs.setString('userRole', userRole!);
      }
      // Salvar o ID do usuário na sessão
      await prefs.setInt('userId', userId!);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                ServiceList()), 
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('E-mail ou senha incorretos.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
