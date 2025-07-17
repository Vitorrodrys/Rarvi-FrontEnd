import 'package:flutter/material.dart';
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart' as RarviCard;
import 'package:rarvi/services/api/schemas/discipline.dart';
import 'package:rarvi/view/card/criar_card.dart';
import 'package:rarvi/view/card/editar_card.dart';
import 'package:rarvi/view/card/review_card.dart';
import 'package:rarvi/widgets/fab_nav_scaffold.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisciplineScreen(disciplineId: 1),
    ),
  );
}

class DisciplineScreen extends StatefulWidget {
  final int disciplineId;

  const DisciplineScreen({super.key, required this.disciplineId});

  @override
  State<DisciplineScreen> createState() => _DisciplineScreenState();
}

class _DisciplineScreenState extends State<DisciplineScreen> {
  final rarviApi = RarviAPI();
  Discipline? _discipline;
  List<RarviCard.Card> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final discipline = await rarviApi.discipline.getUserDisciplines();
      final found = discipline.firstWhere(
        (d) => d.id == widget.disciplineId,
        orElse: () => throw Exception("Disciplina não encontrada"),
      );

      final cards = await rarviApi.card.getCards(
        widget.disciplineId,
        null,
        null,
      );

      setState(() {
        _discipline = found;
        _cards = cards;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar disciplina.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FabNavScaffold(
      selectedItem: FabNavItem.home,
      homeAction: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      },
      perfilAction: () {
        Navigator.pop(context);  
        Navigator.pushNamed(context, "/perfil");
      },
      fabAction: () {},
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildPerguntasTitle(),
                    const SizedBox(height: 8),
                    _buildCardsList(),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7071FF), Color(0xFF106BF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            _discipline?.name ?? 'Disciplina',
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CardReviewScreen(disciplineId: widget.disciplineId)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.flash_on),
            label: const Text('Iniciar Revisão'),
          ),
        ],
      ),
    );
  }

  Widget _buildPerguntasTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            'Perguntas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CriarCardScreen(
                        to_discipline_id: widget.disciplineId,
                      ),
                ),
              );
              _loadData();
            },
            child: const Icon(Icons.add_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar deleção'),
        content: Text('Tem certeza que deseja deletar esta pergunta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Deletar'),
          ),
        ],
      ),
    );
  }
  Widget _buildCardsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children:
            _cards
                .map(
                  (c) => InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarCardScreen(cardId: c.id),
                        ),
                      );
                      _loadData();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.question,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              bool? confirmed = await showDeleteConfirmationDialog(context);
                              if ( confirmed != true ) return;
                              await rarviApi.card.deleteCard(c.id);
                              setState(() {
                                _loadData();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
