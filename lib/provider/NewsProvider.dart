import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/NewsModel.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> list = [];

  void getList(String? topic) async {
    String apiURL =
        "https://newsapi.org/v2/everything?q=$topic&from=2022-10-18&sortBy=publishedAt&apiKey=c11aefc924bf4357b3a70ada8fb11f86";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject['articles'] as List;
    list = newsListObject.map((e) {
      return NewsModel.fromJson(e);
    }).toList();
    notifyListeners();
  }
}
