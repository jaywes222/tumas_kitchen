import 'package:get/get.dart';
import 'package:tumaz_kitchen/models/munch.dart';

class FavoriteMunchiesController extends GetxController {
  RxList<MunchiesModel> favoriteMunchies = <MunchiesModel>[].obs;

  bool toggleMunchiesFavoriteStatus(MunchiesModel munch) {
    final munchIsFavorite = favoriteMunchies.contains(munch);

    if (munchIsFavorite) {
      favoriteMunchies.removeWhere((m) => m.id == munch.id);
      return false;
    } else {
      favoriteMunchies.add(munch);
      return true;
    }
  }
}
