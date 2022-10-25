import 'Rating.dart';

class ProductModel{
  int? id;
  String? title;
  num price;
  String? description;
  String? category;
  String? image;
  Rating rating;

  ProductModel({this.id, this.title, required this.price, this.description, this.category, this.image, required this.rating});

  factory ProductModel.fromJson(Map<String, dynamic> obj){
    return ProductModel(
        id: obj['id'],
        title: obj['title'],
        price:  obj['price'],
        description: obj['description'],
        category: obj['category'],
        image: obj['image'],
        rating: Rating.fromJson(obj['rating'])
    );
  }

  num get getPrice {
    return price;
  }
}