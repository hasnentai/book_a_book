import 'dart:ui';

import 'package:book_a_book/modal/category.dart';
import 'package:book_a_book/modal/productmodel.dart';
import 'package:book_a_book/service/categoryservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatefulWidget {
  final int id;
  final String imgSrc;
  final String categoryName;

  CategoryScreen({this.id, this.imgSrc, this.categoryName});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen> {
  double deviceHeight;
  double deviceWidth;
  Future<List<ProductModel>> categoryDetails;
  int currentPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      categoryDetails =
          CategoryService().getCategoryDetails(widget.id, currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFF900F),
          statusBarIconBrightness: Brightness.light),
    );
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
        body: categoryBuilder(context),
      ),
    );
  }

  Widget categoryBuilder(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: deviceHeight / 2.5,
          floating: false,
          pinned: true,
          iconTheme: IconThemeData(color: Colors.white),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            collapseMode: CollapseMode.parallax,
            title: Text(
              widget.categoryName,
              style: TextStyle(
                fontSize: (deviceHeight / 100) + 10,
              ),
            ),
            background: Hero(
              child: new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: NetworkImage(widget.imgSrc),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.black26.withOpacity(0.6)),
                  ),
                ),
              ),
              tag: widget.id.toString(),
            ),
          ),
        ),
        FutureBuilder(
          future: categoryDetails,
          builder: (BuildContext context, snapshot) {
            Widget myBooks;
            var ratingColor;

            if (snapshot.hasData) {
              myBooks = SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, i) {
                  print(snapshot.data[i].averageRating);
                  if (double.parse(snapshot.data[i].averageRating) > 3.00) {
                    ratingColor = Colors.green;
                  } else if (double.parse(snapshot.data[i].averageRating) > 2.00) {
                    ratingColor = Colors.orangeAccent;
                  } else if (double.parse(snapshot.data[i].avarageRating) > 1.00) {
                    ratingColor = Colors.redAccent;
                  } else if (double.parse(snapshot.data[i].avarageRating) == 0.00){
                    ratingColor = Colors.red;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  offset: new Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                )
                              ],
                              color: Colors.transparent),
                          height: (deviceHeight / 20) + 100,
                          width: (deviceHeight / 105) + 100,
                          child: ClipRRect(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'res/images/placeholder.png',
                              image: (snapshot.data[i].images.length != 0)
                                  ? snapshot.data[i].images[0].src
                                  : 'res/images/loginbg.png',
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: (deviceHeight / 20) + 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data[i].name.toString().trim(),
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: prefix0.TextStyle(
                                        fontSize: (deviceHeight / 44),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 10.0),
                                  child: Text(
                                    (snapshot.data[i].sortDescription
                                                    .toString()
                                                    .trim()
                                                    .length >
                                                0 ||
                                            snapshot.data[i].sortDescription
                                                    .toString()
                                                    .trim() ==
                                                '')
                                        ? parse(snapshot.data[i].sortDescription
                                                .toString()
                                                .trim())
                                            .body
                                            .text
                                            .trim()
                                        : "Best Book To Read",
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 10.0),
                                  child: Text(
                                    snapshot.data[i].priceHtml
                                        .toString()
                                        .trim(),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: prefix0.TextStyle(
                                        fontSize: (deviceHeight / 44),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                     
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 10.0),
                                      child: Text(
                                        snapshot.data[i].averageRating
                                            .toString()
                                            .trim(),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: new prefix0.TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: snapshot.data.length,
              ));
              return myBooks;
            } else {
              myBooks =
                  SliverList(delegate: SliverChildBuilderDelegate((context, i) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[800],
                  highlightColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  offset: new Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                )
                              ],
                              color: Colors.transparent),
                          height: (deviceHeight / 20) + 100,
                          width: (deviceHeight / 105) + 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 20.0,
                                width: 200,
                                color: Colors.black12,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 20.0,
                                width: 100,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }));
              return myBooks;
            }
          },
        )
      ],
    );
  }
}
