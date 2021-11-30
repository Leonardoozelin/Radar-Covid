import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String name;
  final String city;
  final String state;

  User({required this.name, required this.city, required this.state});
}

class Users with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => [..._users];

  void addUser(User newUser) {
    _users.add(
      User(
        name: newUser.name,
        city: newUser.city,
        state: newUser.state,
      ),
    );
    notifyListeners();
  }

  void deleteUser(){
    _users.clear();
    notifyListeners();
  }
}
