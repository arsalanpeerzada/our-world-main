import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:ourworldmain/constants/RemoteUtils.dart';

class Forgetpasswordcontroller extends GetxController {
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var otpCode = ''.obs;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sendOtp() async {
    isLoading(true);
    var url = Uri.parse("${BaseURL.BASEURL}/otp/send?phoneNumber=${phoneController.text}");

    var headers = {
      'Authorization': '••••••', // Replace with actual token
    };

    try {
      var request = http.Request('POST', url);
      request.headers.addAll(headers);

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
    var url = Uri.parse("https://yourapi.com/verifyOtp"); // Replace with actual API

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phone": phoneController.text, "otp": otpController.text}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String token = jsonResponse['data']['token'];

        final storage = GetStorage();
        storage.write('token', token);

        Get.snackbar("Success", "OTP Verified", snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/home'); // Navigate to home screen
      } else {
        Get.snackbar("Error", "Invalid OTP", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
