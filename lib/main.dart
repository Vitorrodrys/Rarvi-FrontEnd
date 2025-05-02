import 'package:flutter/material.dart';

import 'package:rarvi/view/home/home.dart';
import 'package:rarvi/view/login/login.dart';
import 'package:rarvi/view/login/recovery_password.dart';
import 'package:rarvi/view/login/signup.dart';


void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/RecoveryPassword': (context) => const RecoveryScreen(),
        '/home': (context) => const HomeScreen(),
      }, 
    )
  );
}
