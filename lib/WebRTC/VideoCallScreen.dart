import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:streaming_post_demo/WebRTC/WebRTCService.dart';


class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late WebRTCService _webrtcService;

  @override
  void initState() {
    super.initState();
    _webrtcService = WebRTCService();
    _webrtcService.initializeConnection();
  }

  @override
  void dispose() {
    _webrtcService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Call')),
      body: Column(
        children: [
          Expanded(child: RTCVideoView(_webrtcService.localRenderer)),
          Expanded(child: RTCVideoView(_webrtcService.remoteRenderer)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _webrtcService.createOffer, // Initiate the call
        child: Icon(Icons.video_call),
      ),
    );
  }
}
