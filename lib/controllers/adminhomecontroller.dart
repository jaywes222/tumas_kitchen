import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  final RxInt selectedPageIndex = 0.obs;

  void selectPage(int index) {
    selectedPageIndex.value = index;
  }
}
