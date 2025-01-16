import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourworldmain/about_us/view.dart';
import 'package:ourworldmain/constants/app_images.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/live_screen/ui/live_screen.dart';
import 'package:ourworldmain/main_screen/controller/main_screen_controller.dart';
import 'package:ourworldmain/main_screen/ui/comment_screen.dart';
import 'package:ourworldmain/post/model/post_model.dart';
import 'package:ourworldmain/profile_page/UserProfileScreen.dart';
import 'package:ourworldmain/terms/view.dart';

import '../../common/size_config.dart';
import '../../common/widgets.dart';
import '../../constants/app_colors.dart';
import '../../join_us/view.dart';
import '../../login/login_screen.dart';
import '../../post/ui/add_post.dart';
import 'banner.dart';

class MainScreen extends StatelessWidget {
  var controller = Get.put(MainScreenController());

  MainScreen({super.key}) {
    controller.fetchPosts();
  }

  final List<Map<String, dynamic>> hardcodedData = [
    {
      'user_id': '1',
      'streaming_token': 'token_123',
      'streaming_channel': 'channel_1',
      'user_name': 'John Doe',
      'user_image': '', // Replace with actual image URL or leave it empty
    },
    {
      'user_id': '2',
      'streaming_token': 'token_456',
      'streaming_channel': 'channel_2',
      'user_name': 'Jane Smith',
      'user_image': '',
    },
    {
      'user_id': '3',
      'streaming_token': 'token_789',
      'streaming_channel': 'channel_3',
      'user_name': 'Bob Johnson',
      'user_image': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    controller.mygetUserData(context);
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return SafeArea(
        child: Scaffold(
      key: key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorWhite,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                controller.mygetUserData(context);
                key.currentState!.openDrawer();
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
                child: Image.asset(
                  menu,
                  width: SizeConfig.blockSizeHorizontal * 6,
                  height: SizeConfig.blockSizeVertical * 2.8,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                controller.getUserData(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child:controller.isLoggedIn ? Image.asset(
                  live,
                  width: SizeConfig.blockSizeHorizontal * 9,
                  height: SizeConfig.blockSizeVertical * 5,
                ) : null,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddPostScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: controller.isLoggedIn ? Image.asset(
                  plus,
                  width: SizeConfig.blockSizeHorizontal * 6.5,
                  height: SizeConfig.blockSizeVertical * 2.8,
                ) : null,
              ),
            ),

              InkWell(
                onTap: () {
                  Get.to(() => LoginScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 12.0, bottom: 12.0),
                  child: !controller.isLoggedIn ? headingText(
                      enter, SizeConfig.blockSizeHorizontal * 5.2, colorBlack) : null,
                ),
              )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: colorScreenBg,
              ),
              child: InkWell(
                onTap: () {
                  if (controller.isLoggedIn) {
                    Get.to(() => UserProfileScreen());
                  } else {
                    Get.to(() => LoginScreen());
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    headingText(
                      "My Profile",
                      SizeConfig.blockSizeHorizontal * 4,
                      appColor,
                      weight: FontWeight.w600,
                    ),
                    CircleAvatar(
                      radius: 40,
                      // Adjust the size of the profile picture
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=3'),
                      // Default profile picture URL // Assuming profile picture URL is available in controller
                      backgroundColor:
                          Colors.grey.shade200, // Placeholder color
                    ),
                    // Name Label
                    headingText(
                      controller.isLoggedIn ? controller.applicationUser : "",
                      SizeConfig.blockSizeHorizontal * 4,
                      appColor,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: colorRed,
              ),
              title: headingText(
                  home.tr, SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle_outlined,
                color: colorRed,
              ),
              title: headingText(
                  aboutUs.tr, SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.ad_units_rounded,
                color: colorRed,
              ),
              title: headingText(termsConditions.tr,
                  SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
                color: colorRed,
              ),
              title: headingText(
                  joinUs.tr, SizeConfig.blockSizeHorizontal * 4, appColor,
                  weight: FontWeight.w400),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoinUsScreen()));
              },
            ),
            if (controller.isLoggedIn) // Check if user is logged in
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: colorRed,
                ),
                title: headingText(
                  signOut.tr,
                  SizeConfig.blockSizeHorizontal * 4,
                  appColor,
                  weight: FontWeight.w400,
                ),
                onTap: () {
                  controller.showLogoutDialog(context);
                },
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 15,
              child: ListView.builder(
                itemCount: hardcodedData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final userData = hardcodedData[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => LiveScreen(
                                  isHost: false,
                                  streamingUserIds: userData['user_id'],
                                  streamingToken: userData['streaming_token'],
                                  streamingJoiningId: "0",
                                  groupStreaming: false,
                                  hostId: "0",
                                  channelName: userData['streaming_channel'],
                                ));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.red, spreadRadius: 2),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            width: SizeConfig.blockSizeVertical * 10,
                            height: SizeConfig.blockSizeVertical * 10,
                            child: userData['user_image'] != null &&
                                    userData['user_image'] != '' &&
                                    userData['user_image'] != 'null'
                                ? Image.network(
                                    userData['user_image'],
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset('assets/images/profile3d.png'),
                          ),
                        ),
                      ),
                      headingText(
                        userData['user_name'] != null &&
                                userData['user_name'] != ""
                            ? userData['user_name']
                            : "user",
                        SizeConfig.blockSizeHorizontal * 3.2,
                        Colors.black,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: colorLightGreyBg,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  )),
              margin:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: controller.searchController.value,
                  cursorColor: colorRed,
                  onChanged: (value) {
                    controller.filterSearchResults(value);
                  },
                  enabled: true,
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 25,
                                    child: headingText(
                                        country.tr,
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                        colorBlack)),
                                Expanded(
                                  child: SizedBox(
                                    height: SizeConfig.blockSizeVertical * 6,
                                    child: Obx(
                                      () => DropdownButton2<int>(
                                        hint: Text(chooseCountry.tr,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        customButton: Container(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    6,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                              border: Border.all(
                                                  color: colorGrey, width: 0.7),
                                            ),
                                            child: Text(
                                              controller.selectedCountry == 0
                                                  ? chooseCountry.tr
                                                  : controller.selectedCountry ==
                                                          1
                                                      ? inArabRegion.tr
                                                      : controller.selectedCountry ==
                                                              2
                                                          ? inEurop.tr
                                                          : controller.selectedCountry ==
                                                                  3
                                                              ? inAmerica.tr
                                                              : controller.selectedCountry ==
                                                                      4
                                                                  ? inArabianGulfRegion
                                                                      .tr
                                                                  : controller.selectedCountry ==
                                                                          5
                                                                      ? inChina
                                                                          .tr
                                                                      : controller.selectedCountry ==
                                                                              6
                                                                          ? inTurkey
                                                                              .tr
                                                                          : inAnotherPlace
                                                                              .tr,
                                              textAlign: TextAlign.center,
                                            )),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        isDense: true,
                                        items: [0, 1, 2, 3, 4, 5, 6, 7]
                                            .map(
                                                (item) => DropdownMenuItem<int>(
                                                      value: item,
                                                      child: Text(
                                                        item == 0
                                                            ? chooseCountry.tr
                                                            : item == 1
                                                                ? inArabRegion
                                                                    .tr
                                                                : item == 2
                                                                    ? inEurop.tr
                                                                    : item == 3
                                                                        ? inAmerica
                                                                            .tr
                                                                        : item ==
                                                                                4
                                                                            ? inArabianGulfRegion.tr
                                                                            : item == 5
                                                                                ? inChina.tr
                                                                                : item == 6
                                                                                    ? inTurkey.tr
                                                                                    : inAnotherPlace.tr,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                            .toList(),
                                        value: controller
                                                    .selectedCountry.value ==
                                                0
                                            ? null
                                            : controller.selectedCountry.value,
                                        onChanged: (value) {
                                          controller.selectedCountry.value =
                                              value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 25,
                                    child: headingText(
                                        category.tr,
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                        colorBlack)),
                                Expanded(
                                  child: SizedBox(
                                    height: SizeConfig.blockSizeVertical * 6,
                                    child: Obx(
                                      () => DropdownButton2<int>(
                                        hint: Text(chooseCategory.tr,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        customButton: Container(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    6,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                              border: Border.all(
                                                  color: colorGrey, width: 0.7),
                                            ),
                                            child: Text(
                                              controller.selectedCategory == 0
                                                  ? chooseCategory.tr
                                                  : controller.selectedCategory ==
                                                          1
                                                      ? fashion.tr
                                                      : controller.selectedCategory ==
                                                              2
                                                          ? electronics.tr
                                                          : controller.selectedCategory ==
                                                                  3
                                                              ? toys.tr
                                                              : controller.selectedCategory ==
                                                                      4
                                                                  ? furniture.tr
                                                                  : controller.selectedCategory ==
                                                                          5
                                                                      ? beauty
                                                                          .tr
                                                                      : other
                                                                          .tr,
                                              textAlign: TextAlign.center,
                                            )),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        isDense: true,
                                        items: [0, 1, 2, 3, 4, 5, 6]
                                            .map((item) =>
                                                DropdownMenuItem<int>(
                                                  value: item,
                                                  child: Text(
                                                    item == 0
                                                        ? chooseCategory.tr
                                                        : item == 1
                                                            ? fashion.tr
                                                            : item == 2
                                                                ? electronics.tr
                                                                : item == 3
                                                                    ? toys.tr
                                                                    : item == 4
                                                                        ? furniture
                                                                            .tr
                                                                        : item ==
                                                                                5
                                                                            ? beauty.tr
                                                                            : other.tr,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        value: controller
                                                    .selectedCategory.value ==
                                                0
                                            ? null
                                            : controller.selectedCategory.value,
                                        onChanged: (value) {
                                          controller.selectedCategory.value =
                                              value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 5,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (controller.selectedCountry.value == 0) {
                                    showMessage(chooseCountry.tr);
                                  } else if (controller
                                          .selectedCategory.value ==
                                      0) {
                                    showMessage(chooseCategory.tr);
                                  } else {
                                    Navigator.pop(context);
                                    controller.filterButtonTap();
                                  }
                                },
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
                                            searchCountryName.tr,
                                            SizeConfig.blockSizeHorizontal * 4,
                                            colorWhite)))),
                          ],
                        ),
                      ),
                    );
                  },
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(color: colorBlack),
                  decoration: InputDecoration(
                    hintText: searchCountryName.tr,
                    hintStyle: const TextStyle(color: colorGrey),
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    prefixIcon: Container(
                      width: SizeConfig.blockSizeVertical * 1,
                      height: SizeConfig.blockSizeVertical * 1,
                      margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          search,
                          width: SizeConfig.blockSizeVertical * 3,
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.postList.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.postList.value.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            postRowItem(
                                controller.postList.value[index], context),
                            BannerAdmob()
                          ],
                        );
                      },
                    )
                  : SizedBox(
                      height: 300,
                      child: Center(
                        child: headingText(
                            controller.isLoggedIn
                                ? noDataFound1.tr
                                : noDataFound.tr,
                            SizeConfig.blockSizeHorizontal * 4,
                            colorGrey,
                            weight: FontWeight.w500),
                      ),
                    ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget storyRowItem(int index) {
    return const Padding(
        padding: EdgeInsets.all(5.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(dummyImage),
          radius: 40,
        ));
  }

  Widget postRowItem(PostModel list, BuildContext context) {
    return Obx(() {
      return controller.hiddenPosts.contains(list.id!)
          ? Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('This post is hidden'),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                    controller.showPost(list.id!).then((value) {
                      showMessage('Post is now shown');
                    });
                  },
                  child:
                      const Text('Show', style: TextStyle(color: Colors.blue)),
                )
              ]),
            )
          : Card(
              margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              elevation: 2,
              shadowColor: colorGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: headingText(list.username.toString(),
                              SizeConfig.blockSizeHorizontal * 5, colorBlack,
                              weight: FontWeight.w500),
                        ),
                        DropdownButtonHideUnderline(
                            child: DropdownButton2(
                          value: null,
                          customButton: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.black,
                          ),
                          items: [
                            "Report Spam",
                            "Report Nudity",
                            "Report Violence",
                            "Block User",
                            "Hide Post"
                          ]
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          dropdownStyleData: DropdownStyleData(
                            width: 180,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 8,
                            offset: const Offset(-20, 0),
                          ),
                          onChanged: (value) {
                            String text = '';
                            if (value == 'Report Spam') {
                              text = 'Report Spam';
                            } else if (value == 'Report Nudity') {
                              text = 'Report Nudity';
                            } else if (value == 'Report Violence') {
                              text = 'Report Violence';
                            } else if (value == "Block User") {
                              text = 'Block User';
                            } else if (value == 'Hide Post') {
                              text = 'Hide Post';
                            }
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      titlePadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      clipBehavior: Clip.antiAlias,
                                      title: Column(children: [
                                        Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(10),
                                            color: Colors.black,
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(value == "Block User"
                                              ? 'Are you sure you want to block this User?'
                                              : value == "Hide Post"
                                                  ? 'Are you sure you want to hide this post?'
                                                  : 'Are you sure you want to report this post?'),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (text == 'Block User') {
                                                    controller
                                                        .blockUser(
                                                            list.id!, text)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      showMessage(
                                                          'User Blocked SuccessFully');
                                                    });
                                                  } else if (text ==
                                                      'Hide Post') {
                                                    controller
                                                        .hidePost(list.id!)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      showMessage(
                                                          'Post hide sucessfully');
                                                    });
                                                  } else {
                                                    controller
                                                        .reportPost(
                                                            list.id!, text)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      showMessage(
                                                          'Post Reported SuccessFully');
                                                    });
                                                  }
                                                },
                                                child: const Text('Yes')),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel')),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ]),
                                    ));
                          },
                        ))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        // const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: headingText(
                              list.country == 1
                                  ? inArabRegion.tr
                                  : list.country == 2
                                      ? inEurop.tr
                                      : list.country == 3
                                          ? inAmerica.tr
                                          : list.country == 4
                                              ? inArabianGulfRegion.tr
                                              : list.country == 5
                                                  ? inChina.tr
                                                  : list.country == 6
                                                      ? inTurkey.tr
                                                      : inAnotherPlace.tr,
                              SizeConfig.blockSizeHorizontal * 3,
                              Colors.white,
                              weight: FontWeight.w500),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: headingText(
                                list.category == 1
                                    ? fashion.tr
                                    : list.category == 2
                                        ? electronics.tr
                                        : list.category == 3
                                            ? toys.tr
                                            : list.category == 4
                                                ? furniture.tr
                                                : list.category == 5
                                                    ? beauty.tr
                                                    : other.tr,
                                SizeConfig.blockSizeHorizontal * 3,
                                Colors.white,
                                weight: FontWeight.w500,
                                maxLines: 1),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  list.text.toString().isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 14.0, left: 14.0, top: 10, bottom: 10),
                          child: Text(
                            list.text.toString(),
                            maxLines: 25,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: colorBlack,
                                fontSize: SizeConfig.blockSizeHorizontal * 4),
                          ),
                        )
                      : Container(),
                  list.images!.isNotEmpty
                      ? SizedBox(
                          height: SizeConfig.blockSizeVertical * 50,
                          child: ListView.builder(
                            itemCount: list.images!.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index1) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: placeholder,
                                  image: list.images![index1].image.toString(),
                                  width: SizeConfig.screenWidth - 40,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                  Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => CommentScreen(
                              list.id.toString(), list.userId.toString()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            chat,
                            width: SizeConfig.blockSizeHorizontal * 6,
                            height: SizeConfig.blockSizeVertical * 4,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.shareLink();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            share,
                            width: SizeConfig.blockSizeHorizontal * 6,
                            height: SizeConfig.blockSizeVertical * 4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 2,
                      )
                    ],
                  )
                ],
              ));
    });
  }
}
