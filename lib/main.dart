import 'package:flutter/material.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/view/criar_card/criar_card.dart';

import 'package:rarvi/view/home/home.dart';
import 'package:rarvi/view/login/login.dart';
import 'package:rarvi/view/login/recovery_password.dart';
import 'package:rarvi/view/login/signup.dart';
import 'package:rarvi/view/perfil/perfil.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class RarviApp extends StatelessWidget {
  final RarviAPI _api = RarviAPI();

  final Widget _child;
  RarviApp({super.key, required Widget child}) : _child = child {
    _api.addSessionListener(
      'desconetHandler',
      (error) => _desconect_handler(_navigatorKey.currentContext!, error),
      [
        APIErrorEnum.tokenExpired,
        APIErrorEnum.loggedOut,
        APIErrorEnum.unauthorized,
      ],
    );
    _api.addSessionListener(
      'connectionErrorHandler',
      (error) =>
          _connection_error_handler(_navigatorKey.currentContext!, error),
      [APIErrorEnum.timeout, APIErrorEnum.connectionError],
    );
  }

  void _desconect_handler(BuildContext context, APIErrorEnum unloggedError) {
    switch (unloggedError) {
      case APIErrorEnum.tokenExpired:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sessão expirada"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 10),
          ),
        );
        break;
      case APIErrorEnum.loggedOut:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Desconectado"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 10),
          ),
        );
        break;
      case APIErrorEnum.unauthorized:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuário não autorizado"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 10),
          ),
        );
        break;
      default:
        break;
    }
  }

  void _connection_error_handler(BuildContext context, APIErrorEnum error) {
    switch (error) {
      case APIErrorEnum.timeout:
      case APIErrorEnum.connectionError:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro de conexão, tente novamente mais tarde"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 10),
          ),
        );
        break;
      default:
        break;
    }
  }

  /// This method is just a wrapper to add the session listeners to the API
  /// and redirect the user to the login screen.
  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

void main() {
  runApp(
    MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Rarvi',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Quicksand'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => RarviApp(child: const LoginScreen()),
        '/signup': (context) => const SignUpScreen(),
        '/RecoveryPassword': (context) => const RecoveryScreen(),
        '/home': (context) => const HomeScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/criarCard': (context) => const CriarCardScreen(),
      },
    ),
  );
}
