
import 'package:get/get.dart';
import 'package:ourworldmain/live_screen/model/streaming_request_model.dart';


import '../../common/widgets.dart';
import '../../constants/string_constants.dart';
import '../../live_screen/ui/live_screen.dart';

class FollowRequestsController extends GetxController {
  var userID = "".obs;

  //var requestsList = <Followers>[].obs;
  var requestsList = <StreamingRequestsModel>[].obs;

  fetchFollowingRequests(String userID) async {

  }

  void deleteStreamingRequest(int index) {
    requestsList.removeAt(index);
    requestsList.refresh();

  }

  void acceptFollowRequest(
      int index, String remoteId, String hostId, String senderId) {
    // deleteStreamingRequest(index);
    showDebugPrint(
        "remote id on request screen---------------------   $remoteId");
    setRequestAccept(senderId);
    //Get.to(() => LiveScreen(true, "", "", remoteId, true, hostId) );
  }

  setRequestAccept(String senderId) async {
  }
}
