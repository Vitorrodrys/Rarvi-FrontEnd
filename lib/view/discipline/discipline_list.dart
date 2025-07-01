import 'package:flutter/material.dart';
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart' as RarviCard;
import 'package:rarvi/services/api/schemas/discipline.dart';
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
      final discipline =
          await rarviApi.discipline
              .getUserDisciplines(); // Você pode substituir por um getDisciplineById se houver
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
      selectedItem: FabNavItem.perfil,
      homeAction: () => Navigator.pushNamed(context, "/home"),
      perfilAction: () => Navigator.pushNamed(context, "/perfil"),
      fabAction: () {},
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildPerguntasList(),
                ],
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
            onPressed: () {
              // lógica da revisão aqui
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

  Widget _buildPerguntasList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            Row(
              children: const [
                Text(
                  'Perguntas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.add_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            ..._cards.map(
              (c) => Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        c.question,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
