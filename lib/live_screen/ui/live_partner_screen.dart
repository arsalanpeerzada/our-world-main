// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:get_storage/get_storage.dart';
import 'package:ourworldmain/common/size_config.dart';
import 'package:ourworldmain/common/widgets.dart';
import 'package:ourworldmain/constants/app_colors.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/profile/ui/profile_screen.dart';
import '../../constants/app_images.dart';
import '../../profile/model/profile_model.dart';
import '../controller/live_partner_controller.dart';
import '../model/chat_model.dart';
import '../model/streaming_request_model.dart';

class LivePartenerScreen extends StatelessWidget {
  var controller = Get.put(LivePartenerController());

  LivePartenerScreen(
      bool _isHost,
      streamingUserIds,
      streamingToken,
      String streamingJoiningId,
      bool groupStreaming,
      String hostId,
      String channelName, {super.key}) {
    controller.isHost.value = false;
    controller.isAcceptedByHost.value = true;
    controller.streamingUserId.value = streamingUserIds;
    controller.streamingJoiningId.value = streamingJoiningId;
    controller.hostId.value = hostId;
    controller.groupStreaming.value = groupStreaming;
    if (channelName != null && channelName.isNotEmpty) {
      controller.channelName.value = channelName;
    } else {
      controller.channelName.value =
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    print("I am hitting LivePartenerScreen audience");

    print(
        '~~~~~~~~~~~~~~$_isHost -- $streamingUserIds -- $streamingToken');
    print(
        '~~~~~~~~~~~~~~$streamingJoiningId -- $groupStreaming -- $hostId');
    //controller.fetchAudienceData(controller.streamingUserId.value);
    Future.delayed(const Duration(seconds: 2), () {
      if (controller.groupStreaming.value == true) {
        controller.isHost.value = true;
        controller.setupVideoSDKEngine();
        /* print("firebase remote user id ------->  ${controller
            .streamingJoiningId}");
        controller.users.value.add(int.parse(controller.streamingJoiningId.toString()));
        controller.users.value.add(int.parse(controller.hostId.toString()));
        controller.users.refresh();
        for(int i = 0; i< controller.users.length ; i++){
          showDebugPrint("--------------audience-----------  ${controller.users[i]}");
        }*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRtl = locale.languageCode == 'ar';
    print("the value of isrtl = $isRtl");
    return WillPopScope(
        onWillPop: () async {
          controller.backPressButton();
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Stack(
                  children: [
                    // Positioned.fill(
                    //   child: Container(
                    //       height: SizeConfig.screenHeight - 170,
                    //       decoration: BoxDecoration(border: Border.all()),
                    //       child: Obx(() => controller
                    //                           .isLoadingVideoView.value ==
                    //                       true &&
                    //                   controller.isHost.value == true ||
                    //               controller.users.isNotEmpty
                    //           ? _viewRows(isRtl)
                    //           : controller.isLoadingVideoView.value == true &&
                    //                       controller.isHost.value == false ||
                    //                   controller.users.isNotEmpty
                    //               ? _viewRows(isRtl)
                    //               : commonLoader())),
                    // ),
                    Positioned(
                      top: 0,
                      width: SizeConfig.screenWidth,
                      child: Container(
                        color: Colors.black38,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.storeButtonClick(controller
                                        .userData.value.store
                                        .toString());
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: headingText(
                                          myStore.tr,
                                          SizeConfig.blockSizeHorizontal * 3.2,
                                          Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 25,
                                  color: Colors.white24,
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Obx(
                                      () => controller.isHost.value == true
                                          ? InkWell(
                                              onTap: () {
                                                if (controller.showingListMode
                                                        .value !=
                                                    2) {
                                                  controller.showRequests();
                                                } else {
                                                  controller.hideList();
                                                }
                                                // Get.to(() => FollowRequestsScreen(
                                                //     controller
                                                //         .userData.value.userId
                                                //         .toString(),
                                                //     controller
                                                //         .followRequests.value,
                                                //     controller.uid.value,
                                                //     controller
                                                //         .streamingRequestsList
                                                //         .value));
                                              },
                                              child: controller.streamingUserId
                                                              .value !=
                                                          null &&
                                                      controller.streamingUserId
                                                          .value.isNotEmpty
                                                  ? StreamBuilder<
                                                          DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'live_streaming_requests')
                                                          .doc(controller
                                                              .streamingUserId
                                                              .value)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        int length = 0;
                                                        if (snapshot != null &&
                                                            snapshot.data !=
                                                                null &&
                                                            snapshot
                                                                .data!.exists &&
                                                            snapshot.data![
                                                                    'requests'] !=
                                                                null) {
                                                          length = snapshot
                                                              .data!['requests']
                                                              .length;
                                                        }

                                                        return headingText(
                                                            "${receiveARequest.tr}(${length > 0 ? length : 0})",
                                                            SizeConfig
                                                                    .blockSizeHorizontal *
                                                                3.2,
                                                            Colors.white);
                                                      })
                                                  : headingText(
                                                      "${receiveARequest.tr}(0)",
                                                      SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.2,
                                                      Colors.white),
                                            )
                                          : StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("followers")
                                                  .doc(controller
                                                      .streamingUserId.value)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                int length = 0;
                                                List<Followers> followersList =
                                                    [];
                                                bool exists = false;
                                                if (snapshot != null &&
                                                    snapshot.data != null &&
                                                    snapshot.data!.exists &&
                                                    snapshot.data![
                                                            'requests'] !=
                                                        null) {
                                                  List<dynamic> list = snapshot
                                                      .data!['requests'];

                                                  followersList = list
                                                      .map((e) =>
                                                          Followers.fromJson(e))
                                                      .toList();
                                                  length = followersList.length;

                                                  int index = followersList
                                                      .indexWhere((element) =>
                                                          element.userId ==
                                                          controller
                                                              .userID.value);
                                                  exists = index != -1;
                                                }

                                                print(
                                                    '>>>>>###>>>> $exists  ${controller.userID.value}');
                                                return InkWell(
                                                  onTap: () {
                                                    if (exists) {
                                                    } else {
                                                      controller
                                                          .followButtonClick(
                                                              controller
                                                                  .userData
                                                                  .value);
                                                    }
                                                  },
                                                  child: headingText(
                                                      exists
                                                          ? following.tr
                                                          : follow.tr,
                                                      SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.2,
                                                      exists
                                                          ? Colors
                                                              .greenAccent[400]!
                                                          : Colors.white),
                                                );
                                              }),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 25,
                                  color: Colors.white24,
                                ),
                                Obx(
                                  () => InkWell(
                                    onTap: () {
                                      if (controller.showingListMode.value ==
                                          1) {
                                        controller.hideList();
                                      } else {
                                        controller.showFollowers();
                                      }
                                      // Get.to(() => MyClientsScreen(
                                      //     controller.userData.value.userId
                                      //         .toString(),
                                      //     controller.myClientsList.value));
                                    },
                                    child: controller.userID.value != null &&
                                            controller.userID.value.isNotEmpty
                                        ? StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("followers")
                                                .doc(controller.userID.value)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              int length = 0;
                                              if (snapshot != null &&
                                                  snapshot.data != null &&
                                                  snapshot.data!.exists &&
                                                  snapshot.data!['requests'] !=
                                                      null) {
                                                length = snapshot
                                                    .data!['requests'].length;
                                              }
                                              return Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: headingText(
                                                      '${myClients.tr}(${length > 0 ? length : 0})',
                                                      SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.2,
                                                      Colors.white),
                                                ),
                                              );
                                            })
                                        : Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: headingText(
                                                  '${myClients.tr}(0)',
                                                  SizeConfig
                                                          .blockSizeHorizontal *
                                                      3.2,
                                                  Colors.white),
                                            ),
                                          ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 25,
                                  color: Colors.white24,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ProfileScreen(
                                        controller.userData.value,
                                        controller.enableTextField.value));
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: headingText(
                                          myProfile.tr,
                                          SizeConfig.blockSizeHorizontal * 3.2,
                                          Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              height: 1,
                              color: Colors.white24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.isLoading.value == true
                          ? SizedBox(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight,
                              child: Center(child: commonLoader()))
                          : Container(),
                    ),
                    Obx(
                      () => controller.chatList.isNotEmpty
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.screenHeight / 1.8),
                                height: 220,
                                child: ListView.builder(
                                  itemCount: controller.chatList.value.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return chatRowItem(
                                        controller.chatList.value[index],
                                        index);
                                  },
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),

                    // controller.streamingUserId.value != null &&
                    //         controller.streamingUserId.value.isNotEmpty
                    //     ? StreamBuilder<DocumentSnapshot>(
                    //         stream: FirebaseFirestore.instance
                    //             .collection('accepted_live_request')
                    //             .doc(controller.streamingUserId.value)
                    //             .snapshots(),
                    //         builder: (context, snapshot) {
                    //           bool exists = false;
                    //           if (snapshot != null &&
                    //               snapshot.data != null &&
                    //               snapshot.data!.exists &&
                    //               snapshot.data!['requests'] != null) {
                    //             List<dynamic> list = snapshot.data!['requests'];

                    //             int index = list.indexWhere((element) =>
                    //                 element['senderId'] ==
                    //                 controller.userID.value);
                    //             exists = index != -1;
                    //           }

                    //           if (exists && !controller.isHost.value) {
                    //             print('><>>>>>>>>>>>> rejoining');
                    //             controller.rejoinAsBroadcaster();
                    //           }

                    //           return Container();
                    //         })
                    //     : Container(),
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Obx(
                        () =>
                            controller.isHost.value == false &&
                                    controller.isAcceptedByHost.value == false
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          controller.backPressButton();
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black38,
                                          ),
                                          width: 30,
                                          height: 30,
                                          child: const Icon(
                                            Icons.chevron_left,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      controller.streamingUserId.value !=
                                                  null &&
                                              controller.streamingUserId.value
                                                  .isNotEmpty
                                          ? StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(
                                                      'live_streaming_requests')
                                                  .doc(controller
                                                      .streamingUserId.value)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                int length = 0;
                                                List<StreamingRequestsModel>
                                                    streamingRequestsModelList =
                                                    [];
                                                bool exists = false;
                                                if (snapshot != null &&
                                                    snapshot.data != null &&
                                                    snapshot.data!.exists &&
                                                    snapshot.data![
                                                            'requests'] !=
                                                        null) {
                                                  List<dynamic> list = snapshot
                                                      .data!['requests'];

                                                  streamingRequestsModelList = list
                                                      .map((e) =>
                                                          StreamingRequestsModel
                                                              .fromJson(e))
                                                      .toList();
                                                  length =
                                                      streamingRequestsModelList
                                                          .length;

                                                  int index =
                                                      streamingRequestsModelList
                                                          .indexWhere((element) =>
                                                              element
                                                                  .senderUserId ==
                                                              controller.userID
                                                                  .value);
                                                  exists = index != -1;
                                                }
                                                showDebugPrint(
                                                    '~~~~~~#### $length');

                                                return length < 3
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (!exists) {
                                                            controller
                                                                .sendLiveStreamingRequest(
                                                                    streamingRequestsModelList,"", 50);
                                                          }
                                                        },
                                                        child: StreamBuilder<
                                                                DocumentSnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'live_streaming_requests')
                                                                .doc(controller
                                                                    .streamingUserId
                                                                    .value)
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              int length = 0;
                                                              List<StreamingRequestsModel>
                                                                  streamingRequestsModelList =
                                                                  [];
                                                              bool exists =
                                                                  false;
                                                              if (snapshot !=
                                                                      null &&
                                                                  snapshot.data !=
                                                                      null &&
                                                                  snapshot.data!
                                                                      .exists &&
                                                                  snapshot.data![
                                                                          'requests'] !=
                                                                      null) {
                                                                List<dynamic>
                                                                    list =
                                                                    snapshot.data![
                                                                        'requests'];

                                                                streamingRequestsModelList = list
                                                                    .map((e) =>
                                                                        StreamingRequestsModel
                                                                            .fromJson(e))
                                                                    .toList();
                                                                length =
                                                                    streamingRequestsModelList
                                                                        .length;

                                                                int index = streamingRequestsModelList.indexWhere((element) =>
                                                                    element
                                                                        .senderUserId ==
                                                                    controller
                                                                        .userID
                                                                        .value);
                                                                exists =
                                                                    index != -1;
                                                              }

                                                              return exists
                                                                  ? Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.grey,
                                                                          style:
                                                                              BorderStyle.solid,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10.0,
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Center(
                                                                          child: headingText(
                                                                              requestSent.tr,
                                                                              SizeConfig.blockSizeHorizontal * 3.2,
                                                                              Colors.white),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.blue,
                                                                          style:
                                                                              BorderStyle.solid,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10.0),
                                                                        child:
                                                                            Center(
                                                                          child: headingText(
                                                                              sendARequest.tr,
                                                                              SizeConfig.blockSizeHorizontal * 3.2,
                                                                              Colors.white),
                                                                        ),
                                                                      ),
                                                                    );
                                                            }),
                                                      )
                                                    : Container();
                                              })
                                          : Container(),
                                      const SizedBox(width: 10),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            controller.backPressButton();
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black38,
                                            ),
                                            width: 30,
                                            height: 30,
                                            child: const Icon(
                                              Icons.chevron_left,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ]),
                      ),
                    ),

                    _toolbar(context),
                    // Positioned(
                    //   bottom: 10,
                    //   left: 0,
                    //   width: SizeConfig.screenWidth,
                    //   child: Container(
                    //     decoration: const BoxDecoration(
                    //         color: colorLightGreyBg,
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(50.0),
                    //         )),
                    //     margin: const EdgeInsets.only(
                    //         left: 15.0, right: 15.0, bottom: 0),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(4.0),
                    //       child: TextFormField(
                    //         controller: controller.messageController.value,
                    //         cursorColor: colorRed,
                    //         maxLines: 1,
                    //         textAlignVertical: TextAlignVertical.bottom,
                    //         style: const TextStyle(color: colorBlack),
                    //         decoration: InputDecoration(
                    //           hintText: enter.tr,
                    //           hintStyle: const TextStyle(color: colorGrey),
                    //           filled: true,
                    //           border: InputBorder.none,
                    //           /* prefixIcon: InkWell(
                    //                   onTap: () {
                    //                     // controller.openGallery();
                    //                   },
                    //                   child: Container(git
                    //                     width:
                    //                         SizeConfig.blockSizeVertical * 1,
                    //                     height:
                    //                         SizeConfig.blockSizeVertical * 1,
                    //                     margin: const EdgeInsets.all(5),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.all(10.0),
                    //                       child: Image.asset(
                    //                         attachment,
                    //                         width:
                    //                             SizeConfig.blockSizeVertical *
                    //                                 3,
                    //                         height:
                    //                             SizeConfig.blockSizeVertical *
                    //                                 3,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),*/
                    //           fillColor: Colors.transparent,
                    //           suffixIcon: InkWell(
                    //             onTap: () {
                    //               controller.sendMessage();
                    //               FocusScope.of(context)
                    //                   .requestFocus(FocusNode());
                    //             },
                    //             child: Container(
                    //               width: SizeConfig.blockSizeVertical * 1,
                    //               height: SizeConfig.blockSizeVertical * 1,
                    //               margin: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(10.0),
                    //                 child: Image.asset(
                    //                   sendChat,
                    //                   width: SizeConfig.blockSizeVertical * 3,
                    //                   height: SizeConfig.blockSizeVertical * 3,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    showingList()
                  ],
                )),
          ),
        ));
  }

  Widget showingList() {
    return Positioned(
        top: 33,
        left: 0,
        width: SizeConfig.screenWidth,
        child: Obx(() => AnimatedContainer(
              alignment: Alignment.centerLeft,
              color: Colors.black54,
              duration: const Duration(milliseconds: 500),
              height: controller.showingListMode.value == 0
                  ? 0
                  : SizeConfig.screenHeight / 2,
              child: controller.showingListMode.value == 0
                  ? Container()
                  : StreamBuilder<DocumentSnapshot>(
                      stream: controller.showingListMode.value == 2
                          ? FirebaseFirestore.instance
                              .collection('live_streaming_requests')
                              .doc(controller.streamingUserId.value)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("followers")
                              .doc(controller.userID.value)
                              .snapshots(),
                      builder: (context, snapshot) {
                        List<StreamingRequestsModel>?
                            streamingRequestsModelList;
                        List<Followers>? followersList;
                        if (snapshot != null &&
                            snapshot.data != null &&
                            snapshot.data!.exists &&
                            snapshot.data!['requests'] != null) {
                          if (controller.showingListMode.value == 2) {
                            List<dynamic> list = snapshot.data!['requests'];

                            streamingRequestsModelList = list
                                .map((e) => StreamingRequestsModel.fromJson(e))
                                .toList();
                          } else {
                            List<dynamic> list = snapshot.data!['requests'];
                            followersList =
                                list.map((e) => Followers.fromJson(e)).toList();
                          }
                        } else {
                          streamingRequestsModelList = [];
                          followersList = [];
                        }

                        int itemsList = controller.showingListMode.value == 2
                            ? streamingRequestsModelList!.length
                            : followersList!.length;
                        return itemsList == 0
                            ? const Center(
                                child: Text('Empty List',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)))
                            : AnimationLimiter(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 10),
                                  itemCount: itemsList,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: -120.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(width: 20),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: controller
                                                                    .showingListMode
                                                                    .value ==
                                                                2 &&
                                                            streamingRequestsModelList![
                                                                        index]
                                                                    .senderUserImage !=
                                                                null &&
                                                            streamingRequestsModelList[
                                                                    index]
                                                                .senderUserImage!
                                                                .isNotEmpty
                                                        ? NetworkImage(
                                                            streamingRequestsModelList[
                                                                    index]
                                                                .senderUserImage!,
                                                          )
                                                        : controller
                                                                        .showingListMode
                                                                        .value ==
                                                                    1 &&
                                                                followersList![
                                                                            index]
                                                                        .userImage !=
                                                                    null &&
                                                                followersList[
                                                                        index]
                                                                    .userImage!
                                                                    .isNotEmpty
                                                            ? NetworkImage(
                                                                followersList[
                                                                        index]
                                                                    .userImage!)
                                                            : null,
                                                    radius: 15,
                                                    child: controller.showingListMode
                                                                        .value ==
                                                                    2 &&
                                                                (streamingRequestsModelList![index]
                                                                            .senderUserImage ==
                                                                        null ||
                                                                    streamingRequestsModelList[
                                                                            index]
                                                                        .senderUserImage!
                                                                        .isEmpty) ||
                                                            (controller.showingListMode
                                                                        .value ==
                                                                    1 &&
                                                                (followersList![index]
                                                                            .userImage ==
                                                                        null ||
                                                                    followersList[
                                                                            index]
                                                                        .userImage!
                                                                        .isEmpty))
                                                        ? Image.asset(
                                                            'assets/images/profile3d.png')
                                                        : null,
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: Text(
                                                        controller.showingListMode
                                                                    .value ==
                                                                1
                                                            ? followersList![
                                                                    index]
                                                                .username!
                                                            : streamingRequestsModelList![
                                                                    index]
                                                                .senderUsername!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  if (controller.showingListMode
                                                          .value ==
                                                      2)
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            controller.acceptRequest(
                                                                streamingRequestsModelList![
                                                                        index]
                                                                    .senderUserId!,
                                                                streamingRequestsModelList,
                                                                streamingRequestsModelList[
                                                                    index]);
                                                          },
                                                          child: const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        InkWell(
                                                          onTap: () {
                                                            controller.removeRequest(
                                                                streamingRequestsModelList![
                                                                        index]
                                                                    .senderUserId!,
                                                                streamingRequestsModelList);
                                                          },
                                                          child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      ],
                                                    )
                                                ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      }),
            )));
  }

  Widget chatRowItem(ChatModel chatList, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 25,
                child: headingText(" ${chatList.name.toString()} : ",
                    SizeConfig.blockSizeHorizontal * 3.8, chatList.color,
                    weight: FontWeight.w700),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 3,
              ),
              Expanded(
                child: Text(
                  chatList.message.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                      fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 5,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

/*  Widget _videoPanel() {
    return Obx(() => controller.isLoadingVideoView.value == true &&
            controller.isHost.value == true
        ?
        // Show local video preview
        AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.agoraEngine.value,
              canvas: VideoCanvas(uid: 0),
            ),
          )
        :
        // Show remote video

        controller.isLoadingVideoView.value == true &&
                controller.isHost.value == false
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.agoraEngine.value,
                  canvas: VideoCanvas(uid: controller.remoteUid.value),
                  connection: RtcConnection(channelId: controller.channelName),
                ),
              )
            : commonLoader());
  }*/

  /*Widget _viewRows(bool isRtl) {
    final views = _getRenderViews(isRtl);
    switch (views.length) {
      case 1:
        return Column(
                  children: <Widget>[_videoView(views[0])],
                );
      case 2:
        return Column(
                  children: <Widget>[
        _expandedVideoRow([views[1]]),
        _expandedVideoRow([views[0]])
                  ],
                );
      case 3:
        return Column(
                  children: <Widget>[
        _expandedVideoRow(views.sublist(0, 2)),
        _expandedVideoRow(views.sublist(2, 3))
                  ],
                );
      case 4:
        return Column(
                  children: <Widget>[
        _expandedVideoRow(views.sublist(0, 2)),
        _expandedVideoRow(views.sublist(2, 4))
                  ],
                );
      default:
    }
    return Container();
  }*/

  /// Helper function to get list of native views
  /*List<Widget> _getRenderViews(bool isRtl) {
    final List<StatefulWidget> list = [];
    if ((controller.isHost.value) && controller.agoraEngine != null) {

      list.add(
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.agoraEngine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
      );
    }

    if (kDebugMode) {
      print('~!@~!@~!~~~~~~~${controller.users.toJson()}');
    }
    for (var uid in controller.users) {
      list.add(StatefulBuilder(builder: (context, setState) {
          return Stack(
            children: [
              if(controller.agoraEngine != null)
                AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.agoraEngine!,
                    canvas: VideoCanvas(uid: uid.uid),
                    connection: RtcConnection(channelId: controller.channelName.value,),
                  ),
                ),
              if(controller.agoraEngine == null)
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: Text("Loading video",
                    style: TextStyle(color: Colors.white),),
                  ),
                ),
              controller.isHost.value
                  ? Positioned(
                      bottom: 15,
                  right: isRtl ? null : 15,
                  left: isRtl ? 15 : null,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: uid.muted
                                ? RawMaterialButton(
                                    onPressed: () =>
                                        controller.unMuteUser(uid.uid),
                                    shape: const CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mic_off,
                                        color: Colors.blueAccent,
                                        size: 20.0,
                                      ),
                                    ),
                                  )
                                : RawMaterialButton(
                                    onPressed: () =>
                                        controller.muteUser(uid.uid),
                                    shape: const CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: Colors.blueAccent,
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: RawMaterialButton(
                              onPressed: () =>
                                  controller.removeUserFromLive(uid.uid),
                              shape: const CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(10.0),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          )
                        ],
                      ))
                  : Container()
            ],
          );
        }));
    }

    return list;
  }*/

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _toolbar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.streamingUserId != null &&
                  controller.streamingUserId.isNotEmpty
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stream_chat')
                      .doc(controller.isHost.value
                          ? controller.userID.value
                          : controller.streamingUserId.value)
                      .collection('messages')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List chatList = [];
                    if (snapshot != null &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      chatList = snapshot.data!.docs;
                    }

                    return chatList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: SizeConfig.blockSizeVertical * 20,
                            width: SizeConfig.screenWidth * 0.7,
                            decoration: const BoxDecoration(
                                color: Colors.black26,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: AnimationLimiter(
                              child: ListView.builder(
                                reverse: true,
                                padding: const EdgeInsets.only(top: 10),
                                itemCount: chatList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 20),
                                                Text(
                                                    chatList[index]
                                                            ['userName'] +
                                                        ': ',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white)),
                                                Expanded(
                                                  child: Text(
                                                      chatList[index]
                                                          ['message'],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container();
                  })
              : Container(),
          SizedBox(height: SizeConfig.blockSizeVertical * 2),
          controller.isHost.value
              ? Center(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 8,
                          width: SizeConfig.blockSizeVertical * 8,
                          child: Obx(() => controller.muted.value
                              ? RawMaterialButton(
                                  onPressed: controller.onToggleMute,
                                  shape: const CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: Colors.white,
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeVertical * 2),
                                  child: Center(
                                    child: Icon(
                                      Icons.mic_off,
                                      color: Colors.blueAccent,
                                      size: SizeConfig.blockSizeVertical * 4,
                                    ),
                                  ),
                                )
                              : RawMaterialButton(
                                  onPressed: controller.onToggleMute,
                                  shape: const CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: Colors.blueAccent,
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeVertical * 2),
                                  child: Center(
                                    child: Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                      size: SizeConfig.blockSizeVertical * 4,
                                    ),
                                  ),
                                )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 12,
                          width: SizeConfig.blockSizeVertical * 12,
                          child: RawMaterialButton(
                            onPressed: () => controller.backPressButton(),
                            shape: const CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.redAccent,
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeVertical * 3),
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: SizeConfig.blockSizeVertical * 6,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 8,
                          width: SizeConfig.blockSizeVertical * 8,
                          child: RawMaterialButton(
                            onPressed: controller.onSwitchCamera,
                            shape: const CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeVertical * 2),
                            child: Icon(
                              Icons.cameraswitch_rounded,
                              color: Colors.blueAccent,
                              size: SizeConfig.blockSizeVertical * 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                children: [

                  if (controller.isAcceptedByHost.value)
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Row(
                        children: [
                         // _buildMicButton(StreamUser(uid: 0, muted: false)),
                          // const SizedBox(width: 10),
                          // _buildEndCallButton(user),
                        ],
                      ),
                    ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: colorLightGreyBg,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            )),
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            controller: controller.messageController.value,
                            cursorColor: colorRed,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: const TextStyle(color: colorBlack),
                            decoration: InputDecoration(
                              hintText: enter.tr,
                              hintStyle: const TextStyle(color: colorGrey),
                              filled: true,
                              border: InputBorder.none,
                              /* prefixIcon: InkWell(
                                                  onTap: () {
                                                    // controller.openGallery();
                                                  },
                                                  child: Container(git
                                                    width:
                                                        SizeConfig.blockSizeVertical * 1,
                                                    height:
                                                        SizeConfig.blockSizeVertical * 1,
                                                    margin: const EdgeInsets.all(5),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Image.asset(
                                                        attachment,
                                                        width:
                                                            SizeConfig.blockSizeVertical *
                                                                3,
                                                        height:
                                                            SizeConfig.blockSizeVertical *
                                                                3,
                                                      ),
                                                    ),
                                                  ),
                                                ),*/
                              fillColor: Colors.transparent,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.sendMessage();
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },
                                child: Container(
                                  width: SizeConfig.blockSizeVertical * 1,
                                  height: SizeConfig.blockSizeVertical * 1,
                                  margin: const EdgeInsets.all(5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      sendChat,
                                      width: SizeConfig.blockSizeVertical * 3,
                                      height: SizeConfig.blockSizeVertical * 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        ],
      ),
    );
  }
}

class CustomStateful {
  final int uid;
  final bool showOptions;
  final StatefulWidget widget;

  CustomStateful(this.uid, this.showOptions, this.widget);
}
