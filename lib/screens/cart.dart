import 'dart:convert';

import 'package:book_a_book/modal/productmodel.dart';
import 'package:book_a_book/screens/order_placed.dart';
import 'package:book_a_book/util/cartbloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class MyCart extends StatefulWidget {
  MyCart({Key key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<ProductModel> products = List<ProductModel>();
  bool calledOnce = false;
  double totalPrice=0.0;

  Future<void> getAllProductsById(List id) async {
    calledOnce = true;
    print(id.length);
    id.forEach((i) async {
      var client = http.Client();
      try {
        var response = await client.get(
            'https://easyaccountz.com/wp/wp-json/wc/v3/products/$i?consumer_key=ck_bfa93e17af86e89b53ce162b1403b9ac49ca039d&consumer_secret=cs_14b596e385f7390dc649cc067effe489ed456647');
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          // print(data);
          //var list = data as List;

          products.add(ProductModel.fromJson(data));

          setState(() {});
          //print(products);

        } else {
          print('Somthing went wrong');
        }
      } catch (e) {
        print('here ' + e);
      } finally {
        client.close();
      }
    });
  }

  Widget shimmerMaker() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400],
      highlightColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 180.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: 30,
                    height: 10.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: 90,
                    height: 10.0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var bloc = Provider.of<CartBloc>(context);
    var cart = bloc.cart;
    var cartItems = cart.keys.toList();
    
    if (!calledOnce) {
      getAllProductsById(cartItems);
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Raleway',
        primaryTextTheme: TextTheme(
            title: TextStyle(
          color: Colors.white,
        )),
        primaryIconTheme: IconThemeData(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          bottomNavigationBar: cart.length > 0?BottomAppBar(
            color: Colors.white30,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Deliver Book To ",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.pin_drop,
                                color: Colors.deepOrange,
                              ),
                              Text("#233 My Home  2nd Floor, 3rd cross")
                            ],
                          )
                        ],
                      ),
                      Text("Change",
                          style: TextStyle(
                              color: Colors.redAccent,
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.underline)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Payment Mode",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'res/images/visa.png',
                                  height: 10.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Ending with xx 2299")
                              ],
                            )
                          ],
                        ),
                        Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderPlaced(
                                          products: products,
                                        )),
                              );
                            },
                            child:totalPrice>0.0? Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFF900F),
                                      const Color(0xFFF46948)
                                    ],
                                    // whitish to gray
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2.0,
                                        color: Colors.grey,
                                        offset: Offset(2.0, 2.0))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Place Order",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                        Text("Your Total is Rs 1300",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                            ):CupertinoActivityIndicator(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ):null,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Cart',
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          body: products.length > 0
              ? ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, index) {
                    var quntity;
                    double price;
                    cart.forEach((i, v) {
                      
                      if (i == products[index].id) {
                        quntity = v;
                        price = double.parse(products[index].price) *
                            double.parse(v.toString());
                            print(price);
                          totalPrice = totalPrice + price;
                      }
                       //print(price);
                      
                    });
                    
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: (deviceHeight / 40) + 100,
                            child: ClipRRect(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'res/images/placeholder.png',
                                image: products[index].images[0].src,
                                width: (deviceHeight / 40) + 70,
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 4.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 200.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        parse(products[index].name)
                                            .body
                                            .text
                                            .trim(),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: (deviceHeight / 100) + 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )),
                                Container(
                                    width: 200.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        parse(products[index].sortDescription)
                                            .body
                                            .text,
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )),
                                Container(
                                    width: 200.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        parse(products[index].price +
                                                ' x ' +
                                                quntity.toString() +
                                                ' = ' +
                                                price.toString())
                                            .body
                                            .text,
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: (deviceHeight / 100) + 10,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            color: Colors.redAccent,
                            iconSize: 22,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(20),
                          )
                        ],
                      ),
                    );
                  },
                )
              : cart.length > 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, index) {
                        return shimmerMaker();
                      },
                    )
                  : Center(
                      child: Text("Cart is Empty.Happy Shopping"),
                    )),
    );
  }
}
