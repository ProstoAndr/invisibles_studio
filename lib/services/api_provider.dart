import 'package:dio/dio.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _apiKey = "AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw";
  final String _apiUrl = "https://translation.googleapis.com/language/translate/v2";

  Future<String?> translateText(String text, String sourceLanguage, String targetLanguage) async {
    try {
      Response response = await _dio.post(
        _apiUrl,
        queryParameters: {
          'key': _apiKey,
          'q': text,
          'source': sourceLanguage,
          'target': targetLanguage,
        },
      );

      if (response.statusCode == 200) {
        return response.data['data']['translations'][0]['translatedText'];
      } else {
        print("Error ${response.statusCode}: ${response.data}");
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }
}