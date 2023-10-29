import 'package:flutter/cupertino.dart';
import 'package:to_do/model/my-class.dart';

class AuthProvider extends ChangeNotifier {
  MyUser? currentUser;

  void updateUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
