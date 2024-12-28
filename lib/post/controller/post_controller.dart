import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourworldmain/common/widgets.dart';
import 'package:ourworldmain/constants/storage_constants.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/login/login_screen.dart';
import 'package:ourworldmain/notifications.dart';

import '../../common/size_config.dart';
import '../../constants/app_colors.dart';
import '../../main_screen/ui/main_screen.dart';
import '../model/post_model.dart';

class PostController extends GetxController {
  final textController = TextEditingController().obs;
  var store = GetStorage();
  var imageFileList = <XFile>[].obs;
  var postData = PostModel("", "", "", "", "", 0, 0, null, null).obs;
  var imageUrlList = <String>[].obs;
  var isLoading = false.obs;
  var commentList = <Comments>[].obs;
  var selectedCountry = 0.obs;
  var selectedCategory = 0.obs;

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

  // Future<void> _removeImage(String imageUrl) async {
  //   try {
  //     // Remove image from Firestore
  //     final firestore = FirebaseFirestore.instance;
  //     final postRef = firestore.collection('posts').doc(postId);
  //
  //     // Update Firestore document to remove image URL
  //     await postRef.update({
  //       'images': FieldValue.arrayRemove([imageUrl])
  //     });
  //
  //     // Optionally, delete the image from Firebase Storage
  //     final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
  //     await storageRef.delete();
  //
  //
  //   } catch (e) {
  //     print('Error removing image: $e');
  //   }
  // }


  Future<void> addPostButtonClick() async {
    if (selectedCountry.value == 0) {
      showMessage(chooseCountry.tr);
    } else if (selectedCategory.value == 0) {
      showMessage(chooseCategory.tr);
    } else if (textController.value.text.isEmpty &&
        imageFileList.value.isEmpty) {
      showMessage(cantShareEmptyPost.tr);
    } else {
      if (store.read(userName) == "" || store.read(userName) == null) {
        //  showMessage(pleaseLoginFirstToShareAPost.tr);
        showLoginDialog();
      } else {
        isLoading.value = true;

        if (imageUrlList.value.isNotEmpty) {
          uploadPost();
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
        }
      }
    }
  }

  Future<List<String>> getAllTokens() async {
    List<String> tokens = [];

    try {

    } catch (e) {
      print('Error getting tokens: $e');
    }

    return tokens;
  }

  Future<void> uploadPost() async {
    var map = {
      'userId': store.read(userId),
      'username': store.read(userName),
      'country': selectedCountry.value,
      'category': selectedCategory.value,
      'text': textController.value.text.trim(),
      'timestamp': (DateTime.now().toUtc().millisecondsSinceEpoch).toString(),
      'images': imageUrlList,
      'comments': commentList
    };
    showDebugPrint("userid ------------->  ${store.read(userId)}");

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

  }

  void deletePostButtonClick() {
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
