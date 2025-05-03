import 'package:flutter/material.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/user.dart';
import 'package:rarvi/widgets/rounded_button.dart';
import 'package:rarvi/widgets/rounded_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _create_user() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final api = RarviAPI();
    UserCreateSchema user = UserCreateSchema(name: name, email: email, password: password);
    try{
      await api.user.createUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuário criado com sucesso"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); // Return to login
    } on APIError catch (e){
      switch (e.cause) {
        case APIErrorEnum.emailAlreadyExists:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email já cadastrado"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          break;
        case APIErrorEnum.usernameAlreadyExists:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Nome de usuário já cadastrado"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          break;
        case APIErrorEnum.invalidEmail:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email inválido"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro ao criar usuário"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          break;
      }
    }
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
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo.jpeg",
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const Center(
                  child: Text(
                    "Criar nova conta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Nome",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RoundedTextField(
                  hintText: "Digite seu nome",
                  icon: Icons.person,
                  controller: _nameController,
                  radius: 8,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RoundedTextField(
                  hintText: "Digite seu email",
                  icon: Icons.email,
                  controller: _emailController,
                  radius: 8,
                  keyboardType: TextInputType.emailAddress,
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
                  hintText: "Crie uma senha",
                  icon: Icons.lock,
                  controller: _passwordController,
                  isPassword: true,
                  radius: 8,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Confirmar senha",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RoundedTextField(
                  hintText: "Confirme sua senha",
                  icon: Icons.lock_outline,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  radius: 8,
                ),
                const SizedBox(height: 24),
                RoundedButton(
                  text: "Cadastrar",
                  color: Colors.blue,
                  textColor: Colors.white,
                  radius: 8,
                  onPressed: () {
                    setState(() {
                      _create_user();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Return to login
                    },
                    child: const Text(
                      "Já tem uma conta? Faça login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}