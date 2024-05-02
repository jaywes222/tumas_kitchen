import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/filterscontroller.dart';
import 'package:tumaz_kitchen/controllers/userhomecontroller.dart';
import 'package:tumaz_kitchen/controllers/authcontroller.dart';
import 'package:tumaz_kitchen/views/categories.dart';
import 'package:tumaz_kitchen/views/orders.dart';
import 'package:tumaz_kitchen/views/favorites.dart';
import 'package:tumaz_kitchen/widgets/main_drawer.dart';

class UserHomeScreen extends StatelessWidget {
  final FiltersController filtersController = Get.put(FiltersController());
  final UserHomeController tabsController = Get.put(UserHomeController());
  final AuthController authController = Get.find<AuthController>();

  UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final titles = ['Categories', 'Favorites', 'Orders'];
          final currentIndex = tabsController.selectedPageIndex.value;
          return Text(titles[currentIndex]);
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() {
              final userName = authController.userName.value;
              return Text('Jambo $userName,',
                  style: const TextStyle(fontSize: 16));
            }),
          ),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: (identifier) => _setScreen(identifier, context),
      ),
      body: Obx(() {
        final activePageIndex = tabsController.selectedPageIndex.value;
        return IndexedStack(
          index: activePageIndex,
          children: const [
            CategoriesScreen(availableMunchies: [],),
            FavoritesScreen(),
            OrdersScreen(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            onTap: tabsController.selectPage,
            currentIndex: tabsController.selectedPageIndex.value,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.set_meal),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Orders',
              ),
            ],
          )),
    );
  }

  void _setScreen(String identifier, BuildContext context) async {
    Navigator.of(context).pop();
    switch (identifier) {
      case 'Filters':
        await Get.toNamed('/filters');
        break;
      case 'Profile':
        await Get.toNamed('/profile');
        break;
      case 'Settings':
        await Get.toNamed('/settings');
        break;
      case 'About':
        await Get.toNamed('/about');
        break;
      case 'Help & Feedback':
        await Get.toNamed('/help-feedback');
        break;
      case 'Sign Out':
        await Get.toNamed('/sign-out');
        break;
      case 'Delete Account':
        await Get.toNamed('/delete-account');
        break;
      default:
        print('Invalid identifier');
    }
  }
}
