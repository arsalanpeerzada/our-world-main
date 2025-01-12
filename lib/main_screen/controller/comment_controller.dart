import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ourworldmain/common/widgets.dart';
import 'package:ourworldmain/constants/RemoteUtils.dart';
import 'package:ourworldmain/constants/storage_constants.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/notifications.dart';
import 'package:ourworldmain/post/model/post_model.dart';

import '../../common/size_config.dart';
import '../../constants/app_colors.dart';
import '../../login/login_screen.dart';

class CommentController extends GetxController {
  final commentController = TextEditingController().obs;
  var commentList = <Comments>[].obs;
  var commentId = "".obs;
  var store = GetStorage();
  XFile? commentImage;
  var commentImagePath = "".obs;
  var isLoading = false.obs;
  String postId = "";

  Future<void> fetchComments(String id, String user) async {
    // Clear the existing comments list
    commentList.clear();
    isLoading.value = true;

    // Retrieve token (Replace this with your actual token retrieval logic)
    String? token = store.read('token');
    int? userId = store.read('userId');
    postId = id;

    if (token == null) {
      print("Token is null or invalid.");
      return;
    }

    // Setup headers
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.Request(
        'GET',
        Uri.parse("${BaseURL.BASEURL}${ApiEndPoints.GETCOMMENTS}?postId=$postId"),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody) as List;

        // Clear the current list to avoid duplicate entries
        commentList.clear();

        // Iterate over the JSON data and create Comments objects
        for (var item in jsonData) {
          commentList.add(
            Comments.fromJson(item), // Use the factory constructor to parse JSON
          );
        }
        isLoading.value = false;
        print("Comments fetched successfully.");
      } else {
        isLoading.value = false;
        print("Failed to fetch comments: ${response.reasonPhrase}");
      }
    } catch (e) {
      isLoading.value = false;
      print("Error fetching comments: $e");
    }

  }


  void sendMessage(String user) {
    if (commentController.value.text.isEmpty && commentImage == null) {
      showMessage(enterComment.tr);
    } else {
      if (store.read(userName) == "" || store.read(userName) == null) {
        //  showMessage(pleaseLoginFirstToCommentAPost.tr);
        showLoginDialog();
      } else {
        isLoading.value = true;
        var imageUrl = "";
        if (commentImage != null) {
          try {
            var filename = 'sightings/comments/${DateTime.now().toUtc().millisecondsSinceEpoch}.png';
          } catch (e) {
            showDebugPrint("Image upload excaption ----------->  $e");
          }
        } else {
          uploadComment(imageUrl,user);
        }
      }
    }
  }

  Future<void> openGallery() async {
    try {
      var pickedfile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfile != null) {
        commentImage = pickedfile;
        commentImagePath.value = commentImage!.path.toString();
      }
    } catch (e) {
      showDebugPrint("error while picking file.");
    }
  }

  Future<void> uploadComment(String imageUrl, String user) async {
    try {
      // Retrieve the token for the user
      String? token = store.read('token');
      int? userId = store.read('userId');

      if (token == null || token.isEmpty) {
        print("User token is not available");
        return;
      }

      // Prepare the headers
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      };

      // Prepare the request body
      var requestBody = {
        "userId": userId,
        "commentText": commentController.value.text,
      };

      // Create the request
      var request = http.Request(
        'POST',
        Uri.parse(BaseURL.BASEURL +
            ApiEndPoints.POSTCOMMENTS +
            "?postId=" +
            postId),
      );
      request.body = json.encode(requestBody);
      request.headers.addAll(headers);

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        String responseBody = await response.stream.bytesToString();
        print('Comment uploaded successfully: $responseBody');

        // Add the comment to the comment list
        commentList.value.add(
          Comments(
            commentController.value.text,
            store.read('userName'),
            store.read('userId').toString(),
            DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            imageUrl,
          ),
        );
        isLoading.value = false;
        commentController.value.text = "";
      } else {
        isLoading.value = false;
        print('Failed to upload comment. Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error uploading comment: $e");
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
                  headingText(pleaseLoginFirstToCommentAPost.tr,
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
