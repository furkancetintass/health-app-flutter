import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum UserCase { OturumAcilmis, OturumAcilmamis, OturumAciliyor }

class AuthService with ChangeNotifier {
  String _isimSoyisim;
  String _email;
  String _password;
  String _currentUserName;
  String _userId;
  SharedPreferences prefs;
  String _newPassword;
  String _oldPassword;
  User user;
  String _locale;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String get locale => _locale;

  set locale(String value) {
    _locale = value;
    notifyListeners();
  }

  String get oldPassword => _oldPassword;

  set oldPassword(String value) => _oldPassword = value;
  String get newPassword => _newPassword;

  set newPassword(String value) => _newPassword = value;
  // ignore: unnecessary_getters_setters
  String get userId => _userId;
  set userId(String value) {
    _userId = value;
  }

  String get currentUserName => _currentUserName;
  set currentUserName(String value) => _currentUserName = value;

  String get isimSoyisim => _isimSoyisim;

  set isimSoyisim(value) {
    _isimSoyisim = value;
    notifyListeners();
  }

  String get email => _email;
  set email(value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;
  set password(value) {
    _password = value;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  UserCase _durum = UserCase.OturumAcilmamis;

  UserCase get durum => _durum;
  set durum(UserCase value) {
    _durum = value;
    notifyListeners();
  }

  AuthService() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  void _authStateChanged(User user) {
    if (user == null) {
      durum = UserCase.OturumAcilmamis;
    } else {
      durum = UserCase.OturumAcilmis;
    }
  }

  Future<void> createUserWithEmailandPassword(
      String email, String password, String isimSoyisim) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await Firebase.initializeApp();
    try {
      durum = UserCase.OturumAciliyor;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await _auth.currentUser.updateProfile(displayName: isimSoyisim);

      //currentUserName = _auth.currentUser.displayName;
      String usrId = _auth.currentUser.uid;
      userId = usrId;
      prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", usrId);
      //await prefs.setString("name", _auth.currentUser.displayName);
      await prefs.setString("userCase", "true");
      await prefs.setString("locale", "tr");

      void fcmSubscribe() {
        firebaseMessaging.subscribeToTopic(usrId);
      }

      fcmSubscribe();
    } on FirebaseAuthException catch (e) {
      durum = UserCase.OturumAcilmamis;
      if (e.code == 'email-already-in-use') {
        print('Bu e-mail zaten kullanılıyor.');
      }
    } on FirebaseAuthException catch (e) {
      durum = UserCase.OturumAcilmamis;
      if (e.code == 'invalid-email') {
        print('Bu e-mail zaten kullanılıyor.');
      }
    } catch (e) {
      durum = UserCase.OturumAcilmamis;
      print(e);
      return null;
    }
  }

  // ignore: missing_return
  Future<User> signInUserWithEmailandPassword(
    String email,
    String password,
  ) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await Firebase.initializeApp();

    try {
      durum = UserCase.OturumAciliyor;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      String usrId = _auth.currentUser.uid;

      prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", usrId);
      userId = usrId;
    } on FirebaseAuthException catch (e) {
      durum = UserCase.OturumAcilmamis;
      if (e.code == 'wrong-password') {
        print('Bu e-mail zaten kullanılıyor.');
      } else if (e.code == 'user-not-found') {
        print('Kullanıcı bulunamadı');
      }
    } catch (e) {
      durum = UserCase.OturumAcilmamis;
      print(e);
    }
  }

  Future<bool> signOut() async {
    try {
      durum = UserCase.OturumAcilmamis;
      user = null;
      prefs = await SharedPreferences.getInstance();

      void fcmUnSubscribe() {
        firebaseMessaging.unsubscribeFromTopic(prefs.getString("userId"));
      }

      fcmUnSubscribe();

      await _auth.signOut();
      prefs.setString("userId", "");
      prefs.setString("locale", "");
      // email=prefs.getString("email");
      // await prefs.setString("email", email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> updatePassword() async {
    try {
      EmailAuthCredential credential =
          EmailAuthProvider.credential(email: _email, password: oldPassword);
      await FirebaseAuth.instance.currentUser
          .reauthenticateWithCredential(credential);

      await _auth.currentUser.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print('Yanlış şifre');
        return e;
      }
    } catch (e) {
      debugPrint("hata çıktı" + e);
      return e;
    }
  }

  Future<bool> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      return true;
    } on Exception catch (_) {
      debugPrint("hata çıktı");
      return false;
    }
  }

  Future deleteUser() async {
    try {
      _auth.currentUser.delete();
      durum = UserCase.OturumAcilmamis;

      signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
