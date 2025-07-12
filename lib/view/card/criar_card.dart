import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import para Markdown
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Criar Card',
      home: const CriarCardScreen(to_discipline_id: 1),
    );
  }
}

class CriarCardScreen extends StatefulWidget {
  final int to_discipline_id;
  const CriarCardScreen({super.key, required this.to_discipline_id});

  @override
  State<CriarCardScreen> createState() => _CriarCardScreenState();
}

class _CriarCardScreenState extends State<CriarCardScreen> {
  final tituloController = TextEditingController();
  final perguntaController = TextEditingController();
  final RarviAPI api = RarviAPI();

  bool _previewResposta = false;

  @override
  void dispose() {
    tituloController.dispose();
    perguntaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 70),
              const Text(
                'Criar card',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 90),
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
                      TextField(
                        controller: tituloController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Frente',
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Visualizar Resposta (Markdown)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: _previewResposta,
                            onChanged: (val) {
                              setState(() {
                                _previewResposta = val;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 150,
                        child: _previewResposta
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Markdown(
                                  data: perguntaController.text,
                                  selectable: true,
                                ),
                              )
                            : TextField(
                                controller: perguntaController,
                                decoration: const InputDecoration(
                                  hintText: 'Verso',
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      api.card.createCard(
                        CardCreateSchema(
                          question: tituloController.text,
                          answer: perguntaController.text,
                          discipline_id: widget.to_discipline_id,
                        ),
                      );
                      Navigator.pop(context, true);
                    },
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
}
