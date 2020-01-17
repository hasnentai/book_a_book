import 'package:book_a_book/modal/productmodel.dart';
import 'package:flutter/material.dart';

class OrderPlaced extends StatefulWidget {
  final List<ProductModel> products;
  OrderPlaced({Key key, this.products}) : super(key: key);

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  Widget headerbuilder(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;

    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                  right: 10.0,
                  top: 0.0,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
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
                    child: Icon(
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
                    child: Icon(
                      Icons.class_,
                      size: 60.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 130.0,
                top: 90.0,
                child: Transform(
                  transform: Matrix4.rotationZ(2.0),
                  child: Opacity(
                    opacity: 0.4,
                    child: Icon(
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
                    child: Icon(
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
                  child: Icon(
                    Icons.check_circle,
                    size: 120.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  'Payment Successful',
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.vertical(
            bottom:
                Radius.elliptical(MediaQuery.of(context).size.width, 100.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.products);
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
         
          children: <Widget>[
            headerbuilder(context),
            
            Container(
              height: (deviceHeight / 50) + 200,
              child: ListView.builder(
                shrinkWrap: true,
                
                scrollDirection: Axis.horizontal,
                itemCount: widget.products.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: (deviceHeight / 20) + 100,
                      child: ClipRRect(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'res/images/placeholder.png',
                          image: widget.products[index].images[0].src,
                          width: (deviceHeight / 10) + 70,
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
                  );
                },
              ),
            ),
            SizedBox(height: 40.0,),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "/home");
              },
                          child: Container(
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
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text("Continue to Home",style:TextStyle(color:Colors.white))
                                ),
                              ),
            )
          ],
        ),
      ),
    );
  }
}
