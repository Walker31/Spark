import 'package:flutter/foundation.dart';

class MyAppState extends ChangeNotifier {
  // Example state variables
  bool _isLoggedIn = false;
  String _username = '';

  // Getter for _isLoggedIn
  bool get isLoggedIn => _isLoggedIn;

  // Getter for _username
  String get username => _username;

  // Method to update login status
  void login(String username) {
    _isLoggedIn = true;
    _username = username;
    notifyListeners(); // Notifies listeners about the change
  }

  // Method to update logout status
  void logout() {
    _isLoggedIn = false;
    _username = '';
    notifyListeners(); // Notifies listeners about the change
  }
}
