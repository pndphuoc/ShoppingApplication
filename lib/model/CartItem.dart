import 'package:project1/model/ProductModel.dart';

import 'Rating.dart';

class CartItem{
  ProductModel model;
  int Quantity;


  num getTotalPrice()
  {
    return model.price*Quantity;
  }
  CartItem({required this.model, required this.Quantity});


  /*CartItem(int id, String title,
  num price,
  String description,
  String category,
  String image,
  Rating rating, this.Quantity) : super(id: id, title: title, price: price, description: description, category: category, image: image, rating: rating);
  */


}