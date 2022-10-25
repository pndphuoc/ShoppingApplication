class CategoryModel{
  String name;

  CategoryModel({required this.name});
  factory CategoryModel.fromJson(String obj){
    return CategoryModel(
        name: obj,
    );
  }
}