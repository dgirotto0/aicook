import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/recipe.dart';

class ApiService {
  final GenerativeModel model;

  ApiService(String apiKey)
      : model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );

  Future<Recipe?> fetchRecipe(Map<String, dynamic> requestData) async {
    try {
      String prompt = _buildPrompt(requestData);

      print("Enviando solicitação para API com o prompt:\n$prompt");

      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        print('Erro: resposta vazia ou nula');
        return null;
      }

      String recipeText = response.text!.trim();
      print("Receita gerada:\n$recipeText");

      // Extrai o JSON da resposta
      recipeText = _extractJsonFromResponse(recipeText);

      // Verifica se o JSON não está vazio
      if (recipeText.isEmpty || recipeText == '{}') {
        print('Erro: JSON vazio retornado pela API.');
        return null;
      }

      // Tenta decodificar o JSON
      try {
        final recipeData = jsonDecode(recipeText) as Map<String, dynamic>;
        return Recipe.fromJson(recipeData);
      } catch (e) {
        print("Erro ao decodificar JSON: $e");
        if (kDebugMode) {
          print("JSON recebido: \n($recipeText)");
        }
        return null;
      }
    } catch (e) {
      print('Exceção ao chamar a API Gemini: $e');
      return null;
    }
  }

  String _buildPrompt(Map<String, dynamic> requestData) {
    final ingredientsList = requestData['ingredients'] ?? [];
    final peopleCount = requestData['numberOfPeople'] ?? 1;
    final occasion = requestData['occasion'] ?? 'um prato comum';
    final mealType = requestData['mealType'] ?? 'desconhecido';
    final appliancesList = requestData['appliances'] ?? [];
    final appliances = appliancesList.isNotEmpty
        ? appliancesList.join(', ')
        : 'nenhum eletrodoméstico específico';

    print('Meal Type no _buildPrompt: $mealType');

    String ingredientsPrompt;

    if (ingredientsList.isEmpty) {
      ingredientsPrompt = 'usando ingredientes comuns disponíveis em casa';
    } else {
      ingredientsPrompt =
      'com os seguintes ingredientes: ${ingredientsList.join(', ')}';
    }

    return '''
Por favor, sugira uma receita considerando os ingredientes disponíveis listados em $ingredientsPrompt, 
mas não é necessário usar todos. Escolha ingredientes que combinem e criem uma receita coerente e realista. 
O nome da receita deve ser suficientemente descritivo para identificar claramente o prato sugerido.
A receita deve ser para $peopleCount pessoa(s) e adequada para $occasion. 
O tipo de refeição é $mealType.
Utilize medidas precisas, preferencialmente em gramas ou mililitros. 
Os eletrodomésticos disponíveis são: $appliances.
Formate a resposta APENAS em JSON, sem blocos de código ou texto adicional, no seguinte formato:
{
  "name": "Nome da Receita",
  "preparation_time": "Tempo de Preparo",
  "ingredients": ["ingrediente 1", "ingrediente 2", ...],
  "instructions": ["passo 1", "passo 2", ...]
}
''';
  }

  String _extractJsonFromResponse(String response) {
    response = response.replaceAll(RegExp(r'^```(\w+)?\n', multiLine: true), '');
    response = response.replaceAll('```', '');
    final start = response.indexOf('{');
    final end = response.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return response.substring(start, end + 1);
    } else {
      return '';
    }
  }
}
