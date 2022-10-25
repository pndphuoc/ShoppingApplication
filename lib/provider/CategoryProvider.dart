import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../model/CategoryModel.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> list = [];

  Future<void> getList() async {
    String apiURL =
        "https://fakestoreapi.com/products/categories";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return CategoryModel.fromJson(e);
    }).toList();
    notifyListeners();
  }
}