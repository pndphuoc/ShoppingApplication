import 'package:flutter/material.dart';
import 'package:project1/products_page.dart';
import 'package:project1/provider/CategoryProvider.dart';
import 'package:project1/provider/ProductProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider())
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductsPage()),
  ));
}
