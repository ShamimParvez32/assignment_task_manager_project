

import 'dart:convert';
import 'package:assignment_task_manager_project/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier{

   static String? accessToken;
   static UserModel? userModel;
   String? _pinCode;
   String? _email;



   String get getPinCode => _pinCode ?? '';
   set setPinCode(String pin) {
    _pinCode = pin;
  }

   String get getEmail => _email?? '';
   set setEmail(String email) {
    _email = email;
  }




  static const String _accessTokenKey='access-token';
  static const String _userDataKey='user-data';


   static Future<void> setUserData(String token, UserModel model)async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.setString(_accessTokenKey, token);
    sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));
    accessToken=token;
    userModel=model;
  }

   static Future<void> getUserData()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? token =sharedPreferences.getString(_accessTokenKey);
    String? userData=sharedPreferences.getString(_userDataKey);
    accessToken =token;
    userModel=UserModel.fromJson(jsonDecode(userData!));
   }


   static Future<bool>isUserLoggedIn()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? token =sharedPreferences.getString(_accessTokenKey);
    if(token !=null){
      getUserData();
      return true;
    }
    return false;
  }

   Future<void> updateUserData(UserModel model) async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));
     userModel = model;
     notifyListeners();

   }



  static Future<void> clearUserData()async{
   SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.clear();
 }
}
