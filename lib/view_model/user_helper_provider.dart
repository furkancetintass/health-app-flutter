import 'package:flutter/cupertino.dart';

class UserHelperProvider with ChangeNotifier {
  String _vki='20';
  String get vki => this._vki;

  set vki(String value) {
    this._vki = value;
  }
}
