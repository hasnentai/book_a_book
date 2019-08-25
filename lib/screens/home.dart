/*
All Right Reserved - Trending Codes
 */

import 'dart:async';
import 'dart:convert';

import 'package:book_a_book/modal/category.dart';
import 'package:book_a_book/modal/productmodel.dart';
import 'package:book_a_book/screens/category.dart';
import 'package:book_a_book/screens/productdetail.dart';
import 'package:book_a_book/service/categoryservice.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Future<List<Category>> cats;
  List<Widget> bookShimmer = new List();
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isCatLoading = true;
  bool dataAvailable = false;
  double _maxScroll;
  double deviceHeight;
  double deviceWidth;
  AnimationController controller;
  Animation animation;
  Animation<double> opacityAnimation;
  Animation slideAnimation;
  bool visible = false;

  @override
  void initState() {
    for (int i = 0; i <= 9; i++) {
      bookShimmer.add(shimmerMaker());
    }
    super.initState();
    setState(() {
      this.getAllProducts(currentPage);
      cats = CategoryService().getCategory();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('calling');
        setState(() {
          currentPage++;
          this.getAllProducts(currentPage);
        });
      }
    });

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    animation = Tween(begin: -300.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    slideAnimation = Tween(begin: -600.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  Widget headerbuilder(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: Offset(0.0, animation.value),
          child: new Container(
            height: MediaQuery.of(context).size.height / 2.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    Positioned(
                        right: 10.0,
                        top: 0.0,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: GestureDetector(
                              onTap: () {
                               animationStop();
                              },
                              child: new Icon(
                                Icons.close,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ))),
                    Positioned(
                      left: 20.0,
                      child: Transform(
                        transform: Matrix4.rotationZ(0.2),
                        child: Opacity(
                          opacity: 0.6,
                          child: new Icon(
                            Icons.class_,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20.0,
                      top: 30.0,
                      child: Transform(
                        transform: Matrix4.rotationZ(0.5),
                        child: Opacity(
                          opacity: 0.7,
                          child: new Icon(
                            Icons.class_,
                            size: 60.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 130.0,
                      top: 110.0,
                      child: Transform(
                        transform: Matrix4.rotationZ(2.0),
                        child: Opacity(
                          opacity: 0.4,
                          child: new Icon(
                            Icons.class_,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.0,
                      top: 180.0,
                      child: Transform(
                        transform: Matrix4.rotationZ(3.0),
                        child: Opacity(
                          opacity: 0.6,
                          child: new Icon(
                            Icons.class_,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Hero(
                        tag: 'icon',
                        child: new Icon(
                          Icons.class_,
                          size: 200.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Book a Book',
                      style: new TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
                // whitish to gray
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0, // has the effect of softening the shadow
                 
                  offset: Offset(
                    0, // horizontal, move right 10
                    3.0, // vertical, move down 10
                  ),
                )
              ],
              borderRadius: new BorderRadius.vertical(
                  bottom: new Radius.elliptical(
                      MediaQuery.of(context).size.width, 100.0)),
            ),
          ),
        );
      },
    );
  }

  List<ProductModel> products;
  List<ProductModel> productsList;
  Future<void> getAllProducts(int currentPage) async {
    var client = new http.Client();
    try {
      var response = await client.get(
          'http://bookabook.co.za/wp-json/wc/v3/products?consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&order=asc&filter[meta_key]=total_sales&per_page=10&page=$currentPage&status=publish');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;

        if (list.length > 0) {
          dataAvailable = true;
          setState(() {
            products = list
                .map<ProductModel>((i) => ProductModel.fromJson(i))
                .toList();

            if (productsList != null) {
              products.map((i) {
                print(i);
                productsList.add(i);
              }).toList();
            } else {
              productsList = products;
            }
          });
        } else {
          setState(() {
            dataAvailable = false;
          });
        }
      } else {
        print('Somthing went wrong');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Widget customSlider(BuildContext context) {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            height: 200.0,
            decoration: new BoxDecoration(
                color: Colors.indigo,
                borderRadius: new BorderRadius.circular(20.0)),
          ),
        );
      },
      itemCount: 3,
      viewportFraction: 0.8,
      autoplay: true,
    );
  }

  Widget shimmerMaker() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400],
      highlightColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 180.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  new Container(
                    width: 130.0,
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    );
  }

  Widget homeBuild(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: true,
      bottom: true,
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(height: 200.0, child: customSlider(context)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text(
                            'Browse By Categories',
                            style: TextStyle(
                                fontSize: (deviceHeight / 100) + 10,
                                color: Color(0xFFFF900F),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(50.0),
                                  border:
                                      new Border.all(color: Color(0xFFFF900F))),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(Icons.arrow_forward_ios,
                                    size: (deviceHeight / 100) + 5),
                              )),
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: cats,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return new Container(
                          height: (deviceHeight + 370) * 0.1,
                          child: new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemExtent: (deviceHeight + 190) * 0.1,
                            itemBuilder: (context, i) {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    child: GestureDetector(
                                      child: Hero(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              border: new Border.all(
                                                  color: Colors.white),
                                              color: Colors.transparent),
                                          height: deviceHeight * 0.1,
                                          width: deviceHeight * 0.1,
                                          child: ClipRRect(
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'res/images/placeholder.png',
                                              image: (snapshot.data[i].image !=
                                                      null)
                                                  ? snapshot.data[i].image.src
                                                  : 'res/images/loginbg.png',
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(90.0),
                                          ),
                                        ),
                                        tag: snapshot.data[i].id.toString(),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryScreen(
                                                      id: snapshot.data[i].id,
                                                      imgSrc: (snapshot.data[i]
                                                                  .image !=
                                                              null)
                                                          ? snapshot
                                                              .data[i].image.src
                                                          : 'res/images/loginbg.png',
                                                      categoryName:
                                                          snapshot.data[i].name,
                                                    )));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text(
                                        snapshot.data[i].name,
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      width: 90.0,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: (deviceHeight + 370) * 0.1,
                              child: ListView.builder(
                                  itemCount: 10,
                                  itemExtent: (deviceHeight + 190) * 0.1,
                                  scrollDirection: Axis.horizontal,
                                  // Important code
                                  itemBuilder: (context, index) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[400],
                                        highlightColor: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              child: new Container(
                                                  height: deviceHeight * 0.1,
                                                  width: deviceHeight * 0.1,
                                                  decoration: new BoxDecoration(
                                                    color: Colors.black26,
                                                    boxShadow: [
                                                      new BoxShadow()
                                                    ],
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(90.0),
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 10,
                                                width: 90.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text(
                            'Listing Popular Rentals',
                            style: TextStyle(
                                fontSize: (deviceHeight / 100) + 10,
                                color: Color(0xFFFF900F),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                          child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(50.0),
                                  border:
                                      new Border.all(color: Color(0xFFFF900F))),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(Icons.arrow_forward_ios,
                                    size: (deviceHeight / 100) + 5),
                              )),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              (productsList == null)
                  ? SliverGrid.count(
                      crossAxisCount: 3,
                      childAspectRatio: deviceHeight / (deviceHeight + 600),
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: bookShimmer.map((item) {
                        return item;
                      }).toList())
                  : SliverGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      childAspectRatio: deviceHeight / (deviceHeight + 600),
                      children: productsList.map((item) {
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            id: item.id,
                                            bookAttributes: item.attri,
                                            avgRating: double.parse(
                                                item.averageRating),
                                            sortDec: parse(item.sortDescription)
                                                .body
                                                .text,
                                            purchaseNote:
                                                parse(item.purchaseNote)
                                                    .body
                                                    .text,
                                            bookName: item.name,
                                            bookDescription: item.description,
                                            bookImage: item.images[0].src,
                                            priceHtml: item.priceHtml)));
                              },
                              child: new Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height: (deviceHeight / 10) + 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Hero(
                                            tag: item.name,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  height:
                                                      (deviceHeight / 10) + 100,
                                                  child: ClipRRect(
                                                    child: new FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'res/images/placeholder.png',
                                                      image: item.images[0].src,
                                                      width:
                                                          (deviceHeight / 10) +
                                                              70,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      new BoxShadow(
                                                        color: Colors.black45,
                                                        offset: new Offset(
                                                            1.0, 1.0),
                                                        blurRadius: 4.0,
                                                      )
                                                    ],
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(15.0),
                                                  ),
                                                )
                                                /*new Container(
                                                  width: (deviceHeight / 10) + 70,
                                                  decoration: new BoxDecoration(
                                                      color: Colors.black26,
                                                      boxShadow: [
                                                        new BoxShadow(
                                                          color: Colors.black45,
                                                          offset:
                                                              new Offset(1.0, 1.0),
                                                          blurRadius: 4.0,
                                                        )
                                                      ],
                                                      borderRadius:
                                                          new BorderRadius.circular(
                                                              15.0),
                                                      image: new DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: new NetworkImage(
                                                              item.images[0].src))),
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Container(
                                        child: new Text(
                                      item.name,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0),
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Container(
                                        width: 140.0,
                                        child: new Text(
                                          item.priceHtml,
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.0,
                                              fontStyle: FontStyle.normal),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
              SliverList(
                delegate: SliverChildListDelegate([
                  (dataAvailable)
                      ? Container(
                          height: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoActivityIndicator(),
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: new Text('No More Books To Display'),
                            )
                          ],
                        )
                ]),
              )
            ],
          ),
         
          headerbuilder(context),
        ],
      ),
    );
  }

  animationStart() {
  
    controller.forward();
    
   
  }

  animationStop() {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
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
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Book A Book',
          ),
          leading: GestureDetector(
              child: new Icon(Icons.dashboard),
              onTap: () {
                animationStart();
              }),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 18.0),
              child: new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new Icon(Icons.shopping_cart),
                  new Positioned(
                    right: 0,
                    top: 6,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: new Text(
                        '1',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: homeBuild(context),
      ),
    );
  }
}
