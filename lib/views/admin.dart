import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/adminhomecontroller.dart';
import 'package:tumaz_kitchen/controllers/filterscontroller.dart';
import 'package:tumaz_kitchen/views/categories.dart';
import 'package:tumaz_kitchen/views/orders.dart';

class ManagementScreen extends StatelessWidget {
  final String title;

  const ManagementScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage $title'),
      ),
      body: Center(
        child: Text('Manage $title Screen'),
      ),
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  final FiltersController filtersController = Get.put(FiltersController());
  final AdminHomeController adminController = Get.put(AdminHomeController());

  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final titles = ['Categories', 'Users', 'Recipes', 'Orders'];
          return Text(
              'Manage ${titles[adminController.selectedPageIndex.value]}');
        }),
        actions: _buildActions(context), // Pass context to _buildActions
      ),
      drawer: buildDrawer(),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final title = [
      'Categories',
      'Users',
      'Recipes',
      'Orders'
    ][adminController.selectedPageIndex.value];
    if (title == 'Recipes') {
      return [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddRecipeDialog(context), // Pass context
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _showRemoveRecipeDialog(context), // Pass context
        ),
      ];
    }
    return [];
  }

  void _showAddRecipeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Recipe'),
          content: const Text('Add recipe form goes here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to add recipe
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveRecipeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Recipe'),
          content: const Text('Are you sure you want to remove this recipe?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to remove recipe
                Navigator.pop(context);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          buildDrawerItem(title: 'Categories', route: '/manage_categories'),
          buildDrawerItem(title: 'Users', route: '/manage_users'),
          buildDrawerItem(title: 'Recipes', route: '/manage_recipes'),
          buildDrawerItem(title: 'Orders', route: '/manage_orders'),
        ],
      ),
    );
  }

  ListTile buildDrawerItem({required String title, required String route}) {
    return ListTile(
      title: Text('Manage $title'),
      onTap: () {
        Get.back();
        Get.toNamed(route);
      },
    );
  }

  Widget buildBody() {
    return Obx(() {
      switch (adminController.selectedPageIndex.value) {
        case 0:
          return const CategoriesScreen(
            availableMunchies: [],
          );
        case 1:
          return const ManagementScreen(title: 'Users');
        case 2:
          return const ManagementScreen(title: 'Recipes');
        case 3:
          return const OrdersScreen();
        default:
          return Container();
      }
    });
  }

  Widget buildBottomNavigationBar() {
    return Obx(() => BottomNavigationBar(
          onTap: adminController.selectPage,
          currentIndex: adminController.selectedPageIndex.value,
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Orders',
            ),
          ],
        ));
  }
}
