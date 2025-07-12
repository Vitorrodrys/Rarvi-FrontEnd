import 'package:flutter/material.dart';
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart' as card_schema;
import 'package:rarvi/view/card/card_buffer.dart';

void main() => runApp(CardReviewApp());

class CardReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CardReviewScreen(disciplineId: 0));
  }
}

const int CARD_BUFFER_SIZE = 10;

class CardReviewScreen extends StatefulWidget {
  final _api = RarviAPI();
  late final CardBuffer _buffer;

  CardReviewScreen({Key? key, required int disciplineId}) : super(key: key) {
    _buffer = CardBuffer(_api, disciplineId, CARD_BUFFER_SIZE);
  }

  @override
  State<CardReviewScreen> createState() => _CardReviewScreenState();
}

class _CardReviewScreenState extends State<CardReviewScreen> {
  final PageController _pageController = PageController();
  card_schema.Card? currentCard;
  card_schema.CardDifficultyEnum? selectedDifficulty;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNextCard();
  }

  Future<void> _loadNextCard() async {
    setState(() {
      isLoading = true;
      selectedDifficulty = null;
    });

    currentCard = await widget._buffer.getNext();

    setState(() {
      isLoading = false;
    });
  }

  void sendFeedback() {
    final id = currentCard?.id;
    if (selectedDifficulty != null && id != null) {
      widget._api.card.sendFeedBack(id, selectedDifficulty!);
      _loadNextCard();
      _pageController.jumpToPage(0); // Reinicia para a primeira página
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF2E64FE),
      body: SafeArea(
        child: Center(
          child: isLoading || currentCard == null
              ? const CircularProgressIndicator(color: Colors.white)
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 280,
                      width: 380,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          _buildBookPage(currentCard!.question, title: 'Pergunta'),
                          _buildBookPage(currentCard!.answer ?? "[sem resposta]", title: 'Resposta'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Deslize ou toque ➡ para ver a resposta",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Selecione a dificuldade",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    _buildDifficultyChips(),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
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
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBookPage(String content, {required String title}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFFFDF6E3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChips() {
    final options = [
      ('Fácil', card_schema.CardDifficultyEnum.easy),
      ('Médio', card_schema.CardDifficultyEnum.medium),
      ('Difícil', card_schema.CardDifficultyEnum.hard),
      ('De novo', card_schema.CardDifficultyEnum.again),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: options.map((label) {
        final isSelected = selectedDifficulty == label.$2;
        final chipColor = () {
          if (!isSelected) return Colors.grey[200];
          switch (label.$1) {
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

        return ChoiceChip(
          label: Text(
            label.$1,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          selected: isSelected,
          selectedColor: chipColor,
          backgroundColor: Colors.white,
          onSelected: (_) {
            setState(() => selectedDifficulty = label.$2);
          },
        );
      }).toList(),
    );
  }
}
