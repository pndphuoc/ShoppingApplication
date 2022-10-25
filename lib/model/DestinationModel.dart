import 'dart:core';
class DestinationModel{
  final String _id;
  final String name;
  final String image;
  final List<String> genre;
  final int rating;

  DestinationModel(this._id, this.name, this.image, this.genre, this.rating);

  static List<DestinationModel> MockData(){
    List<DestinationModel> ls = [];
    ls.add(DestinationModel("1", "Lăng Quốc Huy", "assets/images/img_1.png", ['ngu', 'xau'], 5));
    ls.add(DestinationModel("1", "Lăng Minh Mạng", "assets/images/img_2.png", [''], 4));
    ls.add(DestinationModel("1", "Lăng Khải Định", "assets/images/img_3.png", [''], 4));
    ls.add(DestinationModel("1", "Ngọ Môn", "assets/images/img_4.png", [''], 3));
    ls.add(DestinationModel("1", "Tử cấm thành", "assets/images/img_5.png", [''], 4));
    return ls;
  }
}