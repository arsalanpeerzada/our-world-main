import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/storage_constants.dart';

class UserProfileScreenController extends GetxController {

  final uservalue = "".obs;
  var store = GetStorage();

  @override
  onInit() {
    super.onInit();

    uservalue.value = store.read(userName) ?? "";
    String token = store.read('token') ?? "";
  }
}