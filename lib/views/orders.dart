import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/ordercontroller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (orderController.orders.isEmpty) {
            return const Center(
              child: Text('No orders placed'),
            );
          } else {
            return ListView.builder(
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                if (index < orderController.orders.length &&
                    index < orderController.prices.length &&
                    index < orderController.quantities.length) {
                  final order = orderController.orders[index];
                  final price = orderController.prices[index];
                  final quantity = orderController.quantities[index];
                  return ListTile(
                    title: Text(order),
                    subtitle: Text('Price: KES $price, Quantity: $quantity'),
                    onTap: () {
                      //Get.to(const OrderDetailScreen());
                    },
                  );
                } else {
                  return const Placeholder();
                }
              },
            );
          }
        }),
      ),
    );
  }
}
