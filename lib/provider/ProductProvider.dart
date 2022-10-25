import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/ProductModel.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> list = [];

  Future<void> getList() async {
    String apiURL =
        "https://fakestoreapi.com/products";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return ProductModel.fromJson(e);
    }).toList();
    notifyListeners();
  }

  void filterWithCategory(String category) async{
    String apiURL =
        "https://fakestoreapi.com/products/category/$category";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return ProductModel.fromJson(e);
    }).toList();
    notifyListeners();
  }

  void search(String searchInput) {
    list = list.where((element) => element.title.toString().toLowerCase().contains(searchInput.toLowerCase())).toList();
  }

  void isHighToLowPriceSort(bool flag)
  {
    if(flag)
      {
        list.sort((a, b) {
          return a.price.compareTo(b.price);
        },);
      }
    else
      {
        list.sort((a, b) {
          return b.price.compareTo(a.price);
        },);
      }
  }

  void isHighToLowRatingSort(bool flag)
  {
    if(flag)
    {
      list.sort((a, b) {
        return a.rating.rate.compareTo(b.rating.rate);
      },);
    }
    else
    {
      list.sort((a, b) {
        return b.rating.rate.compareTo(a.rating.rate);
      },);
    }
  }
}
