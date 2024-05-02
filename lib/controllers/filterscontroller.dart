import 'package:get/get.dart';

enum Filters {
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian,
}

class FiltersController extends GetxController {
  RxMap<Filters, bool> chosenFilters = RxMap<Filters, bool>({
    Filters.glutenFree: false,
    Filters.lactoseFree: false,
    Filters.vegan: false,
    Filters.vegetarian: false,
  });

  void setFilter(Filters filter, bool isActive) {
    chosenFilters[filter] = isActive;
    update();
  }
  }

