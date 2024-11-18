// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ourworldmain/choose_game/ui/gamesoptionscreen.dart';
import 'package:ourworldmain/common/size_config.dart';
import 'package:ourworldmain/common/widgets.dart';
import 'package:ourworldmain/constants/app_colors.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/live_screen/controller/live_controller.dart';
import 'package:ourworldmain/live_screen/model/streaming_request_model.dart';
import 'package:ourworldmain/main_screen/ui/banner.dart';
import 'package:ourworldmain/profile/ui/profile_screen.dart';

import '../../constants/app_images.dart';
import '../../constants/storage_constants.dart';
import '../../game_screens/chessgame.dart';
import '../../profile/model/profile_model.dart';
import '../model/chat_model.dart';

class LiveScreen extends StatefulWidget {
  final bool isHost;
  final String streamingUserIds;
  final String streamingToken;
  final String streamingJoiningId;
  final bool groupStreaming;
  final String hostId;
  final String channelName;

  const LiveScreen({
    super.key,
    required this.isHost,
    required this.streamingUserIds,
    required this.streamingToken,
    required this.streamingJoiningId,
    required this.groupStreaming,
    required this.hostId,
    required this.channelName,
  });

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  Key key = UniqueKey();
  final controller = Get.put(LiveController());
  void restartWidget() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    print("init");
    controller.isHost.value = widget.isHost;
    controller.function = restartWidget;
    controller.streamingUserId.value = widget.streamingUserIds;
    controller.streamingJoiningId.value = widget.streamingJoiningId;
    controller.hostId.value = widget.hostId;
    controller.groupStreaming.value = widget.groupStreaming;
    controller.channelName.value = widget.channelName.isNotEmpty
        ? widget.channelName
        : DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
               /* Positioned.fill(
                  child: Container(
                      height: SizeConfig.screenHeight - 170,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Obx(() =>
                          controller.videoViewLoaded.value == true &&
                                      controller.isHost.value == true ||
                                  controller.users.isNotEmpty
                              ? _viewRows(context)
                              : controller.videoViewLoaded.value == true &&
                                          controller.isHost.value == false ||
                                      controller.users.isNotEmpty
                                  ? _viewRows(context)
                                  : commonLoader())),
                ),*/
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
                                controller.storeButtonClick(
                                    controller.userData.value.store.toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: headingText(
                                    myStore.tr,
                                    SizeConfig.blockSizeHorizontal * 3.2,
                                    Colors.white),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 25,
                              color: Colors.white24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Obx(
                                () => controller.isHost.value == true
                                    ? InkWell(
                                        onTap: () {
                                          if (controller
                                                  .showingListMode.value !=
                                              2) {
                                            controller.showRequests();
                                          } else {
                                            controller.hideList();
                                          }
                                        },
                                        child: controller.streamingUserId.value
                                                .isNotEmpty
                                            ? StreamBuilder<DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                        'live_streaming_requests')
                                                    .doc(controller
                                                        .streamingUserId.value)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  int length = 0;
                                                  if (snapshot.data != null &&
                                                      snapshot.data!.exists &&
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
                                                SizeConfig.blockSizeHorizontal *
                                                    3.2,
                                                Colors.white),
                                      )
                                    : StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("followers")
                                            .doc(controller.isHost.value
                                                ? controller.userID.value
                                                : controller
                                                    .streamingUserId.value)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          int length = 0;
                                          List<Followers> followersList = [];
                                          bool exists = false;

                                          if (snapshot.data != null &&
                                              snapshot.data!.exists &&
                                              snapshot.data!['requests'] !=
                                                  null) {
                                            List<dynamic> list =
                                                snapshot.data!.get('requests');

                                            followersList = list
                                                .map((e) =>
                                                    Followers.fromJson(e))
                                                .toList();
                                            length = followersList.length;

                                            int index = followersList
                                                .indexWhere((element) =>
                                                    element.userId ==
                                                    controller.store
                                                        .read(userId));
                                            exists = index != -1;
                                          }

                                          print(
                                              '>>>>>###>>>> $exists  ${controller.streamingUserId.value}');
                                          return InkWell(
                                            onTap: () {
                                              if (exists) {
                                                controller.unfollowButtonClick(
                                                    controller.userData.value);
                                              } else {
                                                controller.followButtonClick(
                                                    controller.userData.value);
                                              }
                                            },
                                            child: headingText(
                                                exists
                                                    ? following.tr
                                                    : follow.tr,
                                                SizeConfig.blockSizeHorizontal *
                                                    3.2,
                                                exists
                                                    ? Colors.greenAccent[400]!
                                                    : Colors.white),
                                          );
                                        }),
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
                                  if (controller.showingListMode.value == 1) {
                                    controller.hideList();
                                  } else {
                                    controller.showFollowers();
                                  }
                                  // Get.to(() => MyClientsScreen(
                                  //     controller.userData.value.userId
                                  //         .toString(),
                                  //     controller.myClientsList.value));
                                },
                                child: controller.userID.value.isNotEmpty
                                    ? StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("followers")
                                            .doc(controller.isHost.value
                                                ? controller.userID.value
                                                : controller
                                                    .streamingUserId.value)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          int length = 0;
                                          if (snapshot.data != null &&
                                              snapshot.data!.exists &&
                                              snapshot.data!['requests'] !=
                                                  null) {
                                            length = snapshot
                                                .data!['requests'].length;
                                          }
                                          return Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                          padding: const EdgeInsets.all(10.0),
                                          child: headingText(
                                              '${myClients.tr}(0)',
                                              SizeConfig.blockSizeHorizontal *
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
                                        controller.enableTextField.value))!
                                    .then((value) {
                                  controller.fetchUserData(
                                      controller.userData.value.userId!);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: headingText(
                                    myProfile.tr,
                                    SizeConfig.blockSizeHorizontal * 3.2,
                                    Colors.white),
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
                                return Column(
                                  children: [
                                    chatRowItem(
                                        controller.chatList.value[index],
                                        index),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () =>
                        (controller.isHost.value == false) &&
                                controller.isAcceptedByHost.value == false
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  controller.streamingUserId.value.isNotEmpty
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
                                                streamingRequestsModelList = [];
                                            bool exists = false;
                                            if (snapshot.data != null &&
                                                snapshot.data!.exists &&
                                                snapshot.data!['requests'] !=
                                                    null) {
                                              List<dynamic> list =
                                                  snapshot.data!['requests'];

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
                                                          controller
                                                              .userID.value);
                                              exists = index != -1;
                                            }
                                            showDebugPrint(
                                                '~~~~~~#### $length');

                                            return Obx(
                                              () =>
                                                  controller.isAcceptedByHost
                                                              .isFalse &&
                                                          length < 3
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (!exists) {
                                                              Get.to(ChooseYourPage(
                                                                  streamingRequestsModelList:
                                                                      streamingRequestsModelList));
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder:
                                                              //             (context) =>
                                                              //                 ChooseYourPage(streamingRequestsModelList: streamingRequestsModelList,)));
                                                              // // controller
                                                              //     .sendLiveStreamingRequest(
                                                              //         streamingRequestsModelList);
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
                                                                if (snapshot
                                                                            .data !=
                                                                        null &&
                                                                    snapshot
                                                                        .data!
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
                                                                          StreamingRequestsModel.fromJson(
                                                                              e))
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
                                                                      index !=
                                                                          -1;
                                                                }

                                                                return exists
                                                                    ? Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.grey,
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
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10.0,
                                                                              vertical: 10),
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
                                                                          color:
                                                                              Colors.blue,
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
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10.0),
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
                                                      : Container(),
                                            );
                                          })
                                      : Container(),
                                  const SizedBox(width: 10),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                showingList()
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    controller.backPressButton();
    super.dispose();
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
                              .doc(controller.isHost.value
                                  ? controller.userID.value
                                  : controller.streamingUserId.value)
                              .snapshots(),
                      builder: (context, snapshot) {
                        List<StreamingRequestsModel>?
                            streamingRequestsModelList;
                        List<Followers>? followersList;
                        if (snapshot.data != null &&
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
                                                  Column(
                                                    children: [
                                                      Text(
                                                        streamingRequestsModelList![
                                                                index]
                                                            .senderUsername!,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
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
                                                            : controller.showingListMode
                                                                            .value ==
                                                                        1 &&
                                                                    followersList![index]
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
                                                                    (streamingRequestsModelList![index].senderUserImage ==
                                                                            null ||
                                                                        streamingRequestsModelList[index]
                                                                            .senderUserImage!
                                                                            .isEmpty) ||
                                                                (controller.showingListMode
                                                                            .value ==
                                                                        1 &&
                                                                    (followersList![index].userImage ==
                                                                            null ||
                                                                        followersList[index]
                                                                            .userImage!
                                                                            .isEmpty))
                                                            ? Image.asset(
                                                                'assets/images/profile3d.png')
                                                            : null,
                                                      ),
                                                    ],
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
                                                            : "${streamingRequestsModelList![index].game!} game, defeat me and win ${streamingRequestsModelList[index].challengePrice}\$",
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
                                                        const SizedBox(
                                                            width: 10),
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

 /* Widget _viewRows(BuildContext context) {
    final views = _getRenderViews(context);
    print("views.length: ${views.length}");

    List<Widget> content = [];

    ///adding chess game to live screen when host accepts request
    // TODO: MAKE IT FLEXIBLE AND DYNAMIC TO FUNCTION FOR ALL THE GAMES
    if (controller.isAcceptedByHost.value) {
      content.add(ChessGameRoom()); // Add ChessGameRoom widget at the top
    }

    switch (views.length) {
      case 1:
        {
          return _videoView(views[0]);
          // content.add(_videoView(views[0]));
          // return Column(
          //   children: content,
          // );
        }
        break;
      case 2:
        {
          if (controller.isAcceptedByHost.value) {
            content.addAll([
              _expandedVideoRow(views.sublist(0, 2)),
              // Row(
              //   children: [
              //     _expandedVideoRow([views[1]]),
              //     _expandedVideoRow([views[0]])
              //   ],
              // ),
            ]);
            return Column(
              children: content,
            );
          }
          return Row(
            children: [
              _expandedVideoRow([views[1]]),
              _expandedVideoRow([views[0]])
            ],
          );
          break;
        }
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
  // List<Widget> _getRenderViews(BuildContext context) {
  //   final List<Widget> views = [];
  //   if (controller.agoraEngine != null) {
  //     if (controller.isHost.value || controller.isAcceptedByHost.value) {
  //       views.add(
  //         Stack(
  //           children: [
  //             AgoraVideoView(
  //               controller: VideoViewController(
  //                 rtcEngine: controller.agoraEngine!,
  //                 useAndroidSurfaceView: false,
  //                 canvas: const VideoCanvas(uid: 0),
  //               ),
  //             ),
  //             if (controller.isAcceptedByHost.value)
  //               Positioned(
  //                 top: 15,
  //                 right: Directionality.of(context) == TextDirection.rtl
  //                     ? null
  //                     : 15,
  //                 left: Directionality.of(context) == TextDirection.rtl
  //                     ? 15
  //                     : null,
  //                 child: Row(
  //                   children: [
  //                     SizedBox(
  //                       height: SizeConfig.blockSizeVertical * 6,
  //                       width: SizeConfig.blockSizeVertical * 6,
  //                       child: Obx(() => controller.muted.value
  //                           ? RawMaterialButton(
  //                               onPressed: () =>
  //                                   controller.onToggleMute(isHost: false),
  //                               shape: const CircleBorder(),
  //                               elevation: 2.0,
  //                               fillColor: Colors.white,
  //                               padding: EdgeInsets.all(
  //                                   SizeConfig.blockSizeVertical * 1.5),
  //                               child: Center(
  //                                 child: Icon(
  //                                   Icons.mic_off,
  //                                   color: Colors.blueAccent,
  //                                   size: SizeConfig.blockSizeVertical * 3,
  //                                 ),
  //                               ),
  //                             )
  //                           : RawMaterialButton(
  //                               onPressed: () =>
  //                                   controller.onToggleMute(isHost: false),
  //                               shape: const CircleBorder(),
  //                               elevation: 2.0,
  //                               fillColor: Colors.blueAccent,
  //                               padding: EdgeInsets.all(
  //                                   SizeConfig.blockSizeVertical * 1.5),
  //                               child: Center(
  //                                 child: Icon(
  //                                   Icons.mic,
  //                                   color: Colors.white,
  //                                   size: SizeConfig.blockSizeVertical * 3,
  //                                 ),
  //                               ),
  //                             )),
  //                     )
  //                     // const SizedBox(width: 10),
  //                     // _buildEndCallButton(user),
  //                   ],
  //                 ),
  //               ),
  //           ],
  //         ),
  //       );
  //     }
  //     if (controller.users.isNotEmpty) {
  //       for (var user in controller.users) {
  //         views.add(
  //           Stack(
  //             children: [
  //               controller.agoraEngine != null
  //                   ? AgoraVideoView(
  //                       controller: VideoViewController.remote(
  //                         rtcEngine: controller.agoraEngine!,
  //                         useAndroidSurfaceView: false,
  //                         canvas: VideoCanvas(uid: user.uid),
  //                         connection: RtcConnection(
  //                             channelId: controller.channelName.value),
  //                       ),
  //                     )
  //                   : Container(
  //                       color: Colors.black,
  //                       child: const Center(
  //                         child: Text(
  //                           "Loading video",
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                       ),
  //                     ),
  //               // Positioned(
  //               //   top: 15,
  //               //   left: 15,
  //               //   child: Text(user.uid.toString(),
  //               //   style: TextStyle(
  //               //     color: Colors.pink,
  //               //     fontSize: 24
  //               //   ),),
  //               // ),
  //               if (controller.isHost.value)
  //                 Positioned(
  //                   bottom: 15,
  //                   right: Directionality.of(context) == TextDirection.rtl
  //                       ? null
  //                       : 15,
  //                   left: Directionality.of(context) == TextDirection.rtl
  //                       ? 15
  //                       : null,
  //                   child: Row(
  //                     children: [
  //                       _buildMicButton(user),
  //                       const SizedBox(width: 10),
  //                       _buildEndCallButton(user),
  //                     ],
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         );
  //       }
  //     }
  //   } else {
  //     debugPrint("no vie av");
  //   }
  //
  //   return views;
  // }

  Widget _buildMicButton(StreamUser user) {
    return SizedBox(
      height: 40,
      width: 40,
      child: RawMaterialButton(
        onPressed: () => user.muted
            ? controller.unMuteUser(uid: user.uid)
            : controller.muteUser(uid: user.uid),
        shape: const CircleBorder(),
        elevation: 2.0,
        fillColor: user.muted ? Colors.white : Colors.blueAccent,
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          user.muted ? Icons.mic_off : Icons.mic,
          color: user.muted ? Colors.blueAccent : Colors.white,
          size: 20.0,
        ),
      ),
    );
  }

  Widget _buildEndCallButton(StreamUser user) {
    return SizedBox(
      height: 40,
      width: 40,
      child: RawMaterialButton(
        onPressed: () => controller.removeUserFromLive(user.uid),
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
    );
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: view);
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('stream_chat')
                  .doc(controller.isHost.value
                      ? controller.store.read(userId)
                      : controller.streamingUserId.value)
                  .collection('messages')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                List chatList = [];
                if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                  chatList = snapshot.data!.docs;
                }
                print('>>>>>>>>>>>>>');
                print('>>>>>>>>>>>>>');
                print(chatList.length);
                print('>>>>>>>>>>>>>');
                print('>>>>>>>>>>>>>');
                return chatList.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 20),
                        height: SizeConfig.blockSizeVertical * 35,
                        width: SizeConfig.screenWidth * 0.7,
                        decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: AnimationLimiter(
                          child: ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, bottom: 5, right: 5),
                            itemCount: chatList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 5),
                                                Text(
                                                    (chatList[index]
                                                                ['userName'] !=
                                                            null
                                                        ? chatList[index]
                                                                ['userName'] +
                                                            ': '
                                                        : ''),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white)),
                                                Expanded(
                                                  child: Text(
                                                      chatList[index]
                                                              ['message'] ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                ),
                                              ]),
                                        ),
                                        if (index % 5 == 0)
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: BannerAdmob(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 70),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container();
              }),
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
                                  onPressed: () =>
                                      controller.onToggleMute(isHost: true),
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
                                  onPressed: () =>
                                      controller.onToggleMute(isHost: true),
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
              : Align(
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
    );
  }
}

class CustomStateful {
  final int uid;
  final bool showOptions;
  final StatefulWidget widget;

  CustomStateful(this.uid, this.showOptions, this.widget);
}
