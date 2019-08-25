import 'dart:async';
import 'dart:convert';

import 'package:book_a_book/modal/usermodal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<int> loginUser(String userId, String password) async {
    var client = new http.Client();
    int code;
    try {
      var response = await client.post(
          'https://bookabook.co.za/wp-json/jwt-auth/v1/token?username=$userId&password=$password');
      code = response.statusCode;
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        UserModal userInfo = new UserModal.formJson(data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", userInfo.token);
        prefs.setString("user_email", userInfo.userEmail);
        prefs.setString("user_nicename", userInfo.userNiceName);
        prefs.setString("user_display_name", userInfo.userDisplayName);
      }
    } catch (e) {
      print(e);
    } finally {}
    return code;
  }
}
