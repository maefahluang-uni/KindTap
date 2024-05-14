import 'package:flutter/material.dart';

class User {
  String id; // User ID
  String name;
  String email;
  String password;
  String phoneNumber;
  String address;
  double balance;
  bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    this.balance = 0.0, // Default balance is set to 0.0
    this.isVerified = false, // Default Verified is set to false
  });

  factory User.createUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    double balance = 0.0, // Default balance can be provided when creating user
    bool isVerified = false,
  }) {
    return User(
      id: UniqueKey().toString(),
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
      balance: balance,
      isVerified: isVerified,
    );
  }
}