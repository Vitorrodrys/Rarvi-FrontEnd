import 'package:flutter/material.dart';
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/user.dart';
import 'package:rarvi/widgets/fab_nav_scaffold.dart';

/// Tela de perfil usando o scaffold genérico
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final RarviAPI api = RarviAPI();
  late String userName = "";

  getUserName() async {
    User user = await api.user.getUser();
    userName = user.name;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return FabNavScaffold(
      perfilAction: (){},
      homeAction: (){
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      },
      fabAction: (){},
      selectedItem: FabNavItem.perfil,
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7071FF), Color(0xFF106BF7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  height: 251,
                ),
                Positioned(
                  top: 29,
                  left: 25,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: 29,
                  right: 25,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: 78,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        width: 87.82,
                        height: 87.82,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                      onPressed: () {
                        RarviAPI().user.logout();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        size: 20,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Sair',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  ),
                  // demais conteúdos...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
