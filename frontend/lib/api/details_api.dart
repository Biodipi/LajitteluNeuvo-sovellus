import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oiva_app_flutter/constants.dart';
import 'package:oiva_app_flutter/data/details_model.dart';
import 'package:oiva_app_flutter/data/suggestion_model.dart';

class DetailsApi {
  static Future<DetailsModel> fetchItem(String item) async {
    //debug mock data:
    //return await DetailsModel(
    //    false,
    //     "Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, Käsittelemätön puu haketetaan, minkä jälkeen se hyödynnetään energiana.\n\nPuujäte, jossa ei ole mitään pintakäsittelyä, esim. maalia, otetaan maksutta vastaan. Naulat eivät haittaa \nHuom! Lämpökäsitellyssä puussa ei ole käytetty kemikaaleja, joten se voidaan ottaa vastaan maksutta Oivapisteelle.",
    //    "pienelektroniikka",
    //    11,
    //    true,
    //    "mock");
    //

    final response =
        await http.get(Uri.parse(baseURL + detailsApiEndpoint + item));
    print(baseURL + detailsApiEndpoint + item);
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      print("received item:");
      print(data.toString());
      return DetailsModel.from(data, title: item);
    } else {
      // ignore: avoid_print
      print(response.body);
      // ignore: avoid_print
      print(response.statusCode);
      print("failed to fetch details!");
      return null;
    }
  }
}
