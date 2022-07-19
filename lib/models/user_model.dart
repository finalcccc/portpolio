// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';

class userModel {
  String id;
  String name;
  String birthday;
  String tel;
  String description;
  String image;
  userModel({
    required this.id,
    required this.name,
    required this.tel,
    required this.description,
    required this.birthday,
    required this.image,
  });

  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'name': name,
      'tel': tel,
      'birthday': birthday,
      'description': description,
      'image': image,
    };
  }

  factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      id: json['id'],
      name: json['name'],
      tel: json['tel'],
      birthday: json['birthday'],
      description: json['description'],
      image: json['image'],
    );
  }
}
