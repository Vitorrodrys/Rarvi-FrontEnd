import 'package:flutter/material.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/token_manager.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}


class _HomeState extends State<HomeScreen> {

  final RarviAPI _api = RarviAPI();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rarvi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _api.user.logout();
              TokenManager.drop();
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async{
              print(await _api.user.getUsers());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}



