import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageService {
  final String apiKey = dotenv.env['API_KEY_IMAGE']!;
  final String apiUrl = 'https://api.unsplash.com/search/photos';

  Future<String?> fetchImage(String query) async {
    final refinedQuery = '$query food dish cuisine';

    final response = await http.get(
      Uri.parse('$apiUrl?query=$refinedQuery&client_id=$apiKey&per_page=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['urls']['regular'];
      }
    } else {
      print('Erro ao buscar imagem: ${response.statusCode}');
    }
    return null;
  }
}

