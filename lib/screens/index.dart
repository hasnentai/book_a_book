import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  double deviceHeight;
  double deviceWidth;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    print(deviceHeight);
    print(deviceWidth);
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Raleway',
      ),
      home: new Scaffold(
        body: bodyBuilder(context),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: new Container(
                height: 1.0,
                color: Colors.white,
              ),
            ),
          ),
          new Text(
            'OR',
            style: new TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Container(
                height: 1.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyBuilder(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF900F),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFF900F), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.light, //bottom bar icons
    ));
    return new Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('res/images/loginbg.png'),
                  fit: BoxFit.cover)),
        ),
        Opacity(
          opacity: 0.94,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
                // whitish to gray
              ),
            ),
          ),
        ),
        iconBuilder(context)
      ],
    );
  }

  Widget iconBuilder(BuildContext context) {
    return Container(
      width: double.infinity,
      child: new Column(
        children: <Widget>[
          Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Hero(
                  tag: 'icon',
                  child: Icon(
                    Icons.class_,
                    size: (deviceHeight / 2) - 145,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Book a Book',
                  style: new TextStyle(
                      fontSize: (deviceHeight / 50) + 10, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: new Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                      decoration: new BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius:
                                                  6.0, // has the effect of softening the shadow
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                0, // horizontal, move right 10
                                                3.0, // vertical, move down 10
                                              ),
                                            )
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              new BorderRadius.circular(35.0)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            (deviceHeight / 80) + 10),
                                        child: new Text(
                                          'Login',
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFFF46948)),
                                        ),
                                      )))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Container(
                            height: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'OR',
                        style: new TextStyle(color: Colors.white),
                      ),
                      new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Container(
                            height: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: new Container(
                                      decoration: new BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius:
                                                  6.0, // has the effect of softening the shadow
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                0, // horizontal, move right 10
                                                3.0, // vertical, move down 10
                                              ),
                                            )
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              new BorderRadius.circular(35.0)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            (deviceHeight / 80) + 10),
                                        child: new Text(
                                          'Register',
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFFF46948)),
                                        ),
                                      )),
                                ))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
