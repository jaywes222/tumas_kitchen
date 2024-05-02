import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/favoritemunchiescontroller.dart';
import 'package:tumaz_kitchen/views/munch_detail.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteMunchiesController favoriteController =
        Get.put(FavoriteMunchiesController());

    return Scaffold(
      body: Obx(
        () {
          final favoriteMunchies = favoriteController.favoriteMunchies;
          return favoriteMunchies.isEmpty
              ? const Center(
                  child: Text('No favorites added'),
                )
              : ListView.builder(
                  itemCount: favoriteMunchies.length,
                  itemBuilder: (context, index) {
                    final munch = favoriteMunchies[index];
                    return ListTile(
                      title: Text(munch.title),
                      subtitle: Text('Duration: ${munch.duration} mins'),
                      leading: Image.asset(
                        munch.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Get.to(MunchDetailScreen(munch: munch));
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
