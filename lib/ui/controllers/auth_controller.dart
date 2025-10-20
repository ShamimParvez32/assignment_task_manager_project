import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class AuthController {

  static String? _pinCode;

  static set setPinCode(String pin) {
    _pinCode = pin;
  }

  static String get getPinCode {
    return _pinCode ?? '';
  }

  static String? _email;

  static set setEmail(String email) {
    _email = email;
  }

  static String get getEmail {
    return _email ?? '';
  }

  static const String _accessTokenKey = 'token';
  static const String _userModelKey = 'user-data';

  static String? accessToken;
  static UserModel? userModel;

  static Future<void> saveUserData(UserModel model, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    accessToken = token;
    userModel = model;
  }

  static Future<void> updateUserData(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    userModel = model;
  }

  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    if (token != null) {
      String? userData = sharedPreferences.getString(_userModelKey);
      userModel = UserModel.fromJson(jsonDecode(userData!));
      accessToken = token;
    }
  }

  static Future<bool> isUserAlreadyLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    return token != null;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
