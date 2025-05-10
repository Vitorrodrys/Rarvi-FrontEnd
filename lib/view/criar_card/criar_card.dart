import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum Dificuldade { facil, medio, dificil }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Criar Card',
      home: const CriarCardScreen(),
    );
  }
}

class CriarCardScreen extends StatefulWidget {
  const CriarCardScreen({super.key});

  @override
  State<CriarCardScreen> createState() => _CriarCardScreenState();
}

class _CriarCardScreenState extends State<CriarCardScreen> {
  Dificuldade _dificuldade = Dificuldade.medio;
  final _tituloController = TextEditingController();
  final _perguntaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permite que o body se estenda atrás do botão laranja
      extendBody: true,
      body: Container(
        // Gradiente cobre 100% da tela
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A00D4), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Título centralizado
              const Text(
                'Criar card',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Card de Título e Pergunta
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Título (centralizado)
                      TextField(
                        controller: _tituloController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Título',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Pergunta (centralizada)
                      TextField(
                        controller: _perguntaController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Escreva sua pergunta aqui...',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Seleção de dificuldade
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecione a dificuldade',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildRadio(Dificuldade.facil, 'Fácil'),
                          _buildRadio(Dificuldade.medio, 'Médio'),
                          _buildRadio(Dificuldade.dificil, 'Difícil'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Botão laranja dentro do body para o gradiente cobrir atrás
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 28),
                    label: const Text(
                      'Adicionar Perguntas',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(Dificuldade value, String label) {
    return Row(
      children: [
        Radio<Dificuldade>(
          value: value,
          groupValue: _dificuldade,
          activeColor: Colors.purple,
          onChanged: (novo) => setState(() => _dificuldade = novo!),
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
