import 'package:flutter/material.dart';

import '../models/user.dart';

class UsersProvider extends ChangeNotifier {
  List<User> _users = [];
  User? _currentUser; // Initial list of users

  // Method to fetch users (replace with actual data fetch logic)
  Future<void> fetchUsers() async {
    // Simulate fetching data from API or database
    _users = [
      User(
          userId: 1,
          userName: "John Doe",
          password: '',
          email: "john.doe@example.com",),
      // Add more users here
    ];
    notifyListeners(); // Notify listeners after data is updated
  }

  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Getter for users
  List<User> get users => _users;

  // Method to add a new user
  void addUser(name, phone, email, password) {
    User user = User(
        userId: _users.length + 1,
        userName: name,
        email: email,
        password: password,);
    _users.add(user);
    notifyListeners(); // Notify listeners after data is updated
  }

  void setUserDetails(String userName, String email) {
    _currentUser = User(
        userId: _users.length + 1, // Generate a new userId
        userName: userName,
        email: email,
        password: '',);
    notifyListeners(); // Notify listeners after data is updated
  }

  // Method to update an existing user
  void updateUser(User updatedUser) {
    // Find and update the user in the list
    final index =
        _users.indexWhere((user) => user.userId == updatedUser.userId);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners(); // Notify listeners after data is updated
    }
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  // Method to delete a user
  void deleteUser(User user) {
    _users.remove(user);
    notifyListeners(); // Notify listeners after data is updated
  }

  bool get isLoggedIn => _currentUser != null;

}
