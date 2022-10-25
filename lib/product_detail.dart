import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project1/model/ProductModel.dart';
import 'CartItemsScreen.dart';
import 'package:project1/Cart.dart' as cart;
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project1/Colors.dart' as colors;

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.Product}) : super(key: key);
  final ProductModel Product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

//Slide

class _ProductDetailState extends State<ProductDetail> {
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollcontroller = new ScrollController();
  bool scroll_visibility = true;
  var infomationContainerColor = Color.fromARGB(255, 235, 234, 239);
  int quantity = 1;
  var backgroundColor = Colors.white;
  var cartButtonColor = Color.fromARGB(255, 235, 234, 239);
  int currentPos = 0;
  List<String> listImage = ["1", "2"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
            padding: EdgeInsets.only(left: 10),
            icon: Icon(Icons.arrow_back_ios_new, color: colors.isDarkMode?Colors.white:Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: colors.isDarkMode?colors.backgroundColorDarkMode:colors.backgroundColor,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: Center(
            child: Text(
              "Product Detail",
              style: TextStyle(color: colors.isDarkMode?Colors.white:Colors.black),
            ),
          ),
          actions: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
              child: new Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: colors.isDarkMode?colors.cartButtonColorDarkMode:colors.cartButtonColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(SwipeablePageRoute(
                          builder: (BuildContext context) => CartItemsScreen(),
                        ));
                      },
                      child: new Container(
                        child: Stack(
                          children: <Widget>[
                            new IconButton(
                              icon: new Icon(
                                Icons.shopping_cart,
                                color: colors.isDarkMode?Colors.white:Colors.black87,
                              ),
                              onPressed: null,
                            ),
                            cart.list.length == 0
                                ? new Container()
                                : new Positioned(
                                    child: new Stack(
                                    children: <Widget>[
                                      new Icon(Icons.brightness_1,
                                          size: 23.0, color: Colors.redAccent),
                                      new Positioned(
                                          top: 5.0,
                                          right: 5.0,
                                          child: new Center(
                                            child: new Text(
                                              cart.list.length.toString(),
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )),
                                    ],
                                  )),
                          ],
                        ),
                      ))),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(color: colors.isDarkMode?colors.backgroundColorDarkMode:colors.backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 2.5,
                              reverse: false,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentPos = index;
                                });
                              }),
                          items: listImage.map((e) {
                            return Builder(builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                child: Center(
                                    child: Image.network(
                                  widget.Product.image ?? "",
                                  height: MediaQuery.of(context).size.height/2.8,
                                  fit: BoxFit.fitWidth,
                                )),
                              );
                            });
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: listImage.map((e){
                            int index = listImage.indexOf(e);
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPos == index
                                    ? !colors.isDarkMode?Color.fromRGBO(0, 0, 0, 0.9):Color.fromRGBO(255, 255, 255, 0.9)
                                    : !colors.isDarkMode?Color.fromRGBO(0, 0, 0, 0.4):Color.fromRGBO(255, 255, 255, 0.4)
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: colors.isDarkMode?colors.productBlockColorDarkMode:colors.productBlockColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        widget.Product.category.toString(),
                        style: TextStyle(
                            color: colors.isDarkMode?Colors.white:Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 220.0,
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 30, bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: colors.isDarkMode?colors.productBlockColorDarkMode:colors.productBlockColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  widget.Product.title.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: colors.isDarkMode?Colors.white:Colors.black,
                                      fontSize: 20),
                                ),
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RatingBar(
                                    ratingWidget: RatingWidget(
                                        full: Icon(Icons.star,
                                            color: colors.isDarkMode?Colors.white:Colors.black, size: 5,),
                                        half: Icon(Icons.star_half,
                                            color: colors.isDarkMode?Colors.white:Colors.black, size: 1),
                                        empty: Icon(Icons.star_border,
                                            color: colors.isDarkMode?Colors.white:Colors.black, size: 1)),
                                    onRatingUpdate: (rating) {},
                                    itemSize: 20,
                                    allowHalfRating: true,
                                    initialRating:
                                        widget.Product.rating.rate.toDouble(),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "(${widget.Product.rating.count} Reviews)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300, color: colors.isDarkMode?Colors.white:Colors.black,
                                        fontSize: 13),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.Product.description.toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300, color: colors.isDarkMode?Colors.white:Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 20),
          decoration: BoxDecoration(color: colors.isDarkMode?colors.productBlockColorDarkMode:colors.productBlockColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${widget.Product.price}",
                style: TextStyle(
                    color: colors.isDarkMode?Colors.white:Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: colors.isDarkMode?Colors.white:Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) --quantity;
                          });
                        },
                        icon: Icon(
                          Icons.remove,
                          size: 15,
                          color: colors.isDarkMode?Colors.white:Colors.black,
                        )),
                    SizedBox(
                        width: 20,
                        child: Center(
                            child: Text(
                          quantity.toString(), style: TextStyle(color: colors.isDarkMode?Colors.white:Colors.black),
                        ))),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            ++quantity;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          size: 15,
                          color: colors.isDarkMode?Colors.white:Colors.black,
                        )),
                  ],
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cart.add(widget.Product, quantity);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colors.isDarkMode?Colors.white:Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: Icon(
                      Icons.add_shopping_cart_outlined,
                      color: colors.isDarkMode?Colors.black:Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
