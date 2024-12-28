import 'package:flutter_paypal/flutter_paypal.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ourworldmain/constants/storage_constants.dart';

import '../../live_screen/ui/live_screen.dart';

class PlanController extends GetxController {
  final textController = TextEditingController().obs;
  var store = GetStorage();

  var imageUrlList = <String>[].obs;
  var isLoading = false.obs;

  var selectedCountry = 0.obs;
  var selectedCategory = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  activateFree() async {
    String uid = store.read(userId);
  }

  showPaypal(BuildContext context, String price, String title, int days) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: false,
            clientId:
                "AZvXcdCVX4Uq4UbjqeMktGwgBuMPdNnrAv3bykqBGVz0we18BFVCjFOchn6hnraiDHNXtsohOCRwDuxf",
            secretKey:
                "ENka1qN0Lv73Q_93RvmGcF3_EzhAJd6TJMJKUItpbFmX8ZYrTAgtZQo_eGOJANmT4RhR5jgLVyUYDuhk",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": price,
                  "currency": "USD",
                  "details": {
                    "subtotal": price,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },

                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },

                "item_list": {
                  "items": [
                    {
                      "name": title,
                      "quantity": 1,
                      "price": price,
                      "currency": "USD"
                    }
                  ],

                  // shipping address is not required though
                  // "shipping_address": {
                  //   "recipient_name": "Jane Foster",
                  //   "line1": "Travis County",
                  //   "line2": "",
                  //   "city": "Austin",
                  //   "country_code": "US",
                  //   "postal_code": "73301",
                  //   "phone": "+00000000",
                  //   "state": "Texas"
                  // },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              String uid = store.read(userId);
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }
}
