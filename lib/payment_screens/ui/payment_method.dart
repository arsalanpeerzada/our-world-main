import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streaming_post_demo/payment_screens/ui/payment_success.dart';

import '../../live_screen/model/streaming_request_model.dart';

class PaymentMethodScreen extends StatefulWidget {

  const PaymentMethodScreen({super.key, required this.currentValue, required this.streamingRequestsModelList, required this.gameCase});
  final double currentValue;
  final List<StreamingRequestsModel> streamingRequestsModelList;
  final String gameCase;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {

    bool checkValue = false;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: size.height/6,
          ),
          Expanded(child:
          Container(
            height: size.height * (5/6),
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){Get.back();},icon: Icon(Icons.arrow_back_ios_new)),
                    Expanded(child: SizedBox())
                  ],
                ),
                const Text("Select a payment method",style: TextStyle(fontSize: 25),),
                Center(child: buildPaymentOptionButton(),),
            const SizedBox(height: 30),
                SizedBox(height: 30),
                buildTextField('Name on Card'),
                SizedBox(height: 20),
                buildTextField('Card number', keyboardType: TextInputType.number),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField('CVV', keyboardType: TextInputType.number),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: buildTextField('Expiry date', hintText: 'MM/YY', keyboardType: TextInputType.datetime),
                    ),
                  ],
                ),
            Row(
              children: [
                Checkbox(value: checkValue, onChanged: (bool? value) {
                  setState(() {
                    checkValue = !checkValue;
                  });
                }),
                const Text('Save card details for future transactions'),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(PaymentSuccessScreen(price: widget.currentValue, streamingRequestsModelList: widget.streamingRequestsModelList,nextScreen: widget.gameCase,));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.black
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),),
              ],
            ),
          ))
        ],

      ),
    );
  }

  buildTextField(String labelText, {String? hintText, TextInputType? keyboardType}) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),  // Circular border
          borderSide: const BorderSide(
            color: Colors.black,  // Black border color
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),  // Circular border
          borderSide: const BorderSide(
            color: Colors.black,  // Black border color
            width: 2.0,           // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),  // Circular border
          borderSide: const BorderSide(
            color: Colors.black,  // Black border color when focused
            width: 2.0,
          ),
        ),
      ),
      keyboardType: keyboardType,
    );
  }



buildPaymentOptionButton(){
    var options = ["google_pay.png","visa.png","paypal.png"];
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
          itemBuilder: (context,index){
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(10),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              // image: const DecorationImage(image: AssetImage("assets/images/google_pay.png")),
              borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 3)
          ),
          child: Image.asset("assets/images/${options[index]}"),
        );
      }),
    );
  }
}
