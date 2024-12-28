import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ourworldmain/common/widgets.dart';
import 'package:ourworldmain/constants/storage_constants.dart';

import '../constants/string_constants.dart';
import '../main_screen/ui/main_screen.dart';
import '../notifications.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final otpController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var otpVerificationId = "".obs;
  final storage = GetStorage();


  Future<void> loginToFirebase() async {
    if (nameController.value.text.isEmpty) {
      showMessage(enterYourName.tr);
    } else if (phoneController.value.text.isEmpty) {
      showMessage(enterYourPhoneNumber.tr);
    } else if (!phoneController.value.text.contains("+")) {
      showMessage(enterYourCountryCodeBeforePhoneNumber.tr);
    } else if (passwordController.value.text.isEmpty) {
      showMessage(enterYourPassword.tr);
    } else {
      isLoading.value = true;

    }
  }
}
