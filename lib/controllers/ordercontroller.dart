import 'package:get/get.dart';

class OrderController extends GetxController {
  RxList<String> orders = <String>[].obs;
  RxList<double> prices = <double>[].obs;
  RxList<double> quantities = <double>[].obs;

  // Define updateOrderList to update the list of orders
  void updateOrderList(String order, double price, double quantity) {
    orders.add(order);
    prices.add(price);
    quantities.add(quantity);
  }

  bool toggleOrderStatus(String order, double price, double quantity) {
    final orderIndex = orders.indexOf(order);

    if (orderIndex != -1) {
      orders.removeAt(orderIndex);
      prices.removeAt(orderIndex);
      quantities.removeAt(orderIndex);
      return false;
    } else {
      orders.add(order);
      prices.add(price);
      quantities.add(quantity);
      return true;
    }
  }
}
