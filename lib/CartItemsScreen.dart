import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidable/hidable.dart';
import 'model/CartItem.dart';
import 'Cart.dart' as cart;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:project1/Colors.dart' as colors;

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({Key? key}) : super(key: key);

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Color.fromARGB(255, 235, 234, 239);
    double shippingFee = cart.list.length>0?5.00:0;
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
            "Shopping Bag",
            style: TextStyle(color: colors.isDarkMode?Colors.white:Colors.black),
          ),
        ),
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30),
            child: new Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: colors.isDarkMode?colors.cartButtonColorDarkMode:colors.cartButtonColor,
                    borderRadius: BorderRadius.circular(15)),
                child: new GestureDetector(
                    onTap: () {},
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
        child: Column(
          children: [
            Expanded(
              child: SlidableAutoCloseBehavior(
                closeWhenTapped: true,
                closeWhenOpened: true,
                child: Container(
                  color: colors.isDarkMode?colors.backgroundColorDarkMode:colors.backgroundColor,
                  child: AnimationLimiter(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: cart.list.length,
                        controller: scrollController,
                        itemBuilder: (BuildContext context, index) {
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(milliseconds: 700),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: CartItemBlock(cart.list[index]),
                                ),
                              ));
                        },
                      ),
                    ),
                    ),
                  ),
                ),
              ),
            Container(
                color: colors.isDarkMode?colors.backgroundColorDarkMode:colors.backgroundColor,
                padding:
                    EdgeInsets.only(left: 30, right: 30, bottom: 50, top: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.white),
                      )),
                      child: BillBlock(
                          "Subtotal", cart.getTotal().toStringAsFixed(2)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.white),
                      )),
                      child: BillBlock("Shipping", shippingFee.toString()),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: BillBlock("Bag Total",
                          (cart.getTotal() + shippingFee).toStringAsFixed(2)),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(color: colors.isDarkMode?colors.backgroundColorDarkMode:colors.backgroundColor, ),
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: 50,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: colors.isDarkMode?Colors.white:Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {},
            child: SizedBox(
              height: kToolbarHeight,
              child: Center(child: Text("Proceed To Checkout", style: TextStyle(color: colors.isDarkMode?Colors.black:Colors.white),)),
            ),
          )

          //Row(
          //children: [
          // Checkbox(
          //   value: isAllChecked,
          //   onChanged: (value) {
          //     setState(() {
          //       Total = 0;
          //       for (int i = 0; i < widget.list.length; i++) {
          //         widget.list[i].isChecked = value!;
          //         isAllChecked = value!;
          //         Total += widget.list[i].total!;
          //       }
          //     });
          //   },
          // ),
          ),
    );
  }

  CartItemBlock(CartItem e){
    return Container(
      margin: EdgeInsets.only(top: 10, right: 30, left: 30),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: UniqueKey(),

        // The start action pane is the one at the left or the top side.
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(
            onDismissed: () {
              setState(() {
                cart.list.remove(e);
              });
            },
            key: Key(e.model.id.toString()),
          ),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) {
                setState(() {
                  cart.list.remove(e);
                });
              },
              borderRadius: BorderRadius.circular(20),
              backgroundColor: colors.isDarkMode?Colors.white:Colors.black,
              foregroundColor: colors.isDarkMode?Colors.black:Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          height: MediaQuery.of(context).size.height / 7,
          child: Row(
            children: [
              // Checkbox(
              //   value: e.isChecked,
              //   onChanged: (value) {
              //     setState(() {
              //       e.isChecked = value!;
              //       if (e.isChecked) {
              //         Total = Total + e.getTotal!;
              //         bool isAllItemChecked = true;
              //         for (int i = 0;
              //         i < widget.list.length;
              //         i++) {
              //           if (!widget.list[i].isChecked) {
              //             isAllItemChecked = false;
              //             break;
              //           }
              //         }
              //         isAllChecked = isAllItemChecked;
              //       } else {
              //         Total = Total - e.getTotal!;
              //         isAllChecked = false;
              //       }
              //     });
              //   },
              // ),
              Container(
                padding: EdgeInsets.all(10),
                height:
                MediaQuery.of(context).size.width / 4.5,
                width:
                MediaQuery.of(context).size.width / 4.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(20)),
                child:
                Image.network(e.model.image.toString()),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                    height:
                    MediaQuery.of(context).size.width / 4.5,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.model.title.toString(),
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15, color: colors.isDarkMode?Colors.white:Colors.black),
                        ),
                        Text(
                          e.model.category.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w200, color: colors.isDarkMode?Colors.white:Colors.black),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${e.getTotalPrice().toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: colors.isDarkMode?Colors.white:Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if(e.Quantity > 1)
                                          e.Quantity--;
                                      });
                                    },
                                    icon: Icon(
                                      Icons
                                          .remove_circle_outline,
                                      size: 20,
                                      color: colors.isDarkMode?Colors.white:Colors.black,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints:
                                    BoxConstraints(),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: Center(
                                        child: Text(e.Quantity
                                            .toString(), style: TextStyle(color: colors.isDarkMode?Colors.white:Colors.black),)),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        e.Quantity++;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 20,
                                      color: colors.isDarkMode?Colors.white:Colors.black,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints:
                                    BoxConstraints(),
                                  ),
                                ],
                              ),
                            )
                          ],
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
  BillBlock(String name, String money) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colors.isDarkMode?Colors.white:Colors.black
          ),
        ),
        Row(
          children: [
            Text(
              money,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: colors.isDarkMode?Colors.white:Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "USD",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: colors.isDarkMode?Colors.white:Colors.black),
            )
          ],
        )
      ],
    );
  }

/*  double CaculateTotal() {
    double total = 0;
    for (int i = 0; i < cart.list.length; i++) {
      total += cart.list.total!;
    }
    return total;
  }*/

  void deleteItem(CartItem e) {
    cart.list.remove(e);
  }

/*  void unCheckAll() {
    for (int i = 0; i < widget.list.length; i++) {
      widget.list[i].isChecked = false;
    }
  }*/
}
