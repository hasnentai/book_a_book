import 'dart:async';
import 'dart:core';

import 'package:book_a_book/service/productdervice.dart';

import 'package:book_a_book/util/ratingcontrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String bookImage;
  final String bookName;
  final int bookPrice;
  final String bookDescription;
  final List bookAttributes;
  final String purchaseNote;
  final String rating;
  final String priceHtml;
  final String sortDec;
  final int starCount;
  final double avgRating;
  int radioValue;
  double newRating;
  int quantity;

  DetailPage(
      {this.id,
      this.bookName,
      this.bookAttributes,
      this.bookDescription,
      this.bookImage,
      this.bookPrice,
      this.purchaseNote,
      this.rating,
      this.priceHtml,
      this.sortDec,
      this.starCount = 5,
      this.quantity = 0,
      this.avgRating});
  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  TextEditingController emailController = new TextEditingController();
  TextEditingController reviewController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool postingComment = false;
  List<String> selectOptions;
  bool bookAdded = false;
  double deviceHeight;
  double deviceWidth;

  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    if (index >= widget.avgRating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > widget.avgRating - 1 && index < widget.avgRating) {
      icon = new Icon(
        Icons.star_half,
        color: Colors.white ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: Colors.white ?? Theme.of(context).primaryColor,
      );
    }
    return icon;
  }

  Widget buildStarc(BuildContext context, int index, int rating) {
    Icon icon;

    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Colors.black54,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: Colors.black54 ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: Colors.black54 ?? Theme.of(context).primaryColor,
      );
    }
    return icon;
  }

  TabController _tabController;
  VoidCallback onChanged;
  int rating = 2;
  String dropdownValue;
  List rentalOptions;
  int totalCartItems = 0;
  List<String> cartItems = [];
  bool detailsTab = true;
  double yAxis = 0.0;
  AnimationController animationController;
  Animation<double> animation;

  void initState() {
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    super.initState();
    checkCart();
    setState(() {
      rentalOptions = widget.bookAttributes[0].options;
      dropdownValue = rentalOptions[0];
      ProductService().getAllComments(widget.id.toString());
      animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      )..addListener(() => setState(() {}));

      animation = Tween(begin: 0.0, end: 150.0).animate(animationController);
    });

    _tabController.addListener(() {
      if (_tabController.index > 0) {
        detailsTab = false;
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> createPost(BuildContext context) async {
    setState(() {
      postingComment = true;
    });

    var client = new http.Client();
    String id = widget.id.toString();
    String reviewer = nameController.text;
    String reviewerEmail = emailController.text;
    String review = reviewController.text;
    int innerRating = this.rating;

    var response = await client.post(
        'https://bookabook.co.za/wp-json/wc/v3/products/reviews?consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&product_id=$id&reviewer=$reviewer&reviewer_email=$reviewerEmail&review=$review&rating=$innerRating');
    if (response.statusCode == 201) {
      setState(() {
        postingComment = false;
        final snackBar = SnackBar(content: Text('Comment posted !!'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    } else {
      setState(() {
        postingComment = false;
        final snackBar = SnackBar(content: Text('Some thing went wrong  !!'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    }
    client.close();
  }

  void addToCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.quantity == 0) {
      setState(() {
        widget.quantity = 1;
      });
    }

    setState(() {
      cartItems.add(widget.id.toString());
      prefs.setStringList('cart', cartItems.toSet().toList());

      totalCartItems = prefs.getStringList('cart').length.toInt();

      if (!(cartItems.contains(widget.id.toString()))) {
        bookAdded = false;
      } else {
        bookAdded = true;
      }

      if (!(bookAdded)) {
        setState(() {
          widget.quantity = 1;
        });
      }
    });
  }

  void removeFromCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.quantity == 0) {
      setState(() {
        bookAdded = false;
        cartItems.remove(widget.id.toString());
        prefs.setStringList('cart', cartItems.toSet().toList());
        totalCartItems = prefs.getStringList('cart').length.toInt();
      });
    } else {
      cartItems.remove(widget.id.toString());
      prefs.setStringList('cart', cartItems.toSet().toList());
      totalCartItems = prefs.getStringList('cart').length.toInt();
      print(cartItems);
    }
  }

  void checkCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getKeys().length > 0) {
        totalCartItems = prefs.getStringList('cart').length.toInt();
      }

      if (prefs.getStringList('cart').length > 0) {
        cartItems.addAll(prefs.getStringList('cart'));
        if (cartItems.contains(widget.id.toString())) {
          bookAdded = true;
          widget.quantity = 1;
        } else {
          bookAdded = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    void _handleRadioValueChange(int value) {
      setState(() {
        widget.radioValue = value;
      });
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFF900F),
          statusBarIconBrightness: Brightness.light),
    );

    /* Widget myBodyBuilder(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          headerbuilder(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                child: new Container(
                  child: new Text(
                    widget.bookAttributes[0].name,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Color(0xFFFF900F),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.bookAttributes[0].options.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: <Widget>[
                                new Radio(
                                  value: index,
                                  groupValue: widget.radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                    widget.bookAttributes[0].options[index]),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          new Text('Total Quantity :'),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5),
                                  border:
                                      new Border.all(color: Color(0xFFFF900F))),
                              child: new Row(
                                children: <Widget>[
                                  new GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        print('Remove ' +
                                            widget.quantity.toString());
                                        if (widget.quantity == 1) {
                                          widget.quantity = 1;
                                        } else {
                                          widget.quantity--;
                                        }

                                        if (widget.quantity <= 0) {
                                          bookAdded = false;
                                        } else {
                                          bookAdded = true;
                                        }
                                      });
                                    },
                                    child: new Icon(Icons.remove,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Text(
                                        widget.quantity.toString(),
                                        style: new TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.quantity++;
                                        print('hello');
                                        if (widget.quantity <= 0) {
                                          bookAdded = false;
                                        } else {
                                          bookAdded = true;
                                        }
                                      });
                                    },
                                    child: new Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        child: TabBar(tabs: [
                          Tab(text: 'Description'),
                          Tab(text: 'Reviews '),
                          Tab(text: 'Add Review')
                        ]),
                      ),
                      SizedBox(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: !(postingComment)
                                  ? TabBarView(
                                      children: [
                                        SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                        ),
                                      ],
                                    )
                                  : new Center(
                                      child: new CircularProgressIndicator()),
                            ),
                          ],
                        ),
                        height: 600.0,
                      ),
                    ],
                  ))
            ],
          )
        ],
      );
    }*/

    return new Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
          length: 3,
          child: new Column(
            children: <Widget>[
              Container(
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: 'Description',
                    ),
                    Tab(text: 'Reviews '),
                    Tab(text: 'Add Review')
                  ],
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: new TextStyle(fontSize: (deviceHeight / 100) + 8),
                ),
                decoration: new BoxDecoration(
                  color: Colors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0, // has the effect of softening the shadow
                      // has the effect of extending the shadow
                      offset: Offset(
                        0, // horizontal, move right 10
                        3.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          headerbuilder(context),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Row(
                              children: <Widget>[
                                Expanded(
                                    child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValue,
                                  items: rentalOptions
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(
                                        value.toString(),
                                        style: new TextStyle(
                                            fontSize: (deviceHeight / 100) + 8),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    'Select Rental Option',
                                    style: new TextStyle(
                                        fontSize: (deviceHeight / 100) + 8),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      new Text('Total Quantity :',
                                          style: new TextStyle(
                                              fontSize:
                                                  (deviceHeight / 100) + 8)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: new Container(
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.circular(5),
                                              border: new Border.all(
                                                  color: Color(0xFFFF900F))),
                                          child: new Row(
                                            children: <Widget>[
                                              Material(
                                                child: InkWell(
                                                  child: new GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (widget.quantity ==
                                                            0) {
                                                          widget.quantity = 0;
                                                        } else {
                                                          widget.quantity--;
                                                        }

                                                        if (widget.quantity <=
                                                            0) {
                                                          bookAdded = false;
                                                        } else {
                                                          bookAdded = true;
                                                        }
                                                        removeFromCart();
                                                      });
                                                    },
                                                    child: Container(
                                                      color: Color(0xFFFF900F),
                                                      child: new Icon(
                                                          Icons.remove,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: new Text(
                                                    widget.quantity.toString(),
                                                    style: new TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              ),
                                              new GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    widget.quantity++;
                                                    if (widget.quantity <= 0) {
                                                      bookAdded = false;
                                                    } else {
                                                      bookAdded = true;
                                                    }
                                                    addToCart();
                                                  });
                                                },
                                                child: Container(
                                                  color: Color(0xFFFF900F),
                                                  child: new Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: new Text(
                                  parse(widget.bookDescription)
                                      .body
                                      .text
                                      .trim(),
                                  style: new TextStyle(
                                      fontSize: (deviceHeight / 100) + 8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future:
                          ProductService().getAllComments(widget.id.toString()),
                      builder: (context, sanpshot) {
                        if (sanpshot.hasData) {
                          return new ListView.builder(
                              itemCount: sanpshot.data.length,
                              itemBuilder: (BuildContext context, index) {
                                if (sanpshot.data.length != 0) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                            margin: const EdgeInsets.only(
                                                right: 16.0),
                                            child: new CircleAvatar(
                                                child: (sanpshot.data[index]
                                                            .reviewer !=
                                                        "")
                                                    ? new Text(sanpshot
                                                        .data[index].reviewer[0]
                                                        .toUpperCase())
                                                    : new Text('U')),
                                          ),
                                          new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              (sanpshot.data[index].reviewer !=
                                                      "")
                                                  ? new Text(
                                                      sanpshot
                                                          .data[index].reviewer
                                                          .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subhead)
                                                  : new Text("Unkown"),
                                              new Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0),
                                                width: 200.0,
                                                child: new Text(parse(sanpshot
                                                        .data[index].review)
                                                    .body
                                                    .text),
                                              ),
                                              Container(
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0,
                                                          vertical: 0.0),
                                                      child: new Row(
                                                          children: new List
                                                                  .generate(
                                                              widget.starCount,
                                                              (i) => buildStarc(
                                                                  context,
                                                                  i,
                                                                  sanpshot
                                                                      .data[
                                                                          index]
                                                                      .rating)))))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return new Text('No Comments to Display');
                                }
                              });
                        } else {
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView(children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Add New Rating',
                              style: new TextStyle(
                                  fontSize: (deviceHeight / 100) + 8,
                                  fontWeight: FontWeight.w900),
                            ),
                            new StarRating(
                              rating: rating,
                              onRatingChanged: (rating) =>
                                  setState(() => this.rating = rating),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, bottom: 8.0),
                              child: new Text(
                                'Your Review',
                                style: new TextStyle(
                                    fontSize: (deviceHeight / 100) + 8,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            new TextFormField(
                              maxLines: 5,
                              controller: reviewController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hasFloatingPlaceholder: true,
                              ),
                              // validator: validator.validateEmail,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, bottom: 8.0),
                              child: new Text(
                                'Your Name ',
                                style: new TextStyle(
                                    fontSize: (deviceHeight / 100) + 8,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            new TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hasFloatingPlaceholder: true,
                              ),
                              // validator: validator.validateEmail,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, bottom: 8.0),
                              child: new Text(
                                'Your Email ',
                                style: new TextStyle(
                                    fontSize: (deviceHeight / 100) + 8,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            new TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hasFloatingPlaceholder: true,
                              ),
                              // validator: validator.validateEmail,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: new RaisedButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 14.0, horizontal: 18.0),
                                    child: new Text(
                                      'Submit',
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                    color: Theme.of(context).primaryColorDark,
                                    onPressed: () {
                                      if (reviewController.text.isEmpty) {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'Review feild can not be blank'));
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      } else if (nameController.text.isEmpty) {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'Name feild can not be blank'));
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      } else if (emailController.text.isEmpty) {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'Email feild can not be blank'));
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      } else {
                                        createPost(context);
                                      }
                                    }))
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              )
            ],
          )),
      appBar: new AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text(
          parse(widget.bookName).body.text,
          style: new TextStyle(color: Colors.white),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 18.0),
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Icon(Icons.shopping_cart),
                (totalCartItems != 0)
                    ? new Positioned(
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
                            '$totalCartItems',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : new Container()
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, animation.value),
        child: AnimatedSize(
          reverseDuration: new Duration(milliseconds: 190),
          vsync: this,
          duration: new Duration(milliseconds: 190),
          curve: Curves.easeInBack,
          child: FloatingActionButton.extended(
            onPressed: () {
              addToCart();
            },
            label: !(bookAdded)
                ? Text(
                    'Add To Cart',
                    style: TextStyle(color: Colors.white),
                  )
                : (totalCartItems <= 1)
                    ? Text(
                        'Check Out $totalCartItems Book',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        'Check Out $totalCartItems Books',
                        style: TextStyle(color: Colors.white),
                      ),
            icon: !(bookAdded)
                ? Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
            backgroundColor: !(bookAdded) ? Color(0xFFFF900F) : Colors.green,
            isExtended: true,
          ),
        ),
      ),
    );
  }

  Widget headerbuilder(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return new Container(
      height: MediaQuery.of(context).size.height / 2.3,
      width: MediaQuery.of(context).size.width,
      child: new Row(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: widget.bookName,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: new Container(
                    width: (deviceHeight / 10) + 58,
                    height: (deviceHeight / 10) + 105,
                    decoration: new BoxDecoration(
                        color: Colors.black26,
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black45,
                            offset: new Offset(1.0, 1.0),
                            blurRadius: 4.0,
                          )
                        ],
                        borderRadius: new BorderRadius.circular(10.0),
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(widget.bookImage))),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    parse(widget.bookName).body.text.trim(),
                    softWrap: true,
                    style: new TextStyle(
                        fontSize: (deviceHeight / 100) + 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                )),
                Container(
                    width: 200.0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(
                        widget.priceHtml,
                        style: new TextStyle(
                            fontSize: (deviceHeight / 100) + 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    )),
                Container(
                    width: 200.0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(
                        widget.sortDec.trim(),
                        maxLines: 2,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )),
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0.0),
                        child: new Row(
                            children: new List.generate(widget.starCount,
                                (index) => buildStar(context, index)))))
              ],
            ),
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
            // has the effect of extending the shadow
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
    );
  }
}
