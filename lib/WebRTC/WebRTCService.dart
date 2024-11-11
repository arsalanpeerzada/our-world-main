import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  WebRTCService() {
    _initializeRenderers();
  }

  // Initialize video renderers
  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  // Access renderers for displaying in UI
  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  // Set up WebRTC peer connection and add local stream
  Future<void> initializeConnection() async {
    await _createPeerConnection();
    await _addLocalStream();
  }

  // Configure and create RTCPeerConnection
  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'}, // STUN server
      ]
    };
    _peerConnection = await createPeerConnection(configuration);

    // Add event listeners for handling ICE candidates and remote streams
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      // Send candidate to remote peer via signaling server (implement signaling here)
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };
  }

  // Get local media stream and add tracks to peer connection
  Future<void> _addLocalStream() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    });

    _localRenderer.srcObject = _localStream;
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });
  }

  // Create offer for initiating connection
  Future<void> createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    // Send offer to remote peer via signaling server (implement signaling here)
  }

  // Set remote answer after receiving it via signaling
  Future<void> handleAnswer(RTCSessionDescription answer) async {
    await _peerConnection!.setRemoteDescription(answer);
  }

  // Handle received ICE candidates from remote peer
  // Future<void> handleIceCandidate(RTCIceCandidate candidate) async {
  //   await _peerConnection!.addIceCandidate(candidate);
  // }

  // Clean up resources
  Future<void> dispose() async {
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    await _peerConnection?.close();
    _localStream?.dispose();
  }
}
