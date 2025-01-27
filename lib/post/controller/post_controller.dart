import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ourworldmain/common/widgets.dart';
import 'package:ourworldmain/constants/RemoteUtils.dart';
import 'package:ourworldmain/constants/storage_constants.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/login/login_screen.dart';

import '../../common/size_config.dart';
import '../../constants/app_colors.dart';
import '../../main_screen/ui/main_screen.dart';
import '../model/post_model.dart';

class PostController extends GetxController {
  var textController = TextEditingController().obs;
  var store = GetStorage();
  var imageFileList = <XFile>[].obs;
  var postData = PostModel("", "", "", "", "", 0, 0, null, null).obs;
  var imageUrlList = <String>[].obs;
  var isLoading = false.obs;
  var commentList = <Comments>[].obs;
  var selectedCountry = 0.obs;
  var selectedCategory = 0.obs;
  var isEdit = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserPost();
    isLoading.value = true;
  }

  getFromGallery() async {
    try {
      var pickedfiles = await ImagePicker().pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        if (pickedfiles.length > 5 - imageFileList.length) {
          showMessage(youCanOnlySelectUpto5Photos.tr);
        } else {
          // imageFileList.clear();
          imageFileList.value.addAll(pickedfiles);
          imageFileList.refresh();
          imageUrlList.clear();
          imageUrlList.refresh();
        }
      } else {
        showDebugPrint("No image is selected.");
      }
    } catch (e) {
      showDebugPrint("error while picking file.");
    }
  }

  Future<void> addPostButtonClick() async {
    if (selectedCountry.value == 0) {
      showMessage(chooseCountry.tr);
    } else if (selectedCategory.value == 0) {
      showMessage(chooseCategory.tr);
    } else if (textController.value.text.isEmpty &&
        imageFileList.value.isEmpty) {
      showMessage(cantShareEmptyPost.tr);
    } else {
      if (store.read(userId) == "" || store.read(userId) == null) {
        showMessage(pleaseLoginFirstToShareAPost.tr);
        showLoginDialog();
      } else {
        isLoading.value = true;
        uploadPost();
/*        if (imageUrlList.value.isNotEmpty) {

        } else {
          // uploading images on firebase store
          for (int i = 0; i < imageFileList.length; i++) {
            try {
              var filename =
                  'sightings/${DateTime.now().toUtc().millisecondsSinceEpoch}.png';


            } catch (e) {
              showMessage(e.toString());
              showDebugPrint("Image upload excaption ----------->  $e");
            }
          }
          uploadingConditionCheck();
        }*/
      }
    }
  }

  Future<void> uploadPost() async {
    try {
      // Retrieve token and userId from GetStorage
      String? token = store.read('token');
      int? userId = store.read('userId');

      if (token == null || userId == null) {
        Get.snackbar('Error', 'User is not authenticated.',
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false; // Close the loader
        return;
      }

      // Construct the request headers with authorization token
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      };

      // Construct the request body (Map) with named parameters for clarity
      var requestBody = {
        'userId': userId,
        'categoryId': selectedCountry.value,
        // Assuming this is an integer or string
        'countryId': selectedCategory.value,
        // Assuming this is an integer or string
        'postText': textController.value.text.trim(),
        'images': null,
        // Assuming this is a List of image URLs
      };

      // Initialize the HTTP request
      var request = http.Request(
          'POST', Uri.parse(BaseURL.BASEURL + ApiEndPoints.CREATEPOST));
      request.body = json.encode(requestBody); // Add the body to the request
      request.headers.addAll(headers); // Add headers

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Successfully received the response
        String responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');

        // Optionally, parse the response JSON if you need
        Map<String, dynamic> responseJson = json.decode(responseBody);
        if (responseJson['status'] == 'success') {
          Get.snackbar('Success', 'Post created successfully',
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          // Reset page data
          textController.value.clear();
          imageFileList.clear();
          selectedCountry.value = 0;
          selectedCategory.value = 0;

          // Navigate to the MainScreen
          Get.off(() => MainScreen());
        } else {
          Get.snackbar(
              'Error', 'Failed to create post: ${responseJson['message']}',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        // Handle failed request (non-200 status code)
        print('Request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
        Get.snackbar('Error', 'Failed to create post. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Handle errors that may occur during the request or data processing
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred while creating the post.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      // Close the loader in all cases
      isLoading.value = false;
    }
  }

  void uploadingConditionCheck() {
    Future.delayed(const Duration(seconds: 5), () {
      if (imageUrlList.value.length == imageFileList.value.length) {
        uploadPost();
      } else {
        uploadingConditionCheck();
      }
    });
  }

  fetchUserPost() async {
    // Retrieve token and userId from GetStorage
    String? token = store.read('token');
    int? userId = store.read('userId');

    if (token == null || userId == null) {
      Get.snackbar('Error', 'User is not authenticated.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false; // Close the loader
      return;
    }

    // Construct the request headers with authorization token
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };

    var url = Uri.parse(BaseURL.BASEURL +
        ApiEndPoints.GETPOSTBYID +
        "?userId=" +
        userId.toString());

    try {
      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseJson = json.decode(responseBody);
        print('Success: $responseBody');

        dynamic postsData = responseJson['data'];
        postData.value.userId = postsData['userId'].toString();
        postData.value.text = postsData["postText"];
        postData.value.username = postsData['userName'].toString();
        postData.value.country = postsData['countryId'];
        postData.value.category = postsData['categoryId'];
        postData.value.timestamp = postsData['updatedDate'];
        postData.value.id = postsData['postId'].toString();

        selectedCategory.value = postsData['categoryId'];
        selectedCountry.value = postsData['countryId'];
        textController.value.text = postsData["postText"];

        isEdit = true;
        isLoading.value = false;

        // If response is JSON, you can decode it
        var data = jsonDecode(responseBody);
        print(data); // Process the data as needed
      } else {
        print('Error: ${response.reasonPhrase}');
        isLoading.value = false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      isLoading.value = false;
    }
  }

   deletePostButtonClick() async {
     isLoading.value = true;
    String? authorizationToken = store.read('token');
    int? postId = store.read('userId');

    if (authorizationToken == null || authorizationToken.isEmpty) {
      print('Authorization token is missing or empty.');
      return;
    }

    var headers = {
      'Authorization': authorizationToken,
    };

    // Check if postId is null or invalid
    if (postId == null) {
      print('You dont have any post');
      return;
    }

    // Construct the URL for the request
    final uri = Uri.parse(
        '${BaseURL.BASEURL}${ApiEndPoints.DELETEPOST}?postId=$postId');

    try {
      // Create the DELETE request
      var request = http.Request('DELETE', uri);
      request.headers.addAll(headers);

      // Send the request
      http.StreamedResponse response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        // Handle successful response
        String responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        Get.snackbar('Success', 'Post deleted successfully');
        isLoading.value = false;

        textController.value.clear();
        imageFileList.clear();
        selectedCountry.value = 0;
        selectedCategory.value = 0;
      } else {
        // Handle error response
        print('Failed to delete post. Reason: ${response.reasonPhrase}');
        isLoading.value = false;
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error occurred while making the request: $e');
      isLoading.value = false;
    }
  }

  void showLoginDialog() {
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        content: SizedBox(
            width: SizeConfig.screenWidth / 1.5,
            height: SizeConfig.blockSizeVertical * 14,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  headingText(pleaseLoginFirstToShareAPost.tr,
                      SizeConfig.blockSizeHorizontal * 4.2, colorBlack,
                      weight: FontWeight.w500),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.to(() => LoginScreen());
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 18,
                            decoration: BoxDecoration(
                                color: colorWhite,
                                border: Border.all(color: colorRed),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: headingText(
                                  ok.tr,
                                  SizeConfig.blockSizeHorizontal * 3.5,
                                  colorBlack,
                                  weight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }
}
