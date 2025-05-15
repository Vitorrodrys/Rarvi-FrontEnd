import 'package:flutter/material.dart';

/// Scaffold fixo com FloatingActionButton e BottomAppBar inalterados
class FabNavScaffold extends StatelessWidget {
  /// Conteúdo principal da tela
  final Widget body;

  const FabNavScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: body,
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FloatingActionButton(
            onPressed: () {
              // Ação fixa do FAB
            },
            backgroundColor: Colors.orange,
            shape: const CircleBorder(),
            child: Image.asset(
              'assets/images/leef.png',
              width: 42,
              height: 42,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Transform.translate(
          offset: const Offset(0, -10), // Eleva o conteúdo em 10px
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF3D75E4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/home_bottom_nav.png',
                    width: 43,
                    height: 47,
                  ),
                  onPressed: () {
                    // Ação fixa do botão Home
                  },
                ),
                const SizedBox(width: 48),
                IconButton(
                  icon: Image.asset(
                    'assets/images/perfil_bottom_nav.png',
                    width: 43,
                    height: 47,
                  ),
                  onPressed: () {
                    // Ação fixa do botão Perfil
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Exemplo de uso:
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FabNavScaffold(
      body: Column(
        children: [
          // ... todo o layout do perfil permanece aqui
        ],
      ),
    );
  }
}
