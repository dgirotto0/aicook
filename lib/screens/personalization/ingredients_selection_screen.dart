import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/recipe_preferences.dart';
import '../../utils/colors.dart';

class IngredientsSelectionScreen extends StatefulWidget {
  const IngredientsSelectionScreen({super.key});

  @override
  _IngredientsSelectionScreenState createState() =>
      _IngredientsSelectionScreenState();
}

class _IngredientsSelectionScreenState
    extends State<IngredientsSelectionScreen> {
  Map<String, List<String>> ingredients = {
    'Essenciais': [
      'Sal', 'Açúcar', 'Farinha de Trigo', 'Farinha de Milho', 'Ovo', 'Leite Integral',
      'Leite Desnatado', 'Manteiga', 'Óleo de Soja', 'Óleo de Girassol', 'Fermento Biológico',
      'Fermento Químico', 'Água', 'Alho', 'Pimenta-do-Reino', 'Pimenta Vermelha',
      'Azeite de Oliva', 'Vinagre Branco', 'Vinagre de Maçã'
    ],
    'Aves': [
      'Frango', 'Frango Desfiado', 'Peru', 'Peito de Frango', 'Coxa de Frango',
      'Sobrecoxa', 'Asa de Frango', 'Pato', 'Galinha Caipira', 'Codorna',
      'Chester', 'Marreco', 'Faisão', 'Perdiz', 'Ema', 'Frango Defumado'
    ],
    'Carnes': [
      'Carne Bovina', 'Alcatra', 'Filé Mignon', 'Carne Suína', 'Lombo',
      'Pernil', 'Carneiro', 'Cordeiro', 'Costela de Porco', 'Coxão Mole',
      'Acém', 'Músculo', 'Carne Moída', 'Linguiça Calabresa', 'Bacon Defumado',
      'Picanha', 'Maminha', 'Fraldinha', 'Vitela', 'Carne de Sol', 'Churrasco'
    ],
    'Frutos do Mar': [
      'Camarão', 'Camarão Rosa', 'Salmão', 'Filé de Atum', 'Bacalhau Salgado',
      'Sardinha Fresca', 'Polvo', 'Lula', 'Marisco', 'Ostra', 'Lagosta',
      'Mexilhão', 'Caranguejo', 'Peixe Espada', 'Tilápia', 'Truta'
    ],
    'Vegetais': [
      'Tomate', 'Cebola Roxa', 'Cebola Branca', 'Alface Americana', 'Cenoura',
      'Brócolis', 'Espinafre', 'Batata Inglesa', 'Batata Doce', 'Pimentão Verde',
      'Pimentão Amarelo', 'Abobrinha Italiana', 'Pepino Japonês', 'Couve Manteiga',
      'Repolho Roxo', 'Repolho Branco', 'Alho-poró', 'Berinjela', 'Abóbora',
      'Chuchu', 'Palmito'
    ],
    'Frutas': [
      'Maçã Verde', 'Maçã Vermelha', 'Banana Prata', 'Banana Nanica', 'Laranja Lima',
      'Laranja Pêra', 'Manga Palmer', 'Manga Tommy', 'Uva Itália', 'Uva Passa',
      'Melão Amarelo', 'Melão Cantaloupe', 'Abacaxi Pérola', 'Morango Fresco',
      'Melancia', 'Kiwi', 'Pêra Williams', 'Pêssego', 'Abacate Hass', 'Limão Siciliano',
      'Limão Taiti', 'Coco Ralado', 'Coco Fresco'
    ],
    'Legumes': [
      'Feijão Carioca', 'Feijão Preto', 'Feijão Branco', 'Lentilha Vermelha',
      'Lentilha Verde', 'Grão de Bico', 'Ervilha Fresca', 'Ervilha Seca', 'Soja',
      'Milho Verde', 'Milho em Conserva'
    ],
    'Cereais': [
      'Arroz Branco', 'Arroz Integral', 'Arroz Basmati', 'Arroz Arbóreo',
      'Trigo para Quibe', 'Aveia em Flocos', 'Cevada Perolada', 'Centeio',
      'Quinoa', 'Milho de Pipoca', 'Farinha de Aveia'
    ],
    'Laticínios': [
      'Queijo Mussarela', 'Queijo Cheddar', 'Queijo Parmesão', 'Queijo Minas',
      'Iogurte Natural', 'Iogurte Grego', 'Requeijão Cremoso', 'Creme de Leite Fresco',
      'Leite Condensado', 'Manteiga Sem Sal', 'Queijo Cottage', 'Ricota'
    ],
    'Condimentos': [
      'Páprica Doce', 'Páprica Picante', 'Cominho em Pó', 'Coentro em Grãos',
      'Açafrão-da-Terra', 'Orégano Desidratado', 'Manjericão Fresco',
      'Alecrim Fresco', 'Tomilho Seco', 'Sálvia', 'Louro', 'Molho Inglês',
      'Mostarda Dijon', 'Molho de Pimenta', 'Ketchup'
    ],
    'Nozes e Sementes': [
      'Amendoim Torrado', 'Castanha de Caju Torrada', 'Nozes Pecã',
      'Amêndoas Laminadas', 'Semente de Girassol Torrada',
      'Semente de Abóbora', 'Linhaça', 'Chia', 'Castanha-do-Pará'
    ],
    'Massas': [
      'Macarrão Espaguete', 'Macarrão Penne', 'Lasanha Fresca', 'Nhoque de Batata',
      'Ravioli de Queijo', 'Capeletti', 'Fettuccine', 'Canelone', 'Talharim'
    ],
    'Doces': [
      'Chocolate Amargo', 'Chocolate ao Leite', 'Chocolate Branco', 'Mel',
      'Açúcar Mascavo', 'Geleia de Morango', 'Geleia de Damasco',
      'Leite em Pó', 'Doce de Leite'
    ],
    'Outros': [
      'Caldo de Galinha em Pó', 'Caldo de Carne', 'Extrato de Tomate',
      'Molho de Soja', 'Vinagre Balsâmico', 'Shoyu Light', 'Leite de Coco',
      'Açúcar de Confeiteiro', 'Gelatina em Pó', 'Pó de Café', 'Chá Verde',
      'Chá Preto', 'Molho Barbecue', 'Molho Tártaro'
    ]
  };

  Map<String, Set<String>> selectedIngredients = {};

  Widget _buildIngredientButton(String category, String ingredient) {
    bool isSelected = selectedIngredients[category]?.contains(ingredient) ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIngredients[category]?.remove(ingredient);
          } else {
            selectedIngredients.putIfAbsent(category, () => <String>{}).add(ingredient);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? CustomColors.primaryColor : Colors.grey[400]!),
        ),
        child: Text(
          ingredient,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          children: ingredients[category]!
              .map((ingredient) => _buildIngredientButton(category, ingredient))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Selecione os ingredientes',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: ingredients.keys.map((category) {
              return _buildCategory(category);
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
              selectedIngredients.values.any((set) => set.isNotEmpty)
                  ? CustomColors.primaryColor
                  : Colors.grey[400],
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: selectedIngredients.values.any((set) => set.isNotEmpty)
                ? () {
              // Salva as seleções no RecipePreferences e navega para a próxima tela
              Provider.of<RecipePreferences>(context, listen: false)
                  .updateSelectedIngredients(selectedIngredients);

              Navigator.pushNamed(context, '/appliances_selection');
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
          'Ingredientes',
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
