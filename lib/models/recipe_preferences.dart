// lib/models/recipe_preferences.dart

import 'package:flutter/foundation.dart';

class RecipePreferences with ChangeNotifier {
  String? occasion;
  int numberOfPeople = 1;
  String? mealType;
  Map<String, Set<String>> selectedIngredients = {};
  Set<String> selectedAppliances = {};
  bool isAnyAppliance = false;

  // Método para atualizar os ingredientes selecionados
  void updateSelectedIngredients(Map<String, Set<String>> ingredients) {
    selectedIngredients = ingredients;
    notifyListeners();
  }

  // Método para atualizar os eletrodomésticos selecionados
  void updateSelectedAppliances(Set<String> appliances, bool anyAppliance) {
    selectedAppliances = appliances;
    isAnyAppliance = anyAppliance;
    notifyListeners();
  }
}
