import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  Map<String, dynamic> _userData = {
    'name': '',
    'imageUrl': '',
  };

  Map<String, dynamic> get user {
    return _userData;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String urlSegment, String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBQSLbbAzHw4sroCEvexTKn4fpJjB-4_vs";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw (HttpException(responseData['error']['message']));
      }
      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        },
      );
      prefs.setString('userData', userData);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchUserData() async {
    if (isAuth) {
      final url =
          'https://shop-app-f6161-default-rtdb.firebaseio.com/users/$userId.json?auth=$token';
      try {
        final response = await http.get(Uri.parse(url));
        final userData = json.decode(response.body);
        if (userData == null) return;
        _userData['name'] = userData['name'];
        _userData['imageUrl'] = userData['imageUrl'];
        print(userData);
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    }
  }

  Future<void> signup(
      String email, String password, String name, String imageUrl) async {
    await _authenticate("signUp", email, password);
    if (isAuth) {
      final url =
          'https://shop-app-f6161-default-rtdb.firebaseio.com/users/$userId.json?auth=$token';
      try {
        final response = await http.put(
          Uri.parse(url),
          body: json.encode(
            {
              'name': name,
              'imageUrl': imageUrl,
            },
          ),
        );
        if (response.statusCode >= 400) {
          throw HttpException('Something went wrong!');
        }
        _userData['name'] = name;
        _userData['imageUrl'] = imageUrl;
        notifyListeners();

        return response;
      } catch (e) {
        throw (e);
      }
    }
  }

  Future<void> login(String email, String password) async {
    await _authenticate("signInWithPassword", email, password);
    await fetchUserData();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (DateTime.now().isAfter(expiryDate)) return false;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await SharedPreferences.getInstance().then((value) => value.clear());
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
