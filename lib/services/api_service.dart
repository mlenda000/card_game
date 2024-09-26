import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:validators/sanitizers.dart';

class ApiService {
  static const baseUrl = 'https://deckofcardsapi.com/api';

  Uri _url(String path, [Map<String, dynamic> params = const {}]) {
    String queryString = "";
    if (params.isNotEmpty) {
      queryString = '?';
      params.forEach(
        (k, v) {
          queryString += '$k=${v.toString()}&';
        },
      );
    }
    //trims leading and trailing slashes
    path = rtrim(path, '/');
    path = ltrim(path, '/');
    //trims trailing ampersand
    queryString = rtrim(queryString, '&');

    final url = '$baseUrl/$path/$queryString';
    return Uri.parse(url);
  }

  Future<Map<String, dynamic>> httpGet(
    String path, {
      Map<String, dynamic> params = const {},
      }) async {

        // build the url
    final url = _url(path, params);
    // make the request
    final response = await http.get(url);
    // check if the response is empty
    if (response.bodyBytes.isEmpty) {
      return {};
    }
    // decode the response
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
