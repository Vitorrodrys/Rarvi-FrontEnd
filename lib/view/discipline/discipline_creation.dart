import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/discipline.dart';
import 'package:rarvi/widgets/fab_nav_scaffold.dart';

class DisciplineCreationScreen extends StatefulWidget {
  const DisciplineCreationScreen({super.key});

  @override
  State<DisciplineCreationScreen> createState() =>
      _DisciplineCreationScreenState();
}

class _DisciplineCreationScreenState extends State<DisciplineCreationScreen> {
  final TextEditingController _discipline_controller = TextEditingController();
  Color _corSelecionada = Colors.red;
  final rarviApi = RarviAPI();

  void _abrirColorPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _corSelecionada,
                onColorChanged: (cor) {
                  setState(() {
                    _corSelecionada = cor;
                  });
                },
                enableAlpha: false,
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Fechar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FabNavScaffold(
      perfilAction: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/perfil");
      },
      homeAction: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      },
      fabAction: () {},
      selectedItem: FabNavItem.home,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7071FF), Color(0xFF106BF7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Adicionar\ndisciplina',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/bookmark.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    // Ação do ícone SVG
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _discipline_controller,
              decoration: InputDecoration(
                hintText: 'Informe o nome da disciplina',
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                const Text('Cor selecionada: '),
                GestureDetector(
                  onTap: _abrirColorPicker,
                  child: CircleAvatar(
                    backgroundColor: _corSelecionada,
                    radius: 20,
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                String disciplineName = _discipline_controller.text.trim();

                try {
                  await rarviApi.discipline.createDiscipline(
                    DisciplineCreateSchema(
                      name: disciplineName,
                      red: (_corSelecionada.r * 255.0).toInt(),
                      green: (_corSelecionada.g * 255.0).toInt(),
                      blue: (_corSelecionada.b * 255.0).toInt(),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Disciplina Criada com sucesso"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    ),
                  );
                } on APIError catch (err) {
                  if (err.cause == APIErrorEnum.disciplineAlreadyExist) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Já existe uma disciplina com esse nome"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    throw Exception(
                      "Erro Inesperado em discipline_creation.card",
                    );
                  }
                }
              },
              label: const Text('Confirmar', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
