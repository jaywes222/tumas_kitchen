import 'package:get/get.dart';

class AuthController extends GetxController {
  var phoneNumber = "".obs;
  var userName = "".obs;

  updateUserInfo({required String number, required String name}) {
    phoneNumber.value = number;
    userName.value = name;
  }
}
