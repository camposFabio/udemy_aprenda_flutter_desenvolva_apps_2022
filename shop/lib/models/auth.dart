import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions.dart/auth_exception.dart';
import 'package:shop/utils/constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;

  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate({
    required String email,
    required String password,
    required String urlFragment,
  }) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Contants.apiKey}";

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      String msg = body['error']['message'];
      int index = msg.indexOf(':');

      index = index < 0 ? msg.length : index;

      msg = msg.substring(0, index).trim();
      throw AuthException(msg);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.tryParse(body['expiresIn']) ?? 0,
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup({required String email, required String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlFragment: 'signUp',
    );
  }

  Future<void> login({required String email, required String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlFragment: 'signInWithPassword',
    );
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();

    Store.remove('userData').then(
      (_) => notifyListeners(),
    );
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();

    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
