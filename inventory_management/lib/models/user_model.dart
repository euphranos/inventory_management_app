// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:inventory_management/models/company_model.dart';

class UserModel {
  String userId;
  String name;
  String surName;
  String email;
  String password;
  String userPhotoUrl;
  bool isAdmin;
  CompanyModel companyOfUser;
  DateTime createdAt;
  UserModel({
    required this.userId,
    required this.name,
    required this.surName,
    required this.email,
    required this.password,
    required this.userPhotoUrl,
    required this.isAdmin,
    required this.companyOfUser,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'surName': surName,
      'email': email,
      'password': password,
      'userPhotoUrl': userPhotoUrl,
      'isAdmin': isAdmin,
      'companyOfUser': companyOfUser.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      surName: map['surName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      userPhotoUrl: map['userPhotoUrl'] as String,
      isAdmin: map['isAdmin'] as bool,
      companyOfUser:
          CompanyModel.fromMap(map['companyOfUser'] as Map<String, dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
