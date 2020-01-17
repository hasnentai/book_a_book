import 'package:book_a_book/service/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autovalidate = false;

  String _email;
  String _password;

  double deviceHeight;
  double deviceWidth;

  bool _isLoading = false;
  Map<String, dynamic> userInfo;
  http.Response response;
  int code;
  submitForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() => _autovalidate = true);
      return;
    }
    setState(() => _isLoading = true);

    try {
      //response = await controller.login(_email, _password);
      code = await LoginService().loginUser(_email, _password);

       if (code == 200) {
         setState(() => _isLoading = false);
         Navigator.pushNamed(context, "/home");
       }
       //Navigator.pushNamed(context, "/home");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF900F),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFF900F), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.light, //bottom bar icons
    ));

    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Raleway',
      ),
      home: new Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(child: loginPageBuilder(context)),
              _isLoading
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black45,
                      child: Center(child: CircularProgressIndicator()))
                  : Container()
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }

  Widget emailField() {
    return new TextFormField(
      initialValue: 'admin',
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        hasFloatingPlaceholder: true,
      ),
      // validator: validator.validateEmail,
      onSaved: (String val) => _email = val,
    );
  }

  Widget passwordField() {
    return TextFormField(
        initialValue: 'admin',
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          hasFloatingPlaceholder: true,
        ),
        // validator: validator.validatePassword,
        onSaved: (String val) => _password = val);
  }

  Widget loginPageBuilder(BuildContext context) {
    return Column(
      children: <Widget>[
        headerbuilder(context),
        Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Form(
                autovalidate: _autovalidate,
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: emailField(),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: passwordField(),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: submitForm,
                child: new Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(200.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF900F),
                          const Color(0xFFF46948)
                        ],
                        // whitish to gray
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius:
                              10.0, // has the effect of softening the shadow
                          // has the effect of extending the shadow
                          offset: Offset(
                            0, // horizontal, move right 10
                            8.0, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                    child: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                          size: 30.0,
                        ))),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget headerbuilder(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    return new Container(
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
                      child: new Icon(
                        Icons.close,
                        size: 30.0,
                        color: Colors.white,
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
                right: 6.0,
                top: 150.0,
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
                    size: (deviceHeight / 2) - 165,
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
                    fontSize: (deviceHeight / 50) + 10,
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
