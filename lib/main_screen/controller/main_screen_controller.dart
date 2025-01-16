import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ourworldmain/constants/RemoteUtils.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/main_screen/ui/main_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/size_config.dart';
import '../../common/widgets.dart';
import '../../constants/app_colors.dart';
import '../../constants/storage_constants.dart';
import '../../live_screen/ui/live_screen.dart';
import '../../login/login_screen.dart';
import '../../post/model/post_model.dart';
import 'package:http/http.dart' as http;

import '../../profile/model/profile_model.dart';

class MainScreenController extends GetxController {
  var postList = <PostModel>[].obs;
  var duplicatePostList = <PostModel>[].obs;
  final searchController = TextEditingController().obs;
  var userData =
      ProfileModel("", "", "", "", "", "", "", "", "", "", "", "", []).obs;
  var store = GetStorage();
  var username = "".obs;
  var selectedCountry = 0.obs;
  var selectedCategory = 0.obs;
  var applicationUser = "";
  var isLoggedIn = false;

  Timer? _timerForInter;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  BannerAd? bannerAd;
  var blockedUsers = <String>[].obs;
  var hiddenPosts = <String>[].obs;
  SharedPreferences? sharedPreferences;
  @override
  void dispose() {
    // TODO: implement dispose
    _timerForInter?.cancel();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  onInit() {
    super.onInit();

    loadAd();
    // loadBannerAd();
    _timerForInter = Timer.periodic(const Duration(minutes: 20), (result) {
      if (_interstitialAd != null) {
        _interstitialAd!.show();
      }
    });

   /* var data = store.read(userName);
    applicationUser = data;*/

  }

  final bannerAdId = Platform.isAndroid
      ? 'ca-app-pub-7968575513161002/7749256565'
      : 'ca-app-pub-3940256099942544/4411468910';

  final intrinsialAd = Platform.isAndroid
      ? 'ca-app-pub-7968575513161002/6704285123'
      : 'ca-app-pub-7968575513161002/8074643906';

  Future hidePost(String postId) async {
    if (!hiddenPosts.contains(postId)) {
      hiddenPosts.value.add(postId);
      hiddenPosts.refresh();

      print('~~~~~~~~${hiddenPosts.toSet()}');

      await sharedPreferences!.setStringList('hiddenPosts', hiddenPosts);
    }
  }

  Future showPost(String postId) async {
    hiddenPosts.value.remove(postId);
    hiddenPosts.refresh();
    print('~~~~~~~~${hiddenPosts.toSet()}');
    await sharedPreferences!.setStringList('hiddenPosts', hiddenPosts);
  }

  getHiddenPosts() async {
    try {
      String? token = store.read('token');
      int? userId = store.read('userId');

      // Check if the user is logged in
      if (userId == 0 || userId == null) {
        showLoginDialog();
      } else {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        };

        var request = http.Request(
            'GET',
            Uri.parse(BaseURL.BASEURL + ApiEndPoints.GETPOST + "?userId=" + userId.toString())
        );

        request.headers.addAll(headers);

        // Send the request
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          // Successfully received the response
          String responseBody = await response.stream.bytesToString();
          print('Response Body: $responseBody');

          // Parse the response JSON
          Map<String, dynamic> responseJson = json.decode(responseBody);

          if (responseJson['status'] == 'success' && responseJson['data'] != null) {
            // Clear old data
            hiddenPosts.clear();
            postList.clear();
            duplicatePostList.clear();

            // Loop through each post in the response data
            List<dynamic> postsData = responseJson['data'];
            for (var post in postsData) {
              // Create PostModel object for each post and add it to the list
              PostModel postModel = PostModel.fromJson(post); // Add to hiddenPostList
              postModel.text = post["postText"];
              postModel.username = post['userName'].toString();
              postModel.country = post['countryId'];
              postModel.category = post['categoryId'];
              postModel.id = post['postId'].toString();
              postModel.userId = post['userId'].toString();

              // Optionally, add to postList and duplicatePostList if needed
              postList.add(postModel);
              duplicatePostList.add(postModel);
            }
          }
        } else {
          print('Failed to load hidden posts. Status Code: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle error if the API call fails
      print("Error fetching hidden posts: $e");
    }
  }

  loadBannerAd() {
    BannerAd(
      adUnitId: bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  Future reportPost(String postId, String report) async {

  }

  Future blockUser(String postId, String report) async {
    // await FirebaseFirestore.instance
    //     .collection('reports')
    //     .add({'postId': postId, 'report': report});
    hidePost(postId);
  }

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
        adUnitId: intrinsialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            print('$ad------------- loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            print('-------------InterstitialAd failed to load: $error');
          },
        ));
  }


  showSubscriptionDialog(BuildContext context) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Subscription'),
        content: Text(yourTrialFinished.tr),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              Get.to(() => const LiveScreen(isHost: true,streamingUserIds:  "", streamingToken: "", streamingJoiningId: "0", groupStreaming: false, hostId: "0",channelName:  ''));
              // Get.to(() => PlanScreen(
              //       showFree: false,
              //     ));
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  Future<void> getUserData(BuildContext context) async {
    Future.delayed(const Duration(seconds: 1), () {
      String? uid = store.read(userId) ?? "";

      if (uid != "") {
        checkMembershipDate(context);
      } else {
        showLoginDialog();
      }
    });
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
                  headingText(pleaseLoginFirstToJoinALive.tr,
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
                            Get.off(() => LoginScreen());
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

  checkMembershipDate(BuildContext context) async {
  // Get.to(() => HostScreen());
      Get.to(() => const LiveScreen(isHost: true,streamingUserIds:  "", streamingToken: "", streamingJoiningId: "0", groupStreaming: true, hostId: "0",channelName:  ''));
    // print('aaaaaa');
    // showDebugPrint('aazzz');
    // int? subscibedDateInt = store.read(membershipDate);
    // showDebugPrint(subscibedDateInt.toString());
    // if (subscibedDateInt != null) {
    //   DateTime subscribedDate =
    //       DateTime.fromMillisecondsSinceEpoch(subscibedDateInt);

    //   DateTime now = DateTime.now();
    //   showDebugPrint(now.difference(subscribedDate).inMinutes.toString());
    //   print(subscribedDate);
    //   if (now.difference(subscribedDate).inMinutes > 0) {
    //     showSubscriptionDialog(context);
    //   } else {
    //     Get.to(() => LiveScreen(true, "", "", "0", false, "0", ''));
    //   }
    // } else {
    //   Get.to(() => PlanScreen(showFree: true));
    // }
  }

  filterButtonTap() async {
    postList.clear();
    duplicatePostList.clear();

  }

  fetchPosts() async {
    getHiddenPosts();

    Future.delayed(const Duration(milliseconds: 500), () async {
      postList.clear();
      duplicatePostList.clear();
    });
  }

  void filterSearchResults(String query) {
    List<PostModel> dummySearchList = [];
    dummySearchList.addAll(duplicatePostList);
    if (query.isNotEmpty) {
      List<PostModel> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.country
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      postList.clear();
      postList.addAll(dummyListData);
      postList.refresh();
      return;
    } else {
      postList.clear();
      postList.addAll(duplicatePostList);
      postList.refresh();
    }
  }

  Future<void> shareLink() async {
    await Share.share(
      postShareText.tr,
        subject: postShareSubject.tr,


        // title: "hi",
        // text: list.text == "" || list.text == null
        //     ? '\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Check 1st Image: ${list.images![0].image}'
        //     : list.images!.isEmpty
        //         ? '\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Content: ${list.text}'
        //         : 'Hi!!\n\n Watch the below post \n\n${list.username} from ${list.country} added a post having  \n\n Content: ${list.text} \n\n Check 1st Image: ${list.images![0].image}',
        // chooserTitle: 'Example Chooser Title'
        );
  }

/*void showCountriesDialog() {
    showDebugPrint("-------button click--------");
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        content: SizedBox(
            width: SizeConfig.screenWidth / 1.5,
            height: SizeConfig.blockSizeVertical * 14,
            child: ListView.builder(
              itemCount: controller.postList.value.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return postRowItem(controller.postList.value[index]);
              },
            )),
      ),
    );
  }*/

  void showLogoutDialog(BuildContext context) {
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
                  headingText(areYouSureToLogoutFromApp.tr,
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
                            Navigator.pop(context);
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
                                  cancel.tr,
                                  SizeConfig.blockSizeHorizontal * 3.5,
                                  colorBlack,
                                  weight: FontWeight.w500),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            store.erase();
                            username.value = "";
                           // await FirebaseAuth.instance.signOut();
                            Get.offAll(() => MainScreen());
                            Get.back();
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 18,
                            decoration: BoxDecoration(
                                color: colorRed,
                                border: Border.all(color: colorRed),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: headingText(
                                  ok.tr,
                                  SizeConfig.blockSizeHorizontal * 3.5,
                                  colorWhite,
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

  void mygetUserData(BuildContext context) {
    String? uid = store.read(userName) ?? "";
    String token = store.read('token') ?? "";

    if(uid != "") {
      print(uid);
      applicationUser = uid;
      isLoggedIn = true;
    }else {
      isLoggedIn = false;
    }
  }
}
