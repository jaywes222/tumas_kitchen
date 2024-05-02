import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/filterscontroller.dart';

class FiltersScreen extends StatelessWidget {
  final FiltersController filtersController = Get.put(FiltersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Filters'),
      ),
      body: Column(
        children: [
          _buildFilterTile(
            context,
            'Gluten-free',
            'Only include Gluten-free meals',
            Filters.glutenFree,
          ),
          _buildFilterTile(
            context,
            'Lactose-free',
            'Only include Lactose-free meals',
            Filters.lactoseFree,
          ),
          _buildFilterTile(
            context,
            'Vegan',
            'Only include Vegan meals',
            Filters.vegan,
          ),
          _buildFilterTile(
            context,
            'Vegetarian',
            'Only include Vegetarian meals',
            Filters.vegetarian,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTile(
    BuildContext context,
    String title,
    String subtitle,
    Filters filter,
  ) {
    return Obx(() => SwitchListTile(
          value: filtersController.chosenFilters[filter]!,
          onChanged: (isChecked) {
            filtersController.setFilter(filter, isChecked);
          },
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          activeColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.only(
            left: 34,
            right: 22,
          ),
        ));
  }
}
