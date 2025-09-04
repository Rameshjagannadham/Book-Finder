import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://openlibrary.org';

  final http.Client _client;
  ApiClient(this._client);

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? params,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    final res = await _client.get(uri);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw http.ClientException(
        'HTTP ${res.statusCode}: ${res.reasonPhrase}',
        uri,
      );
    }
  }
}
