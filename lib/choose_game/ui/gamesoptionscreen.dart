import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/card_game_module/screens/game_screen.dart';
import 'package:streaming_post_demo/live_screen/controller/live_controller.dart';

import '../../game_screens/cardgame.dart';
import '../../game_screens/chessgame_screen.dart';
import '../../live_screen/model/streaming_request_model.dart';

class ChooseYourPage extends StatelessWidget {
  const ChooseYourPage({super.key, required this.streamingRequestsModelList});

  final List<StreamingRequestsModel> streamingRequestsModelList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center the items horizontally
                children: [
                  // Top Circle with Image
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: CircleAvatar(
                      radius: 60, // Adjust size as needed
                      backgroundImage: AssetImage('assets/images/profile3d.png'), // Replace with your image
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Text below the circle
                  const Text(
                    'Please choose Yours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // First Image Container and Button
                  _buildImageContainerWithButton(context, 'assets/images/live-streaming.png'),
                  const SizedBox(height: 20),

                  // Second Image Container with white box and text and Next button
                  _buildImageWithTextOverlayAndButton(
                    context,
                    'assets/images/chess.png',
                    'Chess Game',
                        () {

                          Get.to(ChessGamePage(streamingRequestsModelList: streamingRequestsModelList,));
                        //   Navigator.push(
                        // context,
                        // MaterialPageRoute(builder: (context) => ChessGamePage()), // Navigate to ChessGamePage
                      // );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Third Image Container with white box and text and Next button
                  _buildImageWithTextOverlayAndButton(
                    context,
                    'assets/images/cards.png',
                    'Playing Card Box',
                        () {
                          Get.to(PlayingCardBoardPage(streamingRequestsModelList: streamingRequestsModelList,));
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text(
                          //       "Game Not Supported Yet",
                          //     ),
                          //   ),
                          // );

                    },
                  ),
                  const SizedBox(height: 20),

                  // Third Image Container with white box and text and Next button
                  _buildImageWithTextOverlayAndButton(
                    context,
                    'assets/images/pool-game.jpg',
                    '8 Ball Pool',
                        () {
                      // Get.to(PlayingCardBoardPage(streamingRequestsModelList: streamingRequestsModelList,));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Game Not Supported Yet",
                          ),
                        ),
                      );

                    },
                  ),
                  const SizedBox(height: 20),

                  // Third Image Container with white box and text and Next button
                  _buildImageWithTextOverlayAndButton(
                    context,
                    'assets/images/domino-pic.jpg',
                    'Domino Game',
                        () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Game Not Supported Yet",
                          ),
                        ),
                      );

                    },
                  ),

                  const SizedBox(height: 20),

                  // Third Image Container with white box and text and Next button
                  _buildImageWithTextOverlayAndButton(
                    context,
                    'assets/images/game-pic.jpg',
                    'Chees Game',
                        () {
                      // Get.to(PlayingCardBoardPage(streamingRequestsModelList: streamingRequestsModelList,));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Game Not Supported Yet",
                          ),
                        ),
                      );

                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20, // Adjust the position as needed
            top: 40,   // Adjust the position as needed
            child: IconButton(
              icon: const Icon(Icons.close_outlined, size: 30, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Close the page or perform any action
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the container with the image and button
  Widget _buildImageContainerWithButton(BuildContext context, String imagePath) {
    return Column(
      children: [
        Container(
          width: 320,
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            imagePath, // Replace with your actual image path
            fit: BoxFit.contain
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Add your navigation logic or action here for the first box
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black, // Button background color
            minimumSize: const Size(100, 50),    // Button width and height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),  // Adjust this to make the curve smaller
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  // Helper method to build an image container with an overlay white box, text, and Next button
  Widget _buildImageWithTextOverlayAndButton(
      BuildContext context,
      String imagePath,
      String text,
      VoidCallback onPressedAction // Action when "Next" is pressed
      ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter, // Aligns the box at the bottom center
          children: [
            Container(
              width: 320,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath, // Replace with your actual image path
                  fit: BoxFit.cover,
                  height: 140,
                ),
              ),
            ),
            Positioned(
              bottom: 6, // Position the white box at the bottom
              child: Container(
                width: 220,
                height: 50, // Height of the white box
                color: Colors.white.withOpacity(0.7), // Background color of the box
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressedAction,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black, // Button background color
            minimumSize: const Size(100, 50),    // Button width and height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),  // Adjust this to make the curve smaller
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
