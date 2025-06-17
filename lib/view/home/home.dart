import 'package:flutter/material.dart';
import 'package:rarvi/view/home/card_info.dart';
import 'package:rarvi/widgets/fab_nav_scaffold.dart';
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/token_manager.dart';
import 'package:rarvi/services/api/schemas/discipline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final RarviAPI _api = RarviAPI();

  Widget _studiedCardsInfo = Center(
    child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator()),
  );

  Widget _createdCardsInfo = Center(
    child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator()),
  );
  List<Widget> _disciplinesList = [CircularProgressIndicator()];

  Future<Widget> _disciplineBox(
    Discipline userDiscipline,
    DateTime today,
  ) async {
    int countStudied = await _api.card.countCards(
      disciplineId: userDiscipline.id,
      fromDate: today,
    );
    int total = await _api.card.countCards(disciplineId: userDiscipline.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.bookmark,
              color: Color.fromARGB(
                255,
                userDiscipline.red,
                userDiscipline.green,
                userDiscipline.blue,
              ),
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userDiscipline.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (total > 0)
                        ? "$countStudied/$total"
                        : "Nenhum conteudo até então!",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  if (total > 0)
                    LinearProgressIndicator(
                      value: countStudied / total,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blueAccent,
                      minHeight: 4,
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[500], size: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _loadInfo() async {
    DateTime fromDate = DateTime.now();
    fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);

    int dailyStudiedCardsCount = await _api.card.countCards(fromDate: fromDate);
    setState(() {
      _studiedCardsInfo = CardInfo(
        color: Colors.deepPurpleAccent,
        countInfo: dailyStudiedCardsCount,
        message: "Cards estudados",
      );
    });

    int createdCardsCount = await _api.card.countCards();
    setState(() {
      _createdCardsInfo = CardInfo(
        color: Colors.orange,
        countInfo: createdCardsCount,
        message: "Cards criados",
      );
    });

    List<Discipline> userDisciplines =
        await _api.discipline.getUserDisciplines();

    if (userDisciplines.isEmpty) {
      setState(() {
        _disciplinesList = [_noDisciplinesWidget(context)];
      });
      return;
    }
    _disciplinesList = [
      for (var discipline in userDisciplines.sublist(
        0,
        userDisciplines.length - 1,
      ))
        await _disciplineBox(discipline, fromDate),
      const SizedBox(height: 12),
    ];
    _disciplinesList += [
      await _disciplineBox(
        userDisciplines[userDisciplines.length - 1],
        fromDate,
      ),
    ];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Widget _noDisciplinesWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            "Nenhuma disciplina cadastrada",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FabNavScaffold(
      fabAction: () {},
      homeAction:
          () => setState(() {
            _loadInfo();
          }),
      perfilAction: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/perfil");
      },
      selectedItem: FabNavItem.home,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.grid_view, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              const Text(
                "Home",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _studiedCardsInfo),
                  const SizedBox(width: 12),
                  Expanded(child: _createdCardsInfo),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Disciplinas",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      Navigator.pushNamed(context, "/add_discipline");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._disciplinesList,
            ],
          ),
        ),
      ),
    );
  }
}
