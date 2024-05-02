import 'package:get/get.dart';

class UserHomeController extends GetxController {
  var selectedPageIndex = 0.obs;

  void selectPage(int index) {
    selectedPageIndex.value = index;
  }
}
