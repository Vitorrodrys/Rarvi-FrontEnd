import 'package:animations/animations.dart';
import 'package:flutter/material.dart';



void main() => runApp(CardReviewApp());

class CardReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CardReviewScreen());
  }
}

class CardReviewScreen extends StatefulWidget {
  @override
  _CardReviewScreenState createState() => _CardReviewScreenState();
}

class _CardReviewScreenState extends State<CardReviewScreen>
    with SingleTickerProviderStateMixin {
  bool showBack = false;
  bool showFeedback = false;
  String selectedDifficulty = '';
  final String cardTitle = 'Título do Card';
  final String cardBack =
      'Esse é o verso do card com a resposta ou explicação. Pode ter muito texto, e por isso precisa rolar se for necessário. Aqui está mais conteúdo para forçar o overflow. Mais texto. Mais texto. Mais texto. Mais texto. Mais texto. Mais texto.';

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    if (showBack) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    setState(() {
      showBack = !showBack;
      if (showBack) {
        showFeedback = true;
      }
    });
  }

  void sendFeedback() {
    if (selectedDifficulty.isNotEmpty) {
      print("Feedback enviado: $selectedDifficulty");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Feedback enviado com sucesso!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A82FB), Color(0xFF2E64FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Review do Card",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Área principal do card e feedback
                  SizedBox(
                    width: 400, // Aumentado
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final isFront = _controller.value < 0.5;
                            final displayText = isFront ? cardTitle : cardBack;

                            final rotationValue =
                                isFront
                                    ? _controller.value
                                    : _controller.value -
                                        1; // gira de -1 a 0 no verso

                            return Transform(
                              transform: Matrix4.rotationY(
                                rotationValue * 3.1416,
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                height: 240,
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    displayText,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          iconSize: 36,
                          onPressed: flipCard,
                          icon: RotationTransition(
                            turns: Tween(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(_controller),
                            child: Icon(Icons.refresh, color: Colors.white),
                          ),
                        ),
                        if (showFeedback) ...[
                          const SizedBox(height: 30),
                          Text(
                            "Selecione a dificuldade",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                ['Fácil', 'Médio', 'Difícil', 'De novo'].map((
                                  label,
                                ) {
                                  final isSelected =
                                      selectedDifficulty == label;

                                  final chipColor = () {
                                    if (!isSelected) return Colors.grey[200];
                                    switch (label) {
                                      case 'Fácil':
                                        return Colors.green[300];
                                      case 'Médio':
                                        return Colors.yellow[300];
                                      case 'Difícil':
                                        return Colors.orange[400];
                                      case 'De novo':
                                        return Colors.red[400];
                                      default:
                                        return Colors.grey;
                                    }
                                  }();

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width:
                                          isSelected
                                              ? 110
                                              : 80, // largura maior se selecionado
                                      child: ChoiceChip(
                                        label: Text(
                                          label,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        selected: isSelected,
                                        selectedColor: chipColor,
                                        backgroundColor: Colors.white,
                                        onSelected: (_) {
                                          setState(
                                            () => selectedDifficulty = label,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: sendFeedback,
                              icon: Icon(Icons.check),
                              label: Text("Enviar Feedback"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
