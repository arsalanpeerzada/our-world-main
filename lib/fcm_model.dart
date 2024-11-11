class FCMModel {
  FCMNotification? notification;
  String? priority;
  FCMData? data;
  String? to;

  FCMModel({this.notification, this.priority, this.data, this.to});

  FCMModel.fromJson(Map<String, dynamic> json) {
    notification = json['notification'] != null
        ? new FCMNotification.fromJson(json['notification'])
        : null;
    priority = json['priority'];
    data = json['data'] != null ? new FCMData.fromJson(json['data']) : null;
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    data['priority'] = this.priority;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['to'] = this.to;
    return data;
  }
}

class FCMNotification {
  String? body;
  String? title;

  FCMNotification({this.body, this.title});

  FCMNotification.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }
}

class FCMData {
  String? clickAction;
  String? id;
  String? body;
  String? title;
  String? status;

  FCMData({this.clickAction, this.id, this.body, this.title, this.status});

  FCMData.fromJson(Map<String, dynamic> json) {
    clickAction = json['click_action'];
    id = json['id'];
    body = json['body'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['click_action'] = this.clickAction;
    data['id'] = this.id;
    data['body'] = this.body;
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
}
