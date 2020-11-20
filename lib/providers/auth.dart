import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  final _apiKey = 'AIzaSyDTHDlO71yjjdkhxgi3dtWzm-QWhuhsg0s';

  Future _authenticate(String email, String password, String urlPart) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlPart?key=$_apiKey';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = jsonDecode(response.body);
      if(resData['error'] != null)
        throw HttpException(resData['error']['message']);
    } catch (e) {
      throw e;
    }
  }

  Future signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
