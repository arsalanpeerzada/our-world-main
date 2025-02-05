import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ourworldmain/constants/RemoteUtils.dart';
import 'package:ourworldmain/login/login_screen.dart';

class Forgetpasswordcontroller extends GetxController {
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var otpCode = ''.obs;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> sendOtp() async {
    String phoneNumber = phoneController.text;

    // Validation check for phone number
    if (phoneNumber.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    } else if (!RegExp(r'^[1-9]\d{8,14}$').hasMatch(phoneNumber)) {
      Get.snackbar(
        "Error",
        "Enter a valid phone number (9-15 digits) starting without '0'. Example: 966XXXXXXXX",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Proceed with OTP sending
    isLoading(true);
    var url = Uri.parse(
        "${BaseURL.BASEURL}${ApiEndPoints.SENDOTP}?phoneNumber=$phoneNumber");
    try {
      var request = http.Request('POST', url);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        isOtpSent(true);
        Get.snackbar(
          "Success",
          "OTP sent successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        print("Response: $responseBody"); // Log the response
      } else {
        Get.snackbar(
          "Error",
          "Failed to send OTP: ${response.reasonPhrase}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOtp() async {
    String phoneNumber = phoneController.text;
    String otp = otpController.text;
    String newPassword = passwordController.text;

    // Validation checks
    if (otp.isEmpty || otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
      Get.snackbar(
        "Error",
        "OTP must be a 6-digit number",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.isEmpty || newPassword.length <= 6) {
      Get.snackbar(
        "Error",
        "Password must be greater than 6 characters",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    } else if (newPassword.length >= 15) {
      Get.snackbar(
        "Error",
        "Password must be less than 15 characters",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Proceed with OTP verification
    isLoading(true);
    var url = Uri.parse(
      "${BaseURL.BASEURL}${ApiEndPoints.VERIFYOTP}?phoneNumber=${phoneController.text}&otp=${otpController.text}&newPassword=${passwordController.text}",);
    try {
      var request = http.Request('POST', url);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        String message = jsonResponse['message'];
        Get.snackbar(
          "Success",
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => LoginScreen());
      } else {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        String message = jsonResponse['message'];
        Get.snackbar(
          "Error",
          message ?? "Invalid OTP",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
