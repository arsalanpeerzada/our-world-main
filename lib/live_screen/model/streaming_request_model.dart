class StreamingRequestsModel{
  String? senderUserId;
  String? receiverUserId;
  String? senderUsername;
  String? senderUserCountry;
  String? senderUserImage;
  String? streamingToken;
  bool? hasAccepted;
  String? streamingChannel;
  String? chatToken;
  String? remoteID;
  String? hostID;
  String? game;
  int? challengePrice;

  StreamingRequestsModel(this.senderUserId, this.receiverUserId, this.senderUsername,
      this.senderUserCountry, this.senderUserImage, this.streamingToken,
      this.streamingChannel,
      this.hasAccepted,
      this.chatToken, this.remoteID, this.hostID,
      {required this.game,
      required this.challengePrice});

  StreamingRequestsModel.fromJson(Map<String, dynamic> json) {
    senderUserId = json['senderUserId'].toString();
    receiverUserId = json['receiverUserId'].toString();
    senderUsername = json['senderUsername'].toString();
    senderUserCountry = json['senderUserCountry'].toString();
    senderUserImage = json['senderUserImage'].toString();
    streamingToken = json['streamingToken'].toString();
    streamingChannel = json['streamingChannel'].toString();
    hasAccepted = json['hasAccepted'];
    chatToken = json['chatToken'].toString();
    remoteID = json['remoteID'].toString();
    hostID = json['hostID'].toString();
    game= json['game'].toString();
    challengePrice= json['challengePrice'] as int;
  }

  Map<String, dynamic> toMap() {

    return {
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'senderUsername': senderUsername,
      'senderUserCountry': senderUserCountry,
      'senderUserImage': senderUserImage,
      'streamingToken': streamingToken,
      'streamingChannel': streamingChannel,
      'chatToken': chatToken,
      'remoteID': remoteID,
      'hostID': hostID,
      'challengePrice': challengePrice,
      'game': game
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderUserId'] = senderUserId;
    data['receiverUserId'] = receiverUserId;
    data['senderUsername'] = senderUsername;
    data['senderUserCountry'] = senderUserCountry;
    data['senderUserImage'] = senderUserImage;
    data['streamingToken'] = streamingToken;
    data['streamingChannel'] = streamingChannel;
    data['chatToken'] = chatToken;
    data['remoteID'] = remoteID;
    data['hostID'] = hostID;
    data['challengePrice']= challengePrice;
    data['game']= game;
    return data;
  }
}

