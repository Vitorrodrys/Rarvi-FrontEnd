import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import para Markdown
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart';

class EditarCardScreen extends StatefulWidget {
  final int cardId;

  const EditarCardScreen({super.key, required this.cardId});

  @override
  State<EditarCardScreen> createState() => _EditarCardScreenState();
}

class _EditarCardScreenState extends State<EditarCardScreen> {
  final rarviApi = RarviAPI();
  final TextEditingController _perguntaController = TextEditingController();
  final TextEditingController _respostaController = TextEditingController();
  bool _loading = true;

  // NOVO: controle do modo de pré-visualização
  bool _previewResposta = false;

  @override
  void initState() {
    super.initState();
    _carregarCard();
  }

  Future<void> _carregarCard() async {
    try {
      final card = await rarviApi.card.getCard(widget.cardId);
      setState(() {
        _perguntaController.text = card.question;
        _respostaController.text = card.answer ?? "";
        _loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar o card.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _loading = false);
    }
  }

  Future<void> _salvarEdicao() async {
    try {
      await rarviApi.card.updateCard(
        widget.cardId,
        CardUpdateSchema(
          question: _perguntaController.text.trim(),
          answer: _respostaController.text.trim(),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar as alterações.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletarCard() async {
    try {
      await rarviApi.card.deleteCard(widget.cardId);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao deletar o card.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Editar Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deletarCard,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _perguntaController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Frente (Pergunta)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // NOVO: linha com toggle para modo preview da resposta
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

                  Expanded(
                    child: _previewResposta
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Markdown(
                              data: _respostaController.text,
                              selectable: true,
                            ),
                          )
                        : TextField(
                            controller: _respostaController,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              labelText: 'Verso (Resposta)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _salvarEdicao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Salvar alterações'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
