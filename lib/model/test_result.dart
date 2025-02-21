import 'dart:ui';

import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TestResult {
  final String id;
  final String userId;
  final String result;
  final int status;
  final String address;
  final DateTime createdAt;
  final String? category;
  final String? image;

  TestResult({
    required this.id,
    required this.userId,
    required this.result,
    required this.status,
    required this.address,
    required this.createdAt,
    required this.category,
    required this.image,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json["id"],
      userId: json["userId"],
      result: json["result"],
      status: json["status"],
      address: json["address"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      category: json["category"],
      image: json["image"],
    );
  }

  factory TestResult.create(String result, String address) {
    String response = result;
    response = response.replaceAll(">", "");
    response = response.replaceAll('<', '');
    response = response.replaceAll("+", "");
    response = response.replaceAll("\$", "");
    List<double> valueList = response.split(",").map((value) => double.parse(value)).toList();

    List<int> levelList = [];
    for(int i = 0; i < valueList.length; i++){
      levelList.add(valueList[i].level(i));
    }
    int status = levelList.fold(levelList[0], (prev, curr) => prev > curr ? prev : curr);
    return TestResult(
      id: const Uuid().v4(),
      userId: authManager.user.uid,
      result: result,
      status: status,
      createdAt: DateTime.now(),
      address: address,
      category: null,
      image: null,
    );
  }

  List<double> get valueList {
    String response = result;
    response = response.replaceAll(">", "");
    response = response.replaceAll('<', '');
    response = response.replaceAll("+", "");
    response = response.replaceAll("\$", "");
    List<double> valueList = response.split(",").map((value) => double.parse(value)).toList();
    return valueList;
  }

  List<int> get levelList {
    List<int> levelList = [];
    for(int i = 0; i < valueList.length; i++){
      levelList.add(valueList[i].level(i));
    }
    return levelList;
  }

  double get phValue => valueList[0];
  double get hardnessValue => valueList[1];
  double get totalAlkalinityValue => valueList[2];
  int get phLevel => levelList[0];
  int get hardnessLevel => levelList[1];
  int get totalAlkalinityLevel => levelList[2];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "result": result,
      "status": status,
      "address": address,
      "createdAt": createdAt,
      "category": category,
      "image": image,
    };
  }

  TestResult setCategory(String category) {
    return TestResult(
      id: id,
      userId: userId,
      result: result,
      status: status,
      address: address,
      createdAt: createdAt,
      category: category,
      image: image,
    );
  }

  TestResult setImage(String image) {
    return TestResult(
      id: id,
      userId: userId,
      result: result,
      status: status,
      address: address,
      createdAt: createdAt,
      category: category,
      image: image,
    );
  }

  String get statusText => status.resultText;
  Color get statusBackgroundColor => status.resultBackgroundColor;
  Color get statusTextColor => status.resultTextColor;

  factory TestResult.sample1() {
    String result = "+<6.2, 200, 100, 1000, 50, 2.5, 3, 2.7, 5, 5, 250, 40, 5, 800, 50, 50\$";
    String response = result;
    response = response.replaceAll(">", "");
    response = response.replaceAll('<', '');
    response = response.replaceAll("+", "");
    response = response.replaceAll("\$", "");
    List<double> valueList = response.split(",").map((value) => double.parse(value)).toList();

    List<int> levelList = [];
    for(int i = 0; i < valueList.length; i++){
      levelList.add(valueList[i].level(i));
    }
    int status = levelList.fold(levelList[0], (prev, curr) => prev > curr ? prev : curr);
    return TestResult(
      id: const Uuid().v4(),
      userId: authManager.user.uid,
      result: result,
      status: status,
      createdAt: DateTime.now(),
      address: "VA, Arlington",
      category: null,
      image: null,
    );
  }

  factory TestResult.sample2() {
    String result = "+>8.4, 100, 50, 500, 25, 1.5, 2, 1.4, 6, 4, 240, 30, 2, 1, 0, 40\$";
    String response = result;
    response = response.replaceAll(">", "");
    response = response.replaceAll('<', '');
    response = response.replaceAll("+", "");
    response = response.replaceAll("\$", "");
    List<double> valueList = response.split(",").map((value) => double.parse(value)).toList();

    List<int> levelList = [];
    for(int i = 0; i < valueList.length; i++){
      levelList.add(valueList[i].level(i));
    }
    int status = levelList.fold(levelList[0], (prev, curr) => prev > curr ? prev : curr);
    return TestResult(
      id: const Uuid().v4(),
      userId: authManager.user.uid,
      result: result,
      status: status,
      createdAt: DateTime.now(),
      address: "Burnage, Arlington",
      category: null,
      image: null,
    );
  }

  factory TestResult.sample3() {
    String result = "+3.5, 40, 10, 0, 45, 1.7, 1, 1.1, 0, 2, 100, 10, 1, 50, 10, 20\$";
    String response = result;
    response = response.replaceAll(">", "");
    response = response.replaceAll('<', '');
    response = response.replaceAll("+", "");
    response = response.replaceAll("\$", "");
    List<double> valueList = response.split(",").map((value) => double.parse(value)).toList();

    List<int> levelList = [];
    for(int i = 0; i < valueList.length; i++){
      levelList.add(valueList[i].level(i));
    }
    int status = levelList.fold(levelList[0], (prev, curr) => prev > curr ? prev : curr);
    return TestResult(
      id: const Uuid().v4(),
      userId: authManager.user.uid,
      result: result,
      status: status,
      createdAt: DateTime.now(),
      address: "Seoul, Korea",
      category: null,
      image: null,
    );
  }
}