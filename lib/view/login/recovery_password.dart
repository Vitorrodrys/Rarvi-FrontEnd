import 'package:flutter/material.dart';

import 'package:rarvi/widgets/rounded_button.dart';
import 'package:rarvi/widgets/rounded_text_field.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryState();
}

class _RecoveryState extends State<RecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    "Recuperação de senha",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                  hintText: "Digite seu email cadastrado",
                  icon: Icons.email,
                  controller: _emailController,
                  radius: 8,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                RoundedButton(
                  text: "Enviar código",
                  color: Colors.blue,
                  textColor: Colors.white,
                  radius: 8,
                  onPressed: () {
                    setState(() {
                      _emailSent = true;
                    });
                    // In a real app, send email with verification code
                  },
                ),
                if (_emailSent) ...[
                  const SizedBox(height: 24),
                  const Text(
                    "Código de verificação",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RoundedTextField(
                    hintText: "Digite o código recebido",
                    icon: Icons.code,
                    controller: _codeController,
                    radius: 8,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Nova senha",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RoundedTextField(
                    hintText: "Digite sua nova senha",
                    icon: Icons.lock,
                    controller: _newPasswordController,
                    isPassword: true,
                    radius: 8,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Confirmar nova senha",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RoundedTextField(
                    hintText: "Confirme sua nova senha",
                    icon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    isPassword: true,
                    radius: 8,
                  ),
                  const SizedBox(height: 24),
                  RoundedButton(
                    text: "Redefinir senha",
                    color: Colors.green,
                    textColor: Colors.white,
                    radius: 8,
                    onPressed: () {
                      // Validate and update password
                      Navigator.pop(context); // Return to login
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Return to login
                    },
                    child: const Text(
                      "Voltar para login",
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