import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../live_screen/model/streaming_request_model.dart';
import '../payment_screens/ui/payment_method.dart';

class PlayingCardBoardPage extends StatefulWidget {
  const PlayingCardBoardPage(
      {super.key, required this.streamingRequestsModelList});
  final List<StreamingRequestsModel> streamingRequestsModelList;

  @override
  State<PlayingCardBoardPage> createState() => _PlayingCardBoardPageState();
}

class _PlayingCardBoardPageState extends State<PlayingCardBoardPage> {
  double _currentValue = 50.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Black Section with Back Button
          Container(
            color: Colors.black,
            padding: const EdgeInsets.only(top: 40, left: 10, bottom: 10),
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Action for the back button
                  },
                ),
              ],
            ),
          ),

          // White Background Section
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 70),

                  // Text "Playing Card Board"
                  const Text(
                    'Playing Card Board',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Image
                  Container(
                    width: 320,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/cards.png', // Replace with your actual image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildTextField("Enter Price"),
                  const SizedBox(height: 20),
                  // Black Box with Price Information
                  // Container(
                  //   width: 200,
                  //   height: 90,
                  //   padding: const EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.black,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Text(
                  //         'Price',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 40,
                  //         width: 1,
                  //         color: Colors.white, // White center line
                  //       ),
                  //       const Text(
                  //         '\$50', // Replace with your price
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 20),

                  // Next Button
                  ElevatedButton(
                    onPressed: () {
                      Get.to(PaymentMethodScreen(
                        currentValue: _currentValue,
                        streamingRequestsModelList:
                            widget.streamingRequestsModelList,
                        gameCase: 'card',
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black, // Button background color
                      minimumSize:
                          const Size(110, 70), // Button width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust this to make the curve smaller
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTextField(String labelText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border
            borderSide: const BorderSide(
              color: Colors.black, // Black border color
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border
            borderSide: const BorderSide(
              color: Colors.black, // Black border color
              width: 2.0, // Border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border
            borderSide: const BorderSide(
              color: Colors.black, // Black border color when focused
              width: 2.0,
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          _currentValue = double.parse(value);
        },
      ),
    );
  }

  buildPaymentAmountField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Slider without label
        Slider(
          value: _currentValue,
          min: 50,
          max: 1000,
          divisions: 19, // This makes the steps of 50 between 50 and 1000
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),

        // Display min and max values
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$50', style: TextStyle(fontSize: 18)),
            Text('\$1000', style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}
