import 'dart:async';
import 'dart:convert';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_rtm/agora_rtm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:streaming_post_demo/common/widgets.dart';
import 'package:streaming_post_demo/constants/api_endpoints.dart';
import 'package:streaming_post_demo/live_screen/model/live_audience_model.dart';
import 'package:streaming_post_demo/live_screen/model/streaming_request_model.dart';

import '../../common/size_config.dart';
import '../../constants/app_colors.dart';
import '../../constants/storage_constants.dart';
import '../../constants/string_constants.dart';
import '../../login/login_screen.dart';
import '../../method_channels/agora_chat.dart';
import '../../notifications.dart';
import '../../profile/model/profile_model.dart';
import '../model/chat_model.dart';
import '../ui/live_partner_screen.dart';

class LiveController extends GetxController {
  final messageController = TextEditingController().obs;
  var store = GetStorage();
  var userData =
      ProfileModel("", "", "", "", "", "", "", "", "", "", "", "", []).obs;
  var isLoading = false.obs;
  Function function = (){}.obs.call;
  var token = "".obs;
  var rtmToken = "".obs;
  var userID = "".obs;
  var videoViewLoaded = false.obs;
  var isAcceptedByHost = false.obs;
 // RtcEngine? agoraEngine;
  var uid = 0.obs; // uid of the local user
  var streamingJoiningId = "0".obs;
  var hostId = "0".obs;
  var remoteUid = 1.obs; // uid of the remote user
  var hasHostJoined = false.obs;
  var isHost = false.obs;
  var isBroadcaster = false.obs;

  var groupStreaming = false.obs;
  var isPartnerJoin = false.obs;
  var streamingUserId = "".obs;
  var agoraChatId = 0.obs;
  var enableTextField = true.obs;
  // var followText = "".obs;
  var followRequests = <Followers>[].obs;
  // var myClientsList = <Followers>[].obs;
  // var streamingRequestsList = <StreamingRequestsModel>[].obs;
  var scrollController = ScrollController().obs;
  var channelName = "".obs;
  // var joinRequestSent = false.obs;
  var showingListMode = 0.obs;
  // var showingList = [].obs;

  // var streamingToken =
  //     "007eJxTYGAyXq18gefCsYCvfZna+3/+esK0QVHz1VTp5wlcLxg7QtIVGNIsLMzTDM1TU00SLUxMjFMtU8wMUg1S0swsjEySk9PMlV/LpTQEMjJk1H9nYmRgZGABYhCfCUwyg0kWMMnLEFxSlJqYm5mXHpBfXMLAAADi6iXI"
  //         .obs;
  var chatToken =
      "007eJxTYLBou26XnrE/K18mKHHO8suRJ7W+PX5m9dUnf2Wj86u5pzYoMKRZWJinGZqnppokWpiYGKdappgZpBqkpJlZGJkkJ6eZ+7yWS2kIZGTQrjBiZmRgZWAEQhBfhcHEIDEpzTjFQDcpLS1N19AwNUU3McnMTNc4KckwJSnNMs0iyRAALzsp4w=="
          .obs;
  var chatList = <ChatModel>[].obs;
  var streamingAudienceList = <LiveAudienceModel>[].obs;

  var users = <StreamUser>[].obs;
  var tokenUrl = 'https://ourworld-yx0i.onrender.com'.obs;
  final _infoStrings = <String>[];
  var muted = false.obs;
  // AgoraRtmClient? _client;
  // AgoraRtmChannel? channel;

 // late RtcEngine _engine;


  @override
  onInit() {
    super.onInit();
    getUserData();
  }

  /*--------------------VIDEO STREAMING START--------------------------------*/

  // void _createClient() async {
  //   _client = await AgoraRtmClient.createInstance(ApiEndPoints.agoraAppId);
  //   print("Client created: $_client");
  //
  //   _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
  //     showDebugPrint("Peer msg: $peerId, msg: ${message.text}");
  //   };
  //
  //   _client?.onConnectionStateChanged = (int state, int reason) {
  //     showDebugPrint('Connection state changed: $state, reason: $reason');
  //     if (state == 5) { // Disconnected state
  //       _client?.logout();
  //       showDebugPrint('Logged out.');
  //     }
  //   };
  //
  //   _client?.onLocalInvitationReceivedByPeer = (AgoraRtmLocalInvitation invite) {
  //     showDebugPrint('Local invitation received by peer: ${invite.calleeId}, content: ${invite.content}');
  //   };
  //
  //   _client?.onRemoteInvitationReceivedByPeer = (AgoraRtmRemoteInvitation invite) {
  //     showDebugPrint('Remote invitation received by peer: ${invite.callerId}, content: ${invite.content}');
  //   };
  // }


  showFollowers() {
    showingListMode.value = 1;
    showingListMode.refresh();
    // showingList.value = myClientsList;
    // showingList.refresh();
  }

  showRequests() {
    showDebugPrint('message');
    showingListMode.value = 2;
    // showingList.value = streamingRequestsList;
    showingListMode.refresh();
    // showingList.refresh();
  }

  hideList() {
    showingListMode.value = 0;
    showingListMode.refresh();
    // showingList.value = [];
    // showingList.refresh();
  }

  Future<void> _createChannel(String name) async {
    // showDebugPrint('this is client $_client');
    // channel = await _client?.createChannel(name);
    //
    // if (channel != null) {
    //   showDebugPrint('channel not equal null');
    //   channel?.onMemberJoined = (AgoraRtmMember member) {
    //     showDebugPrint(
    //         'Member joined: ${member.userId}, channel: ${member.channelId}');
    //   };
    //   channel?.onMemberLeft = (AgoraRtmMember member) {
    //     showDebugPrint(
    //         'Member left: ${member.userId}, channel: ${member.channelId}');
    //   };
    //   channel?.onMessageReceived =
    //       (AgoraRtmMessage message, AgoraRtmMember member) {
    //     showDebugPrint("Channel msg: ${member.userId}, msg: ${message.text}");
    //   };
    // } else {
    //   showDebugPrint('channel  equal null ~~~~');
    // }
  }

  onToggleMute({required bool isHost, bool? muteValue, bool needToUpdate = true}) {
    // if(!isHost){
    //   if(needToUpdate){
    //     updateMuteStatusSenderId(muteValue??(muted.value?false:true));
    //   }
    //   muted.value = muteValue??(muted.value?false:true);
    //   agoraEngine!.muteLocalAudioStream(muteValue??(muted.value?false:true));
    // }
    // else{
    //   muted.value = !muted.value;
    //   agoraEngine!.muteLocalAudioStream(muted.value);
    // }
  }

  onSwitchCamera() {
    // agoraEngine!.switchCamera();
  }

  muteUser({required int uid, bool needToUpdate = true}) {
    // agoraEngine!.muteRemoteAudioStream(uid: uid, mute: true);
    if(needToUpdate){
      updateMuteStatusUID(uid,true);
    }
    int index = users.indexWhere((element) => element.uid == uid);
    users[index].muted = true;
    users.refresh();
  }

  unMuteUser({required int uid, bool needToUpdate = true}) {
    //agoraEngine!.muteRemoteAudioStream(uid: uid, mute: false);
    if(needToUpdate){
      updateMuteStatusUID(uid,false);
    }

    int index = users.indexWhere((element) => element.uid == uid);
    users[index].muted = false;
    users.refresh();
  }

  removeRequest(String uid, List<StreamingRequestsModel> streamingList) async {
    streamingList.removeWhere((element) => element.senderUserId == uid);
    FirebaseFirestore.instance
        .collection('live_streaming_requests')
        .doc(streamingUserId.value)
        .set({
      "requests": streamingList.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true)).then((res) {
      isLoading.value = false;
    });
  }

  rejoinAsBroadcaster() async {
    // try{
    //   agoraEngine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    //   agoraEngine!.startPreview();
    //   listenToStreamEnd();
    // }
    // catch(e){
    //   print(e.toString());
    // }

  }
  restartAgoraSDK() async {
    // try{
    //   await agoraEngine!.leaveChannel();
    //   await agoraEngine!.release();
    //   await setupVideoSDKEngine();
    //   listenToStreamEnd();
    // }
    // catch(e){
    //   print(e.toString());
    // }

  }

  rejoinAsAudience() async {
    // try{
    //   agoraEngine!.setClientRole(role: ClientRoleType.clientRoleAudience);
    //   listenToStreamEnd();
    // }
    // catch(e){
    //   print(e.toString());
    // }
  }

  Future<void> updateLiveStreamingRequests(List<StreamingRequestsModel> streamingList) async {
    try {
      await FirebaseFirestore.instance
          .collection('live_streaming_requests')
          .doc(streamingUserId.value)
          .update({
        "requests": streamingList.map((e) => e.toMap()).toList(),
      });
    } catch (e) {
      print("Failed to update live_streaming_requests: $e");
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> fetchAcceptedRequests(String streamingUserId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('accepted_live_request')
          .doc(streamingUserId)
          .get();

      List<Map<String, dynamic>> allAcceptedRequests = [];
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        List<dynamic> requests = data?['requests'] ?? [];
        allAcceptedRequests.addAll(requests.map((e) => Map<String, dynamic>.from(e)));
      }

      return allAcceptedRequests;
    } catch (e) {
      print("Failed to fetch accepted requests: $e");
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> fetchStreamingRequests(String streamingUserId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('live_streaming_requests')
          .doc(streamingUserId)
          .get();

      List<Map<String, dynamic>> allAcceptedRequests = [];
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        List<dynamic> requests = data?['requests'] ?? [];
        allAcceptedRequests.addAll(requests.map((e) => Map<String, dynamic>.from(e)));
      }

      return allAcceptedRequests;
    } catch (e) {
      print("Failed to fetch accepted requests: $e");
      rethrow;
    }
  }



  Future<void> acceptRequest(String uid, List<StreamingRequestsModel> streamingList, StreamingRequestsModel model) async {
    List<Map<String, dynamic>> acceptedUsers = await fetchAcceptedRequests(streamingUserId.value);
    acceptedUsers.add({
      'senderId': uid,
      'accepted': true,
      'mute': false,
      'uid': int.parse(model.remoteID!)
    });
    await FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value)
        .set({
      "requests": acceptedUsers,
    });
    Future.delayed(const Duration(seconds: 1),() async {
      removeRequest(uid,streamingList);
      // List<Map<String, dynamic>> streamingRequests = await fetchStreamingRequests(streamingUserId.value);
      // streamingRequests.removeWhere((map) => map['senderUserId'] == userID.value);
      // await FirebaseFirestore.instance
      //     .collection('live_streaming_requests')
      //     .doc(streamingUserId.value)
      //     .set({
      //   "requests": streamingRequests,
      // });
    });
  }




  Future removeRequests() async {
    try {
      FirebaseFirestore.instance
          .collection('live_streaming_requests')
          .doc(streamingUserId.value)
          .delete();
    } catch (e) {}
  }
  Future<bool> isSenderIdEqualToUserId(String userId) async {
    try {
      if(!isHost.value){
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('accepted_live_request')
            .doc(streamingUserId.value)
            .get();

        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          String? senderId = data['senderId'] as String?;
          return senderId == userId && data['accepted'] as bool;
        } else {
          print('No document found with the given ID.');
          return false;
        }
      }
      else{
        return true;
      }

    } catch (e) {
      if (kDebugMode) {
        print('Error getting document: $e');
      }
      return false;
    }
  }

  void listenToAcceptedRequests() {
    FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value)
        .snapshots()
        .listen((querySnapshot) async {
      final data = querySnapshot.data();
      if (data != null) {
        final requests = data['requests'] as List?;
        if (requests != null) {
          final index = requests.indexWhere((element) =>
          element['senderId'] == userID.value && element['accepted'] == true);

          if (index != -1 && !isAcceptedByHost.value) {
            showMessage("Please wait. Streaming is loading");
            isAcceptedByHost.value = true;
            Future.delayed(const Duration(milliseconds: 500),() async {
              print("this is accepted $index");
              rejoinAsBroadcaster();
              listenToHostMics();
            });
          }
          else if (index == -1 && isAcceptedByHost.value) {
            print("this is rejected $index");
            isAcceptedByHost.value = false;
            Future.delayed(const Duration(milliseconds: 1000),() async {
              rejoinAsAudience();
            });
          }
        }
      }
    });
  }

  void listenToGuestMics() {
    FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .snapshots()
        .listen((querySnapshot) async {
          final data = querySnapshot.data();
          if (data != null) {
            final requests = data['requests'] as List?;
            if (requests != null && requests.toList().isNotEmpty) {
              for(int i =0;i<requests.length;i++){
                if(requests[i]["mute"]){
                  muteUser(uid:requests[i]['uid'],needToUpdate: false);
                }
                else{
                  unMuteUser(uid:requests[i]['uid'],needToUpdate: false);
                }
              }
            }
          }
        });
  }

  void listenToHostMics() {
    FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .snapshots()
        .listen((querySnapshot) async {
          final data = querySnapshot.data();
          if (data != null) {
            final requests = data['requests'] as List?;
            if (requests != null && requests.toList().isNotEmpty) {
              final index = requests.indexWhere((element) => element['senderId'] == userID.value && element['accepted'] == true);
              if(index != -1){
                onToggleMute(isHost: false,muteValue: requests[index]["mute"], needToUpdate: false);
              }
            }
          }
        });
  }

  void listenToStreamEnd() {

    FirebaseFirestore.instance
        .collection('live_streaming')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .snapshots()
        .listen((querySnapshot) async {
      final data = querySnapshot.data();
      if (data == null || data["streaming_channel"] != channelName.value) {
        backPressButton();
      }
    });
  }



  Future<void> getUserData() async {
    Future.delayed(const Duration(milliseconds: 100), () async {
      userID.value = store.read(userId) ?? "";
      showDebugPrint("user id---------->  $userID");
      showDebugPrint("streamingUserId id---------->  $streamingUserId");
      showDebugPrint("isHost.value---------->  ${isHost.value}");
      enableTextField.value = isHost.value;
      await [Permission.microphone, Permission.camera].request();
      if (userID.value != "") {
        fetchUserData(isHost.value == false ? streamingUserId.value : userID.value);

        if (isHost.value) {
          await setupVideoSDKEngine();
          listenToGuestMics();
        } else {
            if (streamingUserId.value.isNotEmpty) {
              listenToAcceptedRequests();
              await setupVideoSDKEngine();
              listenToStreamEnd();
          }
        }
      } else {
        showLoginDialog();
      }
    });
  }

  Future<void> setupVideoSDKEngine() async {
    // try{
    //   if(isHost.value){
    //     users.clear();
    //   }
    //   agoraEngine = createAgoraRtcEngine();
    //   await agoraEngine?.initialize(const RtcEngineContext(
    //     appId: ApiEndPoints.agoraAppId,
    //   ));
    //   Future.delayed(const Duration(milliseconds: 500), () async {
    //     agoraEngine!.enableVideo();
    //     agoraEngine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    //
    //
    //     agoraEngine!.registerEventHandler(
    //       RtcEngineEventHandler(
    //         onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
    //           showMessage("Local user uid:${connection.localUid} joined the channel");
    //           uid.value = connection.localUid ?? 0;
    //           hasHostJoined.value = true;
    //           updateUID(connection.localUid??0);
    //           if (isHost.value) {
    //             streamingUserId.value = userID.value;
    //             updateLiveStreamingData();
    //             await NotificationPlugin.sendNotificationFCM("/topics/live", liveVideo.tr, '${store.read(userName)} ${startedNewLive.tr}');
    //           }
    //
    //         },
    //         onUserJoined: (RtcConnection connection, int uuid, int elapsed) {
    //           showMessage("Remote user uid live:$uuid joined the channel");
    //           users.add(StreamUser(uid: uuid, muted: false));
    //
    //           remoteUid.value = uuid;
    //           users.refresh();
    //           print("users.length: ${users.length}");
    //         },
    //         onUserOffline: (RtcConnection connection, int uidd, UserOfflineReasonType reason) {
    //           users.removeWhere((element) => element.uid == uidd);
    //           users.refresh();
    //           remoteUid.value = 1;
    //         },
    //         onClientRoleChanged: (RtcConnection connection, ClientRoleType oldRole, ClientRoleType newRole, ClientRoleOptions newRoleOptions) {
    //           // var attribute = AgoraRtmChannelAttribute(
    //           //     ApiEndPoints.agoraAppKey, agoraChatId.value.toString());
    //           //
    //           // if (channel != null && _client != null) {
    //           //   _client?.addOrUpdateChannelAttributes(channelName.value, [attribute], true);
    //           //   isBroadcaster.value = true;
    //           // }
    //         },
    //         onLeaveChannel: (RtcConnection connection, RtcStats stats) {
    //           users.clear();
    //           users.refresh();
    //         },
    //         onStreamMessage: (RtcConnection connection, int remoteUid, int streamId, Uint8List data, int length, int sentTs) {
    //           final String info = "here is the message ${data}";
    //           showMessage(info);
    //         },
    //         onStreamMessageError: (RtcConnection connection, int remoteUid, int streamId, ErrorCodeType code, int missed, int cached) {
    //           final String info = "here is the error $code";
    //           showMessage(info);
    //         },
    //       ),
    //     );
    //     join();
    //
    //   });
    // }
    // catch(e){
    //   if(isHost.value || isAcceptedByHost.value){
    //     restartAgoraSDK();
    //   }
    //   else{
    //     restartAgoraSDK();
    //   }
    // }
  }

  void join() async {
    // if (_client == null) {
    //   _createClient();
    // }

    // if (isHost.value) {
    //   agoraEngine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    //   agoraEngine!.startPreview();
    // } else if (isAcceptedByHost.value) {
    //   agoraEngine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    //   agoraEngine!.startPreview();
    // } else {
    //   agoraEngine!.setClientRole(role: ClientRoleType.clientRoleAudience);
    // }


    int time = DateTime.now().millisecondsSinceEpoch;
    agoraChatId.value = int.parse(time.toString().substring(3));

    await fetchRtcToken(agoraChatId.value, channelName.value);
    await fetchRtmToken(agoraChatId.value, channelName.value);
    try{
      // await _client?.login(rtmToken.value, agoraChatId.value.toString());
      // await _createChannel(channelName.value);
      // if (channel != null) {
      //   await channel!.join();
      // }
    }
    catch(e){
      print("got error while init client");
      debugPrint(e.toString());
    }


    // await agoraEngine!.joinChannel(
    //   token: token.value,
    //   channelId: channelName.value,
    //   uid: agoraChatId.value,
    //   options: const ChannelMediaOptions(),
    // );
    // videoViewLoaded.value = true;

  }



  Future<void> fetchRtcToken(
    int uid,
    String channelName,
  ) async {
    // Prepare the Url

    String tokenRole = 'publisher';

    String url = '$tokenUrl/rtc/$channelName/publisher/uid/$uid/?expiry=3600';

    showDebugPrint('~~~~url >>>$url');
    // Send the request
    final response = await http.get(Uri.parse(url));
    //print("status of to")

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      token.value = newToken;
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  Future<void> fetchRtmToken(
    int uid,
    String channelName,
  ) async {
    // Prepare the Url

    String rtmUrl = '$tokenUrl/rtm/${agoraChatId.value}/?expiry=3600';
    showDebugPrint('!#####$rtmUrl');

    final response2 = await http.get(Uri.parse(rtmUrl));
    showDebugPrint('!!~~~~~~~~~#####${response2.body}');

    if (response2.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response2.body);
      String newToken = json['rtmToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      rtmToken.value = newToken;
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void leave() {
    hasHostJoined.value = false;
    isAcceptedByHost.value = false;
    remoteUid.value = 1;
    users.clear();
    goOffline();
  }

  /*--------------------VIDEO STREAMING END--------------------------------*/
  /*--------------------AGORA CHAT START--------------------------------*/

  void initAgoraChatSDK() async {
    // ChatOptions options = ChatOptions(
    //   appKey: ApiEndPoints.agoraAppKey,
    //   autoLogin: true,
    // );
    // await ChatClient.getInstance.init(options);

    if (store.read(userName) != null) {
      signInToAgora(store.read(userName));
      // addChatListener();
    }
  }

  void signInToAgora(String userId) async {
    // try {
    //   await fetchRtmToken(
    //     agoraChatId.value,
    //     channelName.value,
    //   );
    //   showDebugPrint(
    //       '~~~1111~${agoraChatId.value.toString()}   ${rtmToken.value}');
    //   await _client?.login(rtmToken.value, agoraChatId.value.toString());
    //   showDebugPrint('Login success: $userId');

      // await ChatClient.getInstance
      //     .login(agoraChatId.value.toString(), rtmToken.value, false);
      // _addLogToConsole("login succeed, userId: $userId");
      // joinChatRoom("210795849908225");
   // } on ChatError catch (e) {
    //  _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
      //  getAgoraRegisterApi(agoraAppChatToken.value, userId.value);
   // }
    //  joinChatRoom("1234567890");
  }

  Future<void> addChatListener() async {
    String result = await AgoraChat.initListener();
    if(result.contains("Received a text message from")){
      chatList.add(ChatModel(result.split("|")[0].replaceAll("Received a text message from", "").trim().toString(), result.split("|")[1].trim(), colorYellow));
      chatList.refresh();
    }
    else{
      _addLogToConsole(result);
    }
  }



  void sendMessage() async {
    await FirebaseFirestore.instance
        .collection('stream_chat')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .collection('messages')
        .add({
      'message': messageController.value.text,
      'userId': store.read(userId),
      'userName': store.read(userName),
      'date': Timestamp.fromDate(DateTime.now())
    });
    messageController.value.clear();
  }

  Future clearMessages() async {
    print('~~~~~~~~~~~');
    print('cleaning ${userID.value}');
    print('~~~~~~~~~~~');

    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance
        .collection('stream_chat')
        .doc(userID.value)
        .collection('messages');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future clearAccepted() async {
    if (userID.value.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('accepted_live_request')
          .doc(userID.value)
          .delete();
    }
  }

  // void sendMessage() async {
  //   var firstAttempt = true;
  //   if (messageController.value.text == "") {
  //     _addLogToConsole("single chat id or message content is null");
  //     showMessage(enterAChatMessage.tr);
  //     return;
  //   } else {
  //     var msg = ChatMessage.createTxtSendMessage(
  //         targetId: "101",
  //         content: messageController.value.text,
  //         chatType: ChatType.Chat);

  //     ChatClient.getInstance.chatManager.addMessageEvent(
  //         "UNIQUE_HANDLER_ID",
  //         ChatMessageEvent(
  //           onSuccess: (msgId, msg) {
  //             _addLogToConsole("send message: ${messageController.value.text}");
  //             ChatTextMessageBody body = msg.body as ChatTextMessageBody;
  //             chatList
  //                 .add(ChatModel(store.read(userName), body.content, colorRed));
  //             chatList.refresh();
  //             Timer(
  //                 const Duration(milliseconds: 500),
  //                 () => scrollController.value
  //                     .jumpTo(scrollController.value.position.maxScrollExtent));
  //             messageController.value.clear();
  //           },
  //           onProgress: (msgId, progress) {
  //             _addLogToConsole("send message succeed");
  //           },
  //           onError: (msgId, msg, error) {
  //             _addLogToConsole(
  //               "send message failed, code: ${error.code}, desc: ${error.description}",
  //             );
  //             if (error.code == 500 && firstAttempt) {
  //               sendMessage();
  //               firstAttempt = false;
  //             }
  //           },
  //         ));

  //     ChatClient.getInstance.chatManager.sendMessage(msg);
  //   }
  // }

  void _addLogToConsole(String log) {
    showDebugPrint("message agora -----------------------   $log");
  }

  // Future<void> joinChatRoom(String roomId) async {
  //   try {
  //     await ChatClient.getInstance.chatRoomManager.joinChatRoom(roomId);
  //   } on ChatError catch (e) {
  //     showDebugPrint("room join failure ---- $e");
  //   }
  // }

  // Future<void> leaveChatRoom(String roomId) async {
  //   try {
  //     await ChatClient.getInstance.chatRoomManager.leaveChatRoom(roomId);
  //   } on ChatError catch (e) {
  //     showDebugPrint("room leave failure ---- $e");
  //   }
  // }

  /*--------------------AGORA CHAT END--------------------------------*/
  /*--------------------FIREBASE DATA FETCHING START--------------------------------*/
  void goOffline() async {
    if (isHost.value) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('accepted_live_request')
              .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
              .get();

      if (documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          documentSnapshot.data()!['requests'] != null) {
        List list = documentSnapshot.data()!['requests'];
        list.removeWhere((element) => element['senderId'] == userID.value);
        await FirebaseFirestore.instance
            .collection('accepted_live_request')
            .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
            .update({'requests': list});
      }
    }
    await removeRequests();
    await clearAccepted();
    await clearMessages();
    if (userID.value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("live_streaming")
          .doc(userID.value)
          .delete()
          .then((value) {
        showMessage(postDeletedSuccessfully.tr);
        isLoading.value = false;
      });
    } else {
      showMessage(postDeletedSuccessfully.tr);
      isLoading.value = false;
    }
   // await agoraEngine!.release();
  }

  Future<void> updateLiveStreamingData() async {
    showDebugPrint("inside the update live streaming data-------------------");
    await FirebaseFirestore.instance
        .collection('live_streaming')
        .doc(userID.value)
        .set({
      "user_id": userID.value,
      "agora_user_id": uid.value,
      "streaming_token": token.value,
      "streaming_channel": channelName.value,
      "chat_token": chatToken.value,
      "user_image": userData.value.profileImage,
      "user_name": userData.value.username,
    }, SetOptions(merge: true)).then((res) {
      isLoading.value = false;
      // showMessage(dataUpdatedSuccessfully.tr);
    });
  }

  Future<void> addStreamingAudience() async {
    streamingAudienceList.add(LiveAudienceModel(remoteUid.value.toString()));
    await FirebaseFirestore.instance
        .collection('live_audience')
        .doc(userID.value)
        .set({
      "requests": streamingAudienceList.value.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true)).then((res) {
      isLoading.value = false;
      streamingAudienceList.refresh();
      showMessage(dataUpdatedSuccessfully.tr);
    });
  }

  // fetchAudienceData(String userID) async {
  //   print("fetch user id audience ------------>  $userID");
  //   fetchFollowingRequests(userID);
  //   // fetchFollowers(userID);
  //   await FirebaseFirestore.instance
  //       .collection("live_audience")
  //       .doc(userID)
  //       .get()
  //       .then((value) {
  //     streamingAudienceList.clear();
  //     if (value.data() != null && value.data()!['requests'] != null) {
  //       if (value.data()!['requests'] != null &&
  //           value.data()!['requests'] != []) {
  //         for (int j = 0; j < value.data()!['requests'].length; j++) {
  //           streamingAudienceList
  //               .add(LiveAudienceModel(value.data()!['requests'][j]['userId']));
  //         }
  //       }
  //     }
  //     streamingAudienceList.refresh();
  //     Future.delayed(Duration(seconds: 2), () {
  //       if (groupStreaming.value == true) {
  //         print(
  //             "firebase remote user id ------->  ${streamingAudienceList.value[0].userId.toString()}");
  //         users.value
  //             .add(int.parse(streamingAudienceList.value[0].userId.toString()));
  //         users.refresh();
  //       }
  //     });
  //   });
  // }

  fetchUserData(String userID) async {
    isLoading.value = true;
    fetchFollowingRequests(userID);
    // fetchFollowers(userID);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) {
      var videoList = <Videos>[];
      if (value.data() != null && value.data()!['videos'] != null) {
        if (value.data()!['videos'] != null && value.data()!['videos'] != []) {
          for (int j = 0; j < value.data()!['videos'].length; j++) {
            videoList.add(Videos(value.data()!['videos'][j]['video']));
          }
        }
      }
      userData.value.id = value.data() != null ? value.data()!['userId'] : "";
      userData.value.userId =
          value.data() != null ? value.data()!['userId'] : "";
      userData.value.username =
          value.data() != null ? value.data()!['username'] : "";
      userData.value.password =
          value.data() != null ? value.data()!['password'] : "";
      userData.value.phoneNumber =
          value.data() != null ? value.data()!['phoneNumber'] : "";
      userData.value.profileImage =
          value.data() != null ? value.data()!['profileImage'] : "";
      userData.value.age = value.data() != null ? value.data()!['age'] : "";
      userData.value.state = value.data() != null ? value.data()!['state'] : "";
      userData.value.nationality =
          value.data() != null ? value.data()!['nationality'] : "";
      userData.value.web = value.data() != null ? value.data()!['web'] : "";
      userData.value.email = value.data() != null ? value.data()!['email'] : "";
      userData.value.store = value.data() != null ? value.data()!['store'] : "";
      userData.value.videos = videoList;
      userData.refresh();
      isLoading.value = false;
    });
  }

  fetchFollowingRequests(String userID) async {
    await FirebaseFirestore.instance
        .collection("follow_request")
        .doc(userID)
        .get()
        .then((value) {
      if (value.data() != null && value.data()!['requests'] != null) {
        if (value.data()!['requests'] != null &&
            value.data()!['requests'] != []) {
          for (int j = 0; j < value.data()!['requests'].length; j++) {
            followRequests.add(Followers(
                value.data()!['requests'][j]['userId'],
                value.data()!['requests'][j]['username'],
                value.data()!['requests'][j]['userImage'],
                value.data()!['requests'][j]['userCountry']));
          }
        }
      }
      followRequests.refresh();
    });
  }


  // fetchFollowers(String userID) async {
  //   showDebugPrint("User id is ---->  $userID");
  //   await FirebaseFirestore.instance
  //       .collection("followers")
  //       .doc(userID)
  //       .get()
  //       .then((value) {
  //     if (value.data() != null && value.data()!['requests'] != null) {
  //       if (value.data()!['requests'] != null &&
  //           value.data()!['requests'] != []) {
  //         for (int j = 0; j < value.data()!['requests'].length; j++) {
  //           myClientsList.value.add(Followers(
  //               value.data()!['requests'][j]['userId'],
  //               value.data()!['requests'][j]['username'],
  //               value.data()!['requests'][j]['userImage'],
  //               value.data()!['requests'][j]['userCountry']));
  //         }
  //       }
  //     }
  //     myClientsList.refresh();
  //     checkIfUserExistsInFollowers();
  //   });
  // }


  /*--------------------FIREBASE DATA FETCHING END--------------------------------*/

  Future<void> backPressButton() async {
    // try {
    //   if (agoraEngine != null) {
    //     await agoraEngine!.leaveChannel();
    //   }
    // } catch (e) {}
    //
    // leave();
    // Get.back();
  }

  removeUserFromLive(int uid) async {
    print("this is uid $uid");
    List<Map<String, dynamic>> acceptedUsers = await fetchAcceptedRequests(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value);
    acceptedUsers.removeWhere((map) => map['uid'] == uid);

    await FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .set({
      "requests": acceptedUsers,
    }, SetOptions(merge: true));
  }

  updateUID(int uid) async {

    List<Map<String, dynamic>> acceptedUsers = await fetchAcceptedRequests(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value);
    for (var map in acceptedUsers) {
      if (map['senderId'] == userID.value) {
        map['uid'] = uid;
        break;
      }
    }

    await FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .set({
      "requests": acceptedUsers,
    }, SetOptions(merge: true));

  }
  updateMuteStatusSenderId(bool isMute) async {

    List<Map<String, dynamic>> acceptedUsers = await fetchAcceptedRequests(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value);
    for (var map in acceptedUsers) {
      if (map['senderId'] == userID.value) {
        map['mute'] = isMute;
        break;
      }
    }

    await FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .set({
      "requests": acceptedUsers,
    }, SetOptions(merge: true));

  }
  updateMuteStatusUID(int uid,bool isMute) async {

    List<Map<String, dynamic>> acceptedUsers = await fetchAcceptedRequests(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value);
    for (var map in acceptedUsers) {
      if (map['uid'] == uid) {
        map['mute'] = isMute;
        break;
      }
    }

    await FirebaseFirestore.instance
        .collection('accepted_live_request')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .set({
      "requests": acceptedUsers,
    }, SetOptions(merge: true));

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

  Future<void> storeButtonClick(String url) async {
    if (url == "") {
      url = "https://www.google.com/";
    }

    if (!await launchUrl(Uri.parse(url))) {
      showDebugPrint('Could not launch =======');
    }
  }

  followButtonClick(
    ProfileModel userDetails,
  ) {
    var followerUserid = "";
    var followerUsername = "";
    var followerUserCountry = "";
    var followerUserImage = "";

    List<Followers> followers = [];

    FirebaseFirestore.instance
        .collection("users")
        .doc(userID.value)
        .get()
        .then((value) async {
      followerUserid = value.data() != null ? value.data()!['userId'] : "";
      followerUsername = value.data() != null ? value.data()!['username'] : "";
      followerUserImage =
          value.data() != null && value.data()!['profileImage'] != null
              ? value.data()!['profileImage']
              : "";
      followerUserCountry =
          value.data() != null && value.data()!['nationality'] != null
              ? value.data()!['nationality']
              : "";

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('followers')
              .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
              .get();

      if (documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          documentSnapshot.data()!['requests'] != null) {
        List<dynamic> list = documentSnapshot.data()!['requests'];
        followers = list.map((e) => Followers.fromJson(e)).toList();
      } else {
        followers = [];
      }

      followers.add(Followers(followerUserid, followerUsername,
          followerUserImage, followerUserCountry));

      FirebaseFirestore.instance
          .collection('followers')
          .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
          .set({
        "requests": followers.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true)).then((res) {
        showMessage(dataUpdatedSuccessfully.tr);
      });
      // FirebaseFirestore.instance
      //     .collection('follow_request')
      //     .doc(streamingUserId.value)
      //     .set({
      //   "requests": followRequests.value.map((e) => e.toMap()).toList(),
      // }, SetOptions(merge: true)).then((res) {
      //   isLoading.value = false;
      //   // followText.value = following.tr;
      //   FirebaseFirestore.instance
      //       .collection('followers')
      //       .doc(streamingUserId.value)
      //       .set({
      //     "requests": followRequests.value.map((e) => e.toMap()).toList(),
      //   }, SetOptions(merge: true)).then((res) {
      //     showMessage(dataUpdatedSuccessfully.tr);
      //   });
      // });
    });
  }

  unfollowButtonClick(
    ProfileModel userDetails,
  ) {
    var followerUserid = "";
    var followerUsername = "";
    var followerUserCountry = "";
    var followerUserImage = "";

    List<Followers> followers = [];

    FirebaseFirestore.instance
        .collection("users")
        .doc(userID.value)
        .get()
        .then((value) async {
      followerUserid = value.data() != null ? value.data()!['userId'] : "";
      followerUsername = value.data() != null ? value.data()!['username'] : "";
      followerUserImage =
          value.data() != null && value.data()!['profileImage'] != null
              ? value.data()!['profileImage']
              : "";
      followerUserCountry =
          value.data() != null && value.data()!['nationality'] != null
              ? value.data()!['nationality']
              : "";

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('followers')
              .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
              .get();

      if (documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          documentSnapshot.data()!['requests'] != null) {
        List<dynamic> list = documentSnapshot.data()!['requests'];
        followers = list.map((e) => Followers.fromJson(e)).toList();
      } else {
        followers = [];
      }

      followers.removeWhere((element) => element.userId == followerUserid);

      FirebaseFirestore.instance
          .collection('followers')
          .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
          .set({
        "requests": followers.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true)).then((res) {
        showMessage(dataUpdatedSuccessfully.tr);
      });
    });
  }

  // checkIfUserExistsInRequests() {
  //   int index = streamingRequestsList
  //       .indexWhere((element) => element.senderUserId == userID.value);
  //   joinRequestSent.value = index != -1;
  // }

  // checkIfUserExistsInFollowers() {
  //   int index =
  //       myClientsList.indexWhere((element) => element.userId == userID.value);
  //   followText.value = index != -1 ? following.tr : follow.tr;
  // }

  sendLiveStreamingRequest(List<StreamingRequestsModel> streamingRequestsList,String game,int challengePrice) {
    showDebugPrint("userid ------------->  ${userID.value}");

    showDebugPrint("challengeprice ------------->  $challengePrice");
    showDebugPrint("game ------------->  $game");

    isLoading.value = true;
    streamingRequestsList.add(StreamingRequestsModel(
        userID.value,
        streamingUserId.value,
        GetStorage().read(userName),
        GetStorage().read(userCountry),
        GetStorage().read(userImage),
        token.value,
        channelName.value,
        false,
        chatToken.value,
        agoraChatId.value.toString(),
        remoteUid.value.toString(),
      game: game,
      challengePrice: challengePrice
    ));

    FirebaseFirestore.instance
        .collection('live_streaming_requests')
        .doc(streamingUserId.value.isNotEmpty?streamingUserId.value:userID.value)
        .set({
      "requests": streamingRequestsList.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true)).then((res) {
      isLoading.value = false;
      showMessage(requestSent.tr);
      fetchStreamingRequests(
          isHost.value == false ? streamingUserId.value : userID.value);
    });
    //});
  }

  // Future<void> checkLiveRequestAcceptance() async {
  //   Future.delayed(Duration(seconds: 15), () async {
  //     await FirebaseFirestore.instance
  //         .collection("accepted_live_request")
  //         .doc(userID.value)
  //         .get()
  //         .then((value) {
  //       showDebugPrint(
  //           "-----------------sender id user ------- ${userID.value}");
  //       if (value.data() != null &&
  //           value.data()!['senderId'] != null &&
  //           value.data()!['senderId'] == userID.value) {
  //         showDebugPrint(
  //             "-----------------sender id ------- ${value.data()!['senderId']}");
  //         isPartnerJoin.value = true;

  //         Get.to(() => LivePartnerScreen(true, "", "",
  //             remoteUid.value.toString(), true, hostId.value.toString()));
  //       } else {
  //         checkLiveRequestAcceptance();
  //       }
  //     });
  //   });
  // }

/*void tokenGeneration(){
    streamingToken.value = RtcTokenBuilder.build(
      appId: ApiEndPoints.agoraAppId,
      appCertificate: ApiEndPoints.agoraAppCertificates,
      channelName: channelName,
      uid: "101",
      role: RtcRole.publisher,
      expireTimestamp: 1710397585,
    );

    showDebugPrint("Generated token is -> ------------   ${streamingToken.value}");
  }*/

/* void getAgoraRegisterApi(String appToken, String userId) {
    GoLiveRepo().agoraRegisterUser(appToken, userId).then((value) async {
      if (value.applicationName != "") {
        try {
          await ChatClient.getInstance.loginWithAgoraToken(
           userId,
            chatToken.value,
          );
          _addLogToConsole("login succeed, userId: $userId");
        } on ChatError catch (e) {
          _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
        }
      } else {
        return;
      }
    });
  }*/
}

class StreamUser {
  int uid;
  bool muted;
  StreamUser({
    required this.uid,
    required this.muted,
  });
}
