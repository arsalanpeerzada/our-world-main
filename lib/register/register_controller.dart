
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ourworldmain/constants/RemoteUtils.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  var isLoading = false.obs;
  var storage = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

// Register method
  Future<void> register() async {
    String name = nameController.value.text;
    String phone = phoneController.value.text;
    String password = passwordController.value.text;

    // Perform validations
    if (!isValidName(name) || !isValidPhone(phone) || !isValidPassword(password)) {
      return;
    }

    // If all validations pass
    isLoading.value = true;

    try {
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({
        "userName": name,
        "password": password,
        "firstName": name,
        "lastName": name,
        "email": "$name@gmail.com",
        "phone": phone,
      });

      var response = await http.post(
        Uri.parse(BaseURL.BASEURL + ApiEndPoints.SIGNUP),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        showMessage("Registration successful");
      } else {
        showMessage("Registration failed: Username already exists");
      }
    } catch (e) {
      print("Exception: $e");
      showMessage("An error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void showMessage(String message) {
    Get.snackbar(
      "Alert",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool isValidName(String name) {
    if (name.isEmpty) {
      showMessage("Please enter your name");
      return false;
    } else if (name.length < 6) {
      showMessage("Name must be at least 6 characters long");
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(name)) {
      showMessage("Name must not contain special characters");
      return false;
    }
    return true;
  }

  bool isValidPhone(String phone) {
    if (phone.isEmpty) {
      showMessage("Please enter your phone number");
      return false;
    } else if (phone.length < 9 || phone.length > 15) {
      showMessage("Phone number must be between 9 and 15 digits");
      return false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      showMessage("Phone number must contain only digits");
      return false;
    }
    return true;
  }

  bool isValidPassword(String password) {
    if (password.isEmpty) {
      showMessage("Please enter your password");
      return false;
    } else if (password.length < 6 || password.length > 15) {
      showMessage("Password must be between 6 and 15 characters");
      return false;
    }
    return true;
  }
}

