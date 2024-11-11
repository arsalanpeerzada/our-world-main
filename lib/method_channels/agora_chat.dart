import 'package:flutter/services.dart';

class AgoraChat {
  static const MethodChannel _channel = MethodChannel('agora_chat');

  static Future<String> initListener() async {
    try {
      final result = await _channel.invokeMethod('initListener');
      return result;
    } on PlatformException catch (e) {
      return e.message??"";
    }
  }
  static Future<String> joinChatRoom(String roomId) async {
    try {
      final result = await _channel.invokeMethod('joinChatRoom');
      return result;
    } on PlatformException catch (e) {
      return e.message??"";
    }
  }
}
