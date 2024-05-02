import 'package:get/get.dart';
import 'package:tumaz_kitchen/views/filters.dart';
import 'package:tumaz_kitchen/views/login.dart';
import 'package:tumaz_kitchen/views/orders.dart';
import 'package:tumaz_kitchen/views/profile.dart';
import 'package:tumaz_kitchen/views/registration.dart';

class Routes {
  static var routes = [
    GetPage(
      name: "/",
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: "/registration",
      page: () => const RegistrationScreen(),
    ),
    GetPage(
      name: "/filters",
      page: () => FiltersScreen(),
    ),
    GetPage(
      name: "/profile",
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: "/orders",
      page: () => const OrdersScreen(),
    ),
  ];
}
