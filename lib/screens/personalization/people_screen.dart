import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe_preferences.dart';
import '../../utils/colors.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  bool isOnlyMe = true;
  int numberOfPeople = 2;

  Widget _buildOptionCard(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? Colors.greenAccent[100] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? CustomColors.primaryColor : Colors.grey[300]!,
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
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? CustomColors.primaryColor : Colors.grey[400],
            ),
            const SizedBox(width: 20),
            Text(
              title,
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

  Widget _buildNumberPicker() {
    return Column(
      children: [
        const Text(
          'Quantas pessoas?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: numberOfPeople > 2
                  ? () {
                setState(() {
                  numberOfPeople--;
                });
              }
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.grey[800],
              iconSize: 30,
            ),
            const SizedBox(width: 20),
            Text(
              '$numberOfPeople',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                setState(() {
                  numberOfPeople++;
                });
              },
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.grey[800],
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          'Para quantas pessoas é a receita?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildOptionCard('Só para mim', isOnlyMe, () {
          setState(() {
            isOnlyMe = true;
            numberOfPeople = 1;
          });
        }),
        _buildOptionCard('Para mais pessoas', !isOnlyMe, () {
          setState(() {
            isOnlyMe = false;
          });
        }),
        if (!isOnlyMe) _buildNumberPicker(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: CustomColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Provider.of<RecipePreferences>(context, listen: false)
                  .updateNumberOfPeople(numberOfPeople);
              Navigator.pushNamed(context, '/meal_type');
            },
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
          'Número de Pessoas',
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
