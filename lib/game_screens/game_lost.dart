import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../choose_game/ui/gamesoptionscreen.dart';
import '../live_screen/ui/live_screen.dart';

class GameLossScreen extends StatefulWidget {
  const GameLossScreen({super.key});

  @override
  State<GameLossScreen> createState() => _GameLossScreenState();
}

class _GameLossScreenState extends State<GameLossScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.until((route) => Get.currentRoute == '/ChooseYourPage');

            // Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
            // Get.to(() => LiveScreen(isHost: false,streamingUserIds:  snapshot.data!.docs[index].get('user_id'),
            //     streamingToken: snapshot.data!.docs[index].get('streaming_token'),
            //     streamingJoiningId: "0", groupStreaming: false, hostId: "0",channelName:  snapshot.data!.docs[index]
            //         .get('streaming_channel')));
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Oops!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You have Lost the game To Mr John',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Image.asset('assets/images/you_lose.png', height: 80),
                  SizedBox(height: 30),
                  OutlinedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide(color: Colors.white),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Button size
                    ),
                    child: Text(
                      'Live Streaming',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
