import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oiva_app_flutter/constants.dart';
import 'package:oiva_app_flutter/data/suggestion_model.dart';

class SuggestionsApi {
  static Future<List<SuggestionModel>> fetchSuggestions(String pattern) async {
    final response =
        await http.get(Uri.parse(baseURL + searchApiEndpoint + pattern));

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      List<SuggestionModel> parsedList = [];
      for (dynamic item in list) {
        parsedList.add(SuggestionModel.fromJson(item));
      }
      return parsedList;
    } else {
      print(response.body);
      print("failed to fetch suggestions!");
      return null;
    }
  }
}
