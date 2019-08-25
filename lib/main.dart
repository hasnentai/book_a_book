import 'dart:io';

import 'package:book_a_book/screens/category.dart';
import 'package:book_a_book/screens/home.dart';
import 'package:book_a_book/screens/index.dart';
import 'package:book_a_book/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var routes = <String, WidgetBuilder>{
    "/login": (BuildContext context) => LoginScreen(),
    "/home": (BuildContext context) => HomeScreen(),
    "/category": (BuildContext context) => CategoryScreen()
  };
  String initialRoute = "/login";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF900F),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFF900F), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.light, //bottom bar icons
    ));
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Raleway',
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _auth();
  }

  void _auth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (null != prefs.getString("token")) {
      print(prefs.getString("token"));
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, "/home");
    } else {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _isLoading
            ? IndexScreen()
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black45,
                child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}
