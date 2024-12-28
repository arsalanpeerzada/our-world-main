import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ourworldmain/common/widgets.dart';
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

  fetchComments() async {
    commentList.value.clear();
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
  Future<String?> getTokenByUserId(String userId) async {
    try {
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }
  Future<void> uploadComment(String imageUrl,String user) async {
    String token = await getTokenByUserId(user)??"";

    if(token.isNotEmpty){
      await NotificationPlugin.sendNotificationFCM(token, newComment.tr,'${store.read(userName)} ${addedCommentOnYourPost.tr}');
    }
    commentList.value.add(Comments(
        commentController.value.text,
        store.read(userName),
        store.read(userId),
        (DateTime.now().toUtc().millisecondsSinceEpoch).toString(),
        imageUrl));

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
