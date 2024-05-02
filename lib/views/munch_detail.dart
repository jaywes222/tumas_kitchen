import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/authcontroller.dart';
import 'package:tumaz_kitchen/controllers/favoritemunchiescontroller.dart';
import 'package:tumaz_kitchen/controllers/ordercontroller.dart';
import 'package:tumaz_kitchen/main.dart';
import 'package:tumaz_kitchen/models/munch.dart';
import 'package:tumaz_kitchen/views/orders.dart';

class MunchDetailScreen extends StatefulWidget {
  final MunchiesModel munch;
  final AuthController authController = Get.find<AuthController>();

  MunchDetailScreen({super.key, required this.munch});

  @override
  State<MunchDetailScreen> createState() => _MunchDetailScreenState();
}

class _MunchDetailScreenState extends State<MunchDetailScreen> {
  late FavoriteMunchiesController favoriteController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favoriteController = Get.find<FavoriteMunchiesController>();
    isFavorite = favoriteController.favoriteMunchies.contains(widget.munch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.munch.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = favoriteController
                    .toggleMunchiesFavoriteStatus(widget.munch);
              });
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite
                      ? 'Munch added as My Favorite'
                      : 'Munch Removed'),
                ),
              );
            },
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.munch.id,
              child: Image.asset(
                widget.munch.imagePath,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Ingredients'),
            const SizedBox(height: 10),
            _buildIngredientsList(),
            const SizedBox(height: 20),
            _buildSectionTitle('Steps'),
            const SizedBox(height: 10),
            _buildStepsList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showOrderDialog(context);
              },
              child: const Text('Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.munch.ingredients
          .map((ingredient) => Text(
                ingredient,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStepsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.munch.steps.length,
      itemBuilder: (context, index) {
        final step = widget.munch.steps[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            step,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        );
      },
    );
  }

void _performOrder(double selectedPrice, double selectedQuantity) {
    Navigator.of(context).pop(); // Close the dialog
    print("Order Placed: Price - $selectedPrice, Quantity - $selectedQuantity");

    Get.find<OrderController>()
        .updateOrderList("Your Order", selectedPrice, selectedQuantity);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: theme,
          child: AlertDialog(
            title: const Text(
              'Order Placed',
              style: TextStyle(color: Colors.green),
            ),
            content: Text(
              'Your order has been successfully placed.',
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
            backgroundColor: theme.colorScheme.background,
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                  // Navigate to the orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _showOrderDialog(BuildContext context) {
    double? selectedPrice;
    double selectedQuantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: theme,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: theme.colorScheme.background,
                title: Text(
                  'Select Price and Quantity',
                  style: TextStyle(color: theme.colorScheme.onBackground),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Price:',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                    DropdownButton<double>(
                      value: selectedPrice,
                      onChanged: (double? value) {
                        setState(() {
                          selectedPrice = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem<double>(
                          value: 1600.0,
                          child: Text(
                            'Small - 1600',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground),
                          ),
                        ),
                        DropdownMenuItem<double>(
                          value: 1900.0,
                          child: Text(
                            'Medium - 1900',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground),
                          ),
                        ),
                        DropdownMenuItem<double>(
                          value: 2200.0,
                          child: Text(
                            'Large - 2200',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Select Quantity:',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                    DropdownButton<double>(
                      value: selectedQuantity,
                      onChanged: (double? value) {
                        setState(() {
                          selectedQuantity = value!;
                        });
                      },
                      items:
                          List.generate(10, (index) => index + 1).map((value) {
                        return DropdownMenuItem<double>(
                          value: value.toDouble(),
                          child: Text(
                            value.toString(),
                            style: TextStyle(
                                color: theme.colorScheme.onBackground),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Total Amount: KES${selectedPrice != null ? selectedPrice! * selectedQuantity : 0}',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedPrice != null) {
                        _performOrder(selectedPrice!, selectedQuantity);
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please select a price before placing the order',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                    child: Text(
                      'Order',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
