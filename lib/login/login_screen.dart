import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ourworldmain/constants/RemoteUtils.dart';
import 'package:ourworldmain/main_screen/ui/main_screen.dart';
import 'package:ourworldmain/register/register_screen.dart';
import '../common/size_config.dart';
import '../common/widgets.dart';
import '../constants/app_colors.dart';
import 'package:http/http.dart' as http;
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Replace Firebase controller with a dummy controller
  var isLoading = false.obs;
  var isOtpSent = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
 // final otpController = TextEditingController();

  Future<void> login() async {
    // Placeholder for login logic
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(BaseURL.BASEURL + ApiEndPoints.LOGIN));
    request.body = json.encode({
      "username": nameController.text,
      "password": passwordController.text
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        // Extract token and user data
        String token = jsonResponse['data']['token'];
        int userId = jsonResponse['data']['user']['userId'];
        String username = jsonResponse['data']['user']['username'];
        List<dynamic> roles = jsonResponse['data']['user']['roles'];

        // Save the data and cookies to GetStorage
        final storage = GetStorage();
        storage.write('token', token);
        storage.write('userId', userId);
        storage.write('username', username);
        storage.write('roles', roles);


        // Display success message
        Get.snackbar("Alert", "Login Successful", snackPosition: SnackPosition.BOTTOM);
        Get.to(() => MainScreen());
      } else {
        // Handle error response
        Get.snackbar("Error", "Username or Password is incorrect", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Handle exceptions
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.blockSizeVertical * 4),
                    Center(
                      child: headingText(
                        "Login",
                        SizeConfig.blockSizeHorizontal * 7,
                        appColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 5),
                    headingText(
                      "Name",
                      SizeConfig.blockSizeHorizontal * 3.5,
                      colorBlack,
                      weight: FontWeight.w600,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    buildTextField(nameController, "Enter your name"),
                    SizedBox(height: SizeConfig.blockSizeVertical * 4),
                    headingText(
                      "Phone Number",
                      SizeConfig.blockSizeHorizontal * 3.5,
                      colorBlack,
                      weight: FontWeight.w600,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    buildTextField(phoneController, "Enter your phone number"),
                    SizedBox(height: SizeConfig.blockSizeVertical * 4),
                    headingText(
                      "Password",
                      SizeConfig.blockSizeHorizontal * 3.5,
                      colorBlack,
                      weight: FontWeight.w600,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    buildTextField(
                      passwordController,
                      "Enter your password",
                      obscureText: true,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 3),
                    Center(
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 15.0,
                        ),
                        child: SizedBox(
                          width: SizeConfig.screenWidth / 1.5,
                          height: SizeConfig.blockSizeVertical * 6,
                          child: Center(
                            child: headingText(
                              "Login",
                              SizeConfig.blockSizeHorizontal * 4,
                              colorWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 7),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // Placeholder for register navigation
                            /*Get.snackbar("Info", "Navigate to Register Screen");*/
                            Get.to(() => RegisterScreen());
                          },
                          child: headingText(
                            "Register Here",
                            SizeConfig.blockSizeHorizontal * 3.5,
                            colorBlack,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            // Placeholder for register navigation
                            /*Get.snackbar("Info", "Navigate to Register Screen");*/
                            Get.to(() => RegisterScreen());
                          },
                          child: headingText(
                            "Forget Password",
                            SizeConfig.blockSizeHorizontal * 3.5,
                            colorBlack,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(
                  () => isLoading.value ? commonLoader() : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller,
      String hint, {
        bool obscureText = false,
      }) {
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
