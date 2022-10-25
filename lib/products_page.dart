import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:project1/model/ProductModel.dart';
import 'package:project1/product_detail.dart';
import 'package:project1/provider/CategoryProvider.dart';
import 'package:project1/provider/ProductProvider.dart';
import 'package:provider/provider.dart';
import 'package:hidable/hidable.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'CartItemsScreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'Cart.dart' as cart;
import 'package:project1/Colors.dart' as colors;

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _ProductsPageState extends State<ProductsPage> {
  bool typing = false;
  String searchInput = "";
  String selectedCategory = "";
  String? valueDropdown;

  var backgroundColor = Color.fromARGB(255, 235, 234, 239);

  var cartButtonColor = Colors.white;
  bool filterBlock = false;

  //Lọc theo giá
  var iconOfPriceSort = Icons.unfold_more;
  int indexOfPriceSort = 0;

  //Lọc theo đánh giá
  var iconOfRatingSort = Icons.unfold_more;
  int indexOfRatingSort = 0;

  bool isLoading = true;
  bool isSearched = false;
  bool isGridView = true;
  bool isFilted = false;

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    var categoryProvider = Provider.of<CategoryProvider>(context);
    if (isLoading) {
      (() async {
        await productProvider.getList();
        await categoryProvider.getList();
        setState(() {
          isLoading = false;
        });
      })();
    }
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.4;
    final double itemWidth = size.width / 2;

    //Kiểm tra có phải kết quả tìm kiếm

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          icon: Icon(Icons.menu,
              color: colors.isDarkMode ? Colors.white : Colors.black),
          onPressed: () {},
        ),
        backgroundColor: colors.isDarkMode
            ? colors.backgroundColorDarkMode
            : colors.backgroundColor,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text(
            "Product List",
            style: TextStyle(
                color: colors.isDarkMode ? Colors.white : Colors.black),
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
                    color: colors.isDarkMode
                        ? colors.cartButtonColorDarkMode
                        : cartButtonColor,
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
                              color: colors.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
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
        child: isLoading
            ? Container(
                color: colors.isDarkMode
                    ? colors.backgroundColorDarkMode
                    : colors.backgroundColor,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.black,
                    size: 50,
                  ),
                ))
            : isGridView
                ? gridViewBlock(context, productProvider, categoryProvider)
                : listViewBlock(context, productProvider, categoryProvider),
      ),
    );
  }

  final ScrollController scrollController = ScrollController();

  gridViewBlock(BuildContext context, ProductProvider productProvider,
      CategoryProvider categoryProvider) {
    return Container(
      decoration: BoxDecoration(
        color: colors.isDarkMode
            ? colors.backgroundColorDarkMode
            : colors.backgroundColor,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              child: Row(
                children: [
                  Flexible(
                    child: SearchInputBlock(context, productProvider),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          colors.isDarkMode = !colors.isDarkMode;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        backgroundColor: colors.isDarkMode
                            ? colors.productBlockColorDarkMode
                            : colors.productBlockColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 0.0,
                      ),
                      child: colors.isDarkMode
                          ? Icon(
                              Icons.brightness_7_outlined,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.dark_mode_outlined,
                              color: Colors.black,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          backgroundColor: colors.isDarkMode
                              ? colors.productBlockColorDarkMode
                              : colors.productBlockColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0.0,
                        ),
                        child: Icon(
                          isGridView == true ? Icons.list : Icons.grid_view,
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filterBlock = !filterBlock;
                            if (!filterBlock) {
                              productProvider.getList();
                              valueDropdown = null;
                              iconOfRatingSort = Icons.unfold_more;
                              iconOfPriceSort = Icons.unfold_more;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          backgroundColor: colors.isDarkMode
                              ? colors.productBlockColorDarkMode
                              : colors.productBlockColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0.0,
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                        )),
                  ),
                ],
              ),
            ),
          ),
          filterBar(productProvider, categoryProvider),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: AnimationLimiter(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor,
                        Colors.transparent,
                        Colors.transparent,
                        colors.backgroundColor
                      ],
                      stops: [0.0, 0.01, 0.9, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: MasonryGridView.count(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: scrollController,
                    itemCount: productProvider.list.length + 1,
                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 20),
                    // the number of columns
                    crossAxisCount: 2,
                    // vertical gap between two items
                    mainAxisSpacing: 4,
                    // horizontal gap between two items
                    crossAxisSpacing: 4,
                    itemBuilder: (BuildContext context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 800),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                              child: index == 0
                                  ? Container(
                                      height: 100,
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 5),
                                      color: colors.isDarkMode
                                          ? colors.backgroundColorDarkMode
                                          : colors.backgroundColor,
                                      child: isSearched == true
                                          ? Text(
                                              "Found ${productProvider.list.length}\nResults",
                                              style: TextStyle(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black))
                                          : Text("All\nProducts",
                                              style: TextStyle(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black)),
                                    )
                                  : ProductBlock(context,
                                      productProvider.list[index - 1])),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  listViewBlock(BuildContext context, ProductProvider productProvider,
      CategoryProvider categoryProvider) {
    return Container(
      decoration: BoxDecoration(
        color: colors.isDarkMode
            ? colors.backgroundColorDarkMode
            : colors.backgroundColor,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              child: Row(
                children: [
                  Flexible(
                    child: SearchInputBlock(context, productProvider),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          colors.isDarkMode = !colors.isDarkMode;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        backgroundColor: colors.isDarkMode
                            ? colors.productBlockColorDarkMode
                            : colors.productBlockColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 0.0,
                      ),
                      child: colors.isDarkMode
                          ? Icon(
                              Icons.brightness_7_outlined,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.dark_mode_outlined,
                              color: Colors.black,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          backgroundColor: colors.isDarkMode
                              ? colors.productBlockColorDarkMode
                              : colors.productBlockColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0.0,
                        ),
                        child: Icon(
                          isGridView == true ? Icons.list : Icons.grid_view,
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filterBlock = !filterBlock;
                            if (!filterBlock) {
                              productProvider.getList();
                              valueDropdown = null;
                              iconOfRatingSort = Icons.unfold_more;
                              iconOfPriceSort = Icons.unfold_more;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          backgroundColor: colors.isDarkMode
                              ? colors.productBlockColorDarkMode
                              : colors.productBlockColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0.0,
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                        )),
                  ),
                ],
              ),
            ),
          ),
          filterBar(productProvider, categoryProvider),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: AnimationLimiter(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.backgroundColor,
                        Colors.transparent,
                        Colors.transparent,
                        colors.backgroundColor
                      ],
                      stops: [0, 0.01, 0.9, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: !isFilted
                      ? listViewAppearAnimation(productProvider)
                      : listViewSortAnimation(productProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  listViewAppearAnimation(ProductProvider productProvider) {
    return ListView.builder(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      controller: scrollController,
      itemCount: productProvider.list.length,
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 800),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: listViewItem(context, productProvider.list[index]),
            ),
          ),
        );
      },
    );
  }

  listViewSortAnimation(ProductProvider productProvider) {
    return ImplicitlyAnimatedList<ProductModel>(
      items: productProvider.list,
      itemBuilder: (context, animation, item, index) => SizeFadeTransition(
          sizeFraction: 0.7,
          animation: animation,
          key: Key(item.id.toString()),
          child: listViewItem(context, item)),
      areItemsTheSame: (a, b) => a.id == b.id,
    );
  }

  listViewItem(BuildContext context, ProductModel e) {
    return Container(
        height: MediaQuery.of(context).size.height / 6,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(SwipeablePageRoute(
              builder: (BuildContext context) => ProductDetail(Product: e),
            ));
          },
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: colors.isDarkMode
                  ? colors.productBlockColorDarkMode
                  : colors.productBlockColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Image.network(
                  e.image ?? "",
                  width: MediaQuery.of(context).size.width / 6.5,
                  height: MediaQuery.of(context).size.width / 6.5,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 9.5,
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "${e.rating.rate.toString()} ",
                              style: TextStyle(
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w400)),
                          WidgetSpan(
                            child: Icon(
                              Icons.star,
                              size: 14,
                              color: colors.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$" + e.price.toString(),
                      style: TextStyle(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cart.add(e, 1);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: colors.isDarkMode
                          ? colors.addToCartButtonColorDarkMode
                          : colors.addToCartButtonColor,
                      minimumSize: Size(45, 45)),
                  child: Icon(
                    Icons.card_travel,
                    size: 18,
                    color: colors.isDarkMode ? Colors.black : Colors.white,
                  ))
            ],
          ),
        ));
  }

  filterBar(
      ProductProvider productProvider, CategoryProvider categoryProvider) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
      decoration: BoxDecoration(
          color: colors.isDarkMode
              ? colors.productBlockColorDarkMode
              : colors.productBlockColor,
          borderRadius: BorderRadius.circular(20)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        width: MediaQuery.of(context).size.width,
        height: !filterBlock ? 0 : 100,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  items: categoryProvider.list
                      .map((item) => DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ))
                      .toList(),
                  value: valueDropdown,
                  onChanged: (value) {
                    setState(() {
                      indexOfPriceSort = 0;
                      indexOfRatingSort = 0;
                      iconOfPriceSort = Icons.unfold_more;
                      iconOfRatingSort = Icons.unfold_more;
                      isFilted = true;
                      _controller.clear();
                      valueDropdown = value;
                      selectedCategory = value as String;
                      productProvider.filterWithCategory(selectedCategory);
                    });
                  },
                  icon: const Icon(null),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colors.isDarkMode
                        ? colors.backgroundColorDarkMode
                        : colors.backgroundColor,
                  ),
                  buttonPadding: EdgeInsets.only(left: 10),
                  dropdownWidth: 150,
                  buttonHeight: 40,
                  buttonWidth: MediaQuery.of(context).size.width / 2.5,
                  itemHeight: 40,
                  dropdownDecoration: BoxDecoration(
                      color: colors.isDarkMode
                          ? colors.productBlockColorDarkMode
                          : colors.productBlockColor,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isFilted = true;
                      indexOfPriceSort++;
                      if (indexOfPriceSort == 0)
                        {
                          iconOfPriceSort = Icons.unfold_more;
                        }
                      if (indexOfPriceSort % 2 == 1) {
                        productProvider.isHighToLowPriceSort(true);
                        iconOfPriceSort = Icons.keyboard_arrow_up;
                        iconOfRatingSort = Icons.unfold_more;
                      }
                      if (indexOfPriceSort % 2 == 0 && indexOfPriceSort != 0) {
                        productProvider.isHighToLowPriceSort(false);
                        iconOfPriceSort = Icons.keyboard_arrow_down;
                        iconOfRatingSort = Icons.unfold_more;
                      }
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Price ",
                          style: TextStyle(
                              color: colors.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        WidgetSpan(
                          child: Icon(
                            iconOfPriceSort,
                            size: 17,
                            color: iconOfPriceSort == Icons.unfold_more
                                ? colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black
                                : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isFilted = true;
                      indexOfRatingSort++;
                      if (indexOfRatingSort == 0)
                        iconOfRatingSort = Icons.unfold_more;
                      if (indexOfRatingSort % 2 == 1) {
                        iconOfRatingSort = Icons.keyboard_arrow_up;
                        productProvider.isHighToLowRatingSort(true);
                        iconOfPriceSort = Icons.unfold_more;
                      }
                      if (indexOfRatingSort % 2 == 0 &&
                          indexOfRatingSort != 0) {
                        iconOfRatingSort = Icons.keyboard_arrow_down;
                        productProvider.isHighToLowRatingSort(false);
                        iconOfPriceSort = Icons.unfold_more;
                      }
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Rating ",
                          style: TextStyle(
                              color: colors.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        WidgetSpan(
                          child: Icon(iconOfRatingSort,
                              size: 17,
                              color: iconOfRatingSort == Icons.unfold_more
                                  ? colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.blue),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  var _controller = TextEditingController();

  ProductBlock(BuildContext context, ProductModel e) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 20, top: 5),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(SwipeablePageRoute(
            builder: (BuildContext context) => ProductDetail(Product: e),
          ));
        },
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: colors.isDarkMode
                ? colors.productBlockColorDarkMode
                : colors.productBlockColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: Center(
                      child: Image.network(
                        e.image ?? "",
                        height: 130,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text(
                    e.title ?? "",
                    style: TextStyle(
                        color: colors.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 13),
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${e.rating.rate.toString()} ",
                            style: TextStyle(
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w400)),
                        WidgetSpan(
                          child: Icon(
                            Icons.star,
                            size: 14,
                            color:
                                colors.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$" + e.price.toString(),
                      style: TextStyle(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            cart.add(e, 1);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: colors.isDarkMode
                                ? colors.addToCartButtonColorDarkMode
                                : colors.addToCartButtonColor,
                            minimumSize: Size(45, 45)),
                        child: Icon(
                          Icons.card_travel,
                          size: 18,
                          color:
                              colors.isDarkMode ? Colors.black : Colors.white,
                        ))
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  SearchInputBlock(BuildContext context, ProductProvider productProvider) {
    return Container(
      height: 50,
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextField(
          onChanged: (text) {
            (() async {
              await productProvider.getList();
              setState(() {
                productProvider.search(text);
              });
            })();
            setState(() {
              if (text.length > 0)
                isSearched = true;
              else
                isSearched = false;
            });
          },
          controller: _controller,
          autofocus: false,
          style: TextStyle(
              fontSize: 16.0,
              color: colors.isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              padding: EdgeInsets.only(bottom: 1),
              onPressed: () {
                (()async {
                  await productProvider.getList();
                })();
                _controller.clear();
              },
              icon: Icon(
                Icons.clear,
                size: 20,
                color: colors.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            filled: true,
            fillColor: colors.isDarkMode
                ? colors.productBlockColorDarkMode
                : colors.productBlockColor,
            hintText: 'Search...',
            hintStyle: TextStyle(
                color: colors.isDarkMode ? Colors.white : Colors.black87),
            contentPadding: EdgeInsets.only(top: 14, left: 15),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: colors.isDarkMode
                      ? colors.productBlockColorDarkMode
                      : Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: colors.isDarkMode
                      ? colors.productBlockColorDarkMode
                      : Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
