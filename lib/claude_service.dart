import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ClaudeService {
  final String _baseUrl = 'https://api.anthropic.com/v1/messages';
  final String _apiKey = 'YOUR-API-KEY';

  Future<String> analyzeImage(File image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthrpoic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-3-opus-20240229',
          'max_tokens': 50,
          'message': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image',
                  'source': {
                    'type': 'base64',
                    'media_type': ' image/jpeg',
                    'data': base64Image,
                  },
                },
                {
                  'type': 'text',
                  'text': 'Fotoğrafta ne gördüğünü açıkla ',
                }
              ],
            }
          ],
        }));

        //claudeden geridönüt 

        if(response.statusCode ==200){
          final data = jsonDecode(response.body);
          return data['content'][0]['text'];
        }

        //hata

        throw Exception("Fotoğraf analiz edilemedi: ${response.statusCode} ");
  }
}
