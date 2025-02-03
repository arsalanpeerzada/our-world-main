import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ourworldmain/constants/RemoteUtils.dart';

class Forgetpasswordcontroller extends GetxController {
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var otpCode = ''.obs;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sendOtp() async {
    isLoading(true);
    var url = Uri.parse(
        "${BaseURL.BASEURL}${ApiEndPoints.SENDOTP}?phoneNumber=${phoneController.text}");


    try {
      var request = http.Request('POST', url);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        isOtpSent(true);
        Get.snackbar("Success", "OTP sent successfully",
            snackPosition: SnackPosition.BOTTOM);
        print("Response: $responseBody"); // Log the response
      } else {
        Get.snackbar("Error", "Failed to send OTP: ${response.reasonPhrase}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOtp() async {
    isLoading(true);
    var url = Uri.parse(
        "${BaseURL.BASEURL}${ApiEndPoints.VERIFYOTP}?phoneNumber=${phoneController.text}&otp=${otpController.text}");

    try {
      var headers = {'Authorization': '••••••'};

      var request = http.Request('POST', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        String token = jsonResponse['data']['token'];
        final storage = GetStorage();
        storage.write('token', token);

        Get.snackbar("Success", "OTP Verified",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/home'); // Navigate to home screen
      } else {
        Get.snackbar("Error", response.reasonPhrase ?? "Invalid OTP",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
