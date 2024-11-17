import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../models/recipe_preferences.dart'; // Adicione esta linha

class OccasionScreen extends StatefulWidget {
  const OccasionScreen({super.key});

  @override
  _OccasionScreenState createState() => _OccasionScreenState();
}

class _OccasionScreenState extends State<OccasionScreen> {
  String? selectedOccasion;

  final List<Map<String, String>> occasions = [
    {'title': 'Café da manhã', 'icon': 'assets/icons/lunch.png'},
    {'title': 'Almoço', 'icon': 'assets/icons/dessert.png'},
    {'title': 'Jantar', 'icon': 'assets/icons/dinner.png'},
    {'title': 'Tanto Faz', 'icon': 'assets/icons/any.png'},
  ];

  Widget _buildOccasionCard(Map<String, String> occasion) {
    bool isSelected = selectedOccasion == occasion['title'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOccasion = occasion['title'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent[100] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? CustomColors.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              occasion['icon']!,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 20),
            Text(
              occasion['title']!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          'Qual é a ocasião?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: occasions.length,
            itemBuilder: (context, index) {
              return _buildOccasionCard(occasions[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: selectedOccasion != null
                  ? CustomColors.primaryColor
                  : Colors.grey[400],
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: selectedOccasion != null
                ? () {
              // Atualize o RecipePreferences aqui
              Provider.of<RecipePreferences>(context, listen: false)
                  .updateOccasion(selectedOccasion!);
              Navigator.pushNamed(context, '/people');
            }
                : null,
            child: const Text(
              'Próximo',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ocasião',
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(),
    );
  }
}
