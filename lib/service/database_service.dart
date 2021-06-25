import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_health/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  final databaseReference = FirebaseDatabase.instance.reference();
  SharedPreferences prefs;
  String _email;
  String _password;
  String _username;
  String _lastLogin;
  String _platform;
  String _phone;
  get email => this._email;

 set email( value) => this._email = value;

  get password => this._password;

 set password( value) => this._password = value;

  get username => this._username;

 set username( value) => this._username = value;

  get lastLogin => this._lastLogin;

 set lastLogin( value) => this._lastLogin = value;

  get platform => this._platform;

 set platform( value) => this._platform = value;

  get phone => this._phone;

 set phone( value) => this._phone = value;

  String userId;

  DateTime dateTime = DateTime.now();
  var formatter = new DateFormat('dd.MM.yyyy');

  Future<void> createUser(String email, String username, String phone) async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    //prefs.setString("emailBackup", _email);

    databaseReference.child("users").child(userId).set({
      "email": email,
      "username": username,
      "platform": Platform.isAndroid ? "Android" : "IOS",
      "lastLogin": formatter.format(dateTime),
      "phone": phone,
      "id": userId,
    });
  }

  Future<bool> createDeleted() async {
    try {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("userId");
      databaseReference.child("DeletedUsers").child(userId).set({
        "email": _email,
        "username": _username,
        "deleteDate":
            DateFormat('dd.MM.yyyy').format(DateTime.now()).toString(),
        "platform": Platform.isAndroid ? "Android" : "IOS"
      });
      return true;
    } catch (e) {
      print('create delete fonk hata');
      return false;
    }
  }

  Future<dynamic> updateProfile(String updateUsername) async {
    try {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("userId");
      databaseReference.child("Users").child(userId).update({
        "username": updateUsername,
      });
      return true;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> createCalori(String gender,String age,String movement,String height,String weight) async {
     int dailyCalori;
     double vki;
     double doubleHeight;
    if(gender=='Erkek'){
        dailyCalori=66+(14*int.parse(weight))+(5*int.parse(height))-(6*int.parse(age));
        for(int i=0;i<4;i++)
        {
          if(movement==Constants.movementList[i])
            dailyCalori+=i*150;
        }
      doubleHeight=double.parse(height)/100;
      vki=int.parse(weight)/(doubleHeight*doubleHeight);

      try {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("userId");
      databaseReference.child("userInfo").child(userId).set({
        "height": height,
        "weight": weight,
        "age":age,
        "movement":movement,
        "gender":gender,
        "dailyCalori":dailyCalori,
        "vki":vki.toStringAsFixed(2)
      });
      return true;
    } catch (e) {
      print('create userInfo fonk hata');
      return false;
    }
      
        
    }
    else{
      dailyCalori=65+(10*int.parse(weight))+(2*int.parse(height))-(5*int.parse(age));
        for(int i=0;i<4;i++)
        {
          if(movement==Constants.movementList[i])
            dailyCalori+=i*100;
        }

         doubleHeight=double.parse(height)/100;
      vki=int.parse(weight)/(doubleHeight*doubleHeight);

      try {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("userId");
      databaseReference.child("userInfo").child(userId).set({
        "height": height,
        "weight": weight,
        "age":age,
        "movement":movement,
        "gender":gender,
        "dailyCalori":dailyCalori,
        "vki":vki.toStringAsFixed(2)
      });
      return true;
    } catch (e) {
      print('create userInfo fonk hata');
      return false;
    }
    }


  }

}
