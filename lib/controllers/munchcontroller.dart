import 'package:get/get.dart';

class MunchController extends GetxController {
  RxInt munchId = RxInt(0);

  int get munchIdValue => munchId.value;

  void setMunchId(int id) {
    munchId.value = id;
  }
}
