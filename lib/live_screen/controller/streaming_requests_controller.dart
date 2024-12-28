import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ourworldmain/constants/storage_constants.dart';

import '../../common/widgets.dart';
import '../../constants/string_constants.dart';
import '../../profile/model/profile_model.dart';
import '../model/streaming_request_model.dart';

class StreamingRequestsController extends GetxController {
  var userID = "".obs;
  var streamingToken = "".obs;
  var channelName = "".obs;
  var chatToken = "".obs;
  var isLoading = false.obs;
  var requestList = <StreamingRequestsModel>[].obs;
  var followersList = <Followers>[].obs;

  sendLiveStreamingRequest(Followers userDetails, String streamingToken1,
      String channel1, String chatToken1, String game, int challengePrice) {
    showDebugPrint("userid ------------->  ${userID.value}");
    isLoading.value = true;
    var senderUserId = "";
    var receiverUserId = "";
    var senderUsername = "";
    var senderUserCountry = "";
    var senderUserImage = "";
    var streamingToken = "";
    var streamingChannel = "";
    var chatToken = "";

    requestList.add(StreamingRequestsModel(
        userID.value,
        userDetails.userId,
        GetStorage().read(userName),
        GetStorage().read(userCountry),
        GetStorage().read(userImage),
        streamingToken1,
        channel1,
        false,
        chatToken1,
        "",
        "",game: game,challengePrice: challengePrice));

    //});
  }
}
