import 'package:agora_rtc_wrapper/agora_rtc_wrapper.dart';
import 'package:flutter/material.dart';

/// Created by taohid on 15,May, 2020
/// Email: taohid32@gmail.com

class VideoCallScreen extends StatefulWidget {
  final String channelId;

  VideoCallScreen({@required this.channelId});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  AgoraRtcWrapper _agoraUtils;
  int joinedUId = -1;

  @override
  void initState() {
    super.initState();
    _agoraUtils =
        AgoraRtcWrapper('Your Agora App Id', onUserJoined: _onUserJoined);
    if (widget.channelId != null && widget.channelId.isNotEmpty) {
      _agoraUtils.joinChannel(widget.channelId);
    }
  }

  void _onUserJoined(int uid, int elapsed) {
    setState(() {
      joinedUId = uid;
    });
  }

  @override
  void dispose() {
    _agoraUtils.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Video Call Test'),
      ),
      body: Stack(
        children: <Widget>[
          joinedUId != -1 ? _agoraUtils.getVideoView(joinedUId) : Container(),
          Positioned(
            right: 0,
            child: SizedBox(
              height: 180,
              width: 150,
              child: _agoraUtils.getSelfVideoView,
            ),
          ),
          _agoraUtils.getDefaultController(
            onCallEnd: () {
              Navigator.pop(context);
            },
            onMute: (isMute) {
              setState(() {
                _agoraUtils.muteAudio(!isMute);
              });
            },
          )
        ],
      ),
    );
  }
}
