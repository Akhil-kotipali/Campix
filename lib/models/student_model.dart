import 'package:flutter/material.dart';

class StudentModel extends ChangeNotifier {
  String name;
  String studentId;
  String email;
  int points;

  StudentModel({
    required this.name,
    required this.studentId,
    required this.email,
    this.points = 0,
  });

  void addPoints(int amount) {
    points += amount;
    notifyListeners();
  }

  void redeemPoints(int amount) {
    if (points >= amount) {
      points -= amount;
      notifyListeners();
    }
  }
}
