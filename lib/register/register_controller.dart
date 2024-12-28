
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

  Future<void> register() async {
    if (nameController.value.text.isEmpty) {
      showMessage("Please enter your name");
    } else if (phoneController.value.text.isEmpty) {
      showMessage("Please enter your phone number");
    } else if (passwordController.value.text.isEmpty) {
      showMessage("Please enter your password");
    } else {
      isLoading.value = true;

      try {
        var headers = {'Content-Type': 'application/json'};
        var body = json.encode({
          "userName": nameController.value.text,
          "password": passwordController.value.text,
          "firstName": nameController.value.text,
          "lastName": nameController.value.text,
          "email": nameController.value.text+"@gmail.com",
          "phone": phoneController.value.text,
        });

        var response = await http.post(
          Uri.parse(BaseURL.BASEURL+ApiEndPoints.SIGNUP),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          /*var responseData = json.decode(response.body);
          print(responseData);*/
          showMessage("Registration successful");
        } else {
          //print("Error: ${response.reasonPhrase}");
          showMessage("Registration failed: UserName already exist");
        }
      } catch (e) {
        print("Exception: $e");
        showMessage("An error occurred. Please try again.");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void showMessage(String message) {
    Get.snackbar(
      "Alert",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

