import 'package:flutter/material.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/user.dart';
import 'package:rarvi/widgets/rounded_button.dart';
import 'package:rarvi/widgets/rounded_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _do_login() async {
    String user = _userController.text;
    String password = _passwordController.text;

    if (user.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final api = RarviAPI();
    try{
      await api.user.auth(user, password);
      Navigator.pushNamed(context, "/home");
    } on AuthError catch (e){
      switch (e.cause) {
        case AuthErrorEnum.unauthorized:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Usuário ou senha incorretos"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro ao fazer login"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          break;
      }
    }

  }


  Widget _build_login_form(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            "assets/images/leef.png",
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
        Center(
          child: Image.asset(
            "assets/images/logo.jpeg",
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
        Center(
          child: const Text(
            "Bem vindo ao Rarvi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Usuário",
          style: TextStyle(
            color: Colors.black45,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RoundedTextField(
          hintText: "Digite seu usuário ou email",
          icon: Icons.person,
          controller: _userController,
          radius: 8,
        ),
        const SizedBox(height: 16),
        const Text(
          "Senha",
          style: TextStyle(
            color: Colors.black45,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RoundedTextField(
          hintText: "Digite sua senha",
          icon: Icons.lock,
          controller: _passwordController,
          isPassword: true,
          radius: 8,
        ),
        const SizedBox(height: 24),
        RoundedButton(
          text: "Entrar",
          color: Colors.blue,
          textColor: Colors.white,
          radius: 8,
          onPressed: () {
            setState(() {
              _do_login();
            });
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/RecoveryPassword");
            },
            child: const Text(
              "Esqueceu a senha?",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/signup");
            },
            child: const Text(
              "Não tem uma conta? Cadastre-se",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _build_login_form(context)
          ),
        ),
      ),
    );
  }
}