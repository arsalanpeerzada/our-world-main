import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/size_config.dart';
import '../common/widgets.dart';
import '../constants/app_colors.dart';
import 'ForgetPasswordController.dart';

class Forgetpassword extends StatelessWidget {
  final Forgetpasswordcontroller controller = Get.put(
      Forgetpasswordcontroller());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(title: Text("OTP Login")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText("Enter Phone Number",
                  SizeConfig.blockSizeHorizontal * 4, colorBlack),
      
              buildTextField(
                  controller.phoneController, "Enter your phone number (966 XXXXXXXXX)"),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
      
              Obx(() =>
              controller.isOtpSent.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText("Enter OTP",
                      SizeConfig.blockSizeHorizontal * 4, colorBlack),
      
                  buildTextField(
                      controller.otpController, "Enter OTP"),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
      
                  headingText("Enter New Password",
                      SizeConfig.blockSizeHorizontal * 4, colorBlack),
      
                  buildTextField(
                      controller.passwordController, "Enter New Password", obscureText: true),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
      
                  Center(
                    child: ElevatedButton(
                      onPressed: controller.verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 10.0,
                      ),
                      child: Obx(() =>
                      controller.isLoading.value
                          ? CircularProgressIndicator(color: colorWhite)
                          : Text("Verify OTP",
                          style: TextStyle(color: colorWhite))),
                    ),
                  ),
                ],
              )
                  : Center(
                child: ElevatedButton(
                  onPressed: controller.sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 10.0,
                  ),
                  child: Obx(() =>
                  controller.isLoading.value
                      ? CircularProgressIndicator(color: colorWhite)
                      : Text("Send OTP", style: TextStyle(color: colorWhite))),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false}) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 6,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: colorRed,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.bottom,
        style: const TextStyle(color: colorBlack),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: colorGrey),
          filled: true,
          fillColor: colorWhite,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: colorGrey, width: 0.7),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: colorGrey),
          ),
        ),
      ),
    );
  }
}