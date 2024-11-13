// lib/screens/loading_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../models/recipe_preferences.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _hasError = false;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _apiService = ApiService(dotenv.env['API_KEY_RECIPE']!);

    _fetchRecipe();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchRecipe() async {
    final prefs = Provider.of<RecipePreferences>(context, listen: false);

    Map<String, dynamic> requestData = {
      'occasion': prefs.occasion,
      'numberOfPeople': prefs.numberOfPeople,
      'mealType': prefs.mealType,
      'ingredients': prefs.selectedIngredients.values.expand((set) => set).toList(),
      'appliances': prefs.isAnyAppliance ? [] : prefs.selectedAppliances.toList(),
    };

    Recipe? recipe = await _apiService.fetchRecipe(requestData);

    if (recipe != null) {
      Navigator.pushReplacementNamed(context, '/recipe', arguments: recipe);
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  Widget _buildAnimation() {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          'assets/loading_icon.png',
          height: 100,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 100,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 30),
          const Text(
            'Ops! Algo deu errado.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Não foi possível gerar a sua receita. Por favor, tente novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
              });
              _fetchRecipe();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: CustomColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Tentar novamente',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimation(),
          const SizedBox(height: 30),
          const Text(
            'Estamos preparando sua receita...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _buildContent(),
    );
  }
}
