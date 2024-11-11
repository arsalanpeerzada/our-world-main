import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../game_screens/chessgame.dart';
import '../../live_screen/controller/live_controller.dart';
import '../../live_screen/model/streaming_request_model.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key, required this.price, required this.streamingRequestsModelList, required this.nextScreen});

  final double price;
  final List<StreamingRequestsModel> streamingRequestsModelList;
  final String nextScreen;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Payment Validation',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(color: Colors.grey.shade300, width: 3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.black,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Thank you!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Payment done Successfully',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Get.find<LiveController>()
                          .sendLiveStreamingRequest(
                          widget.streamingRequestsModelList,widget.nextScreen,widget.price.toInt());
                      Get.until((route) => Get.currentRoute == '/LiveScreen');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context)=>ChessGameRoom())
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Button size
                    ),
                    child: Text(
                      'Play With Me',
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
