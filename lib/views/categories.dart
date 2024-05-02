import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:tumaz_kitchen/models/category.dart';
import 'package:tumaz_kitchen/models/munch.dart';
import 'package:tumaz_kitchen/views/munchies.dart';
import 'package:tumaz_kitchen/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMunchies});

  final List<MunchiesModel> availableMunchies;

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    )..forward();

    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(
          'https://scholarcrafts.xyz/tumas_kitchen/getcategories.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['categories'];
        final List<CategoryModel> categories = data.map((item) {
          final colorHex = item['color'] as String;
          return CategoryModel(
            id: item['id'],
            title: item['title'],
            color: Color(int.parse(colorHex.replaceAll('#', ''), radix: 16)),
          );
        }).toList();
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _selectCategory(BuildContext context, CategoryModel category) {
    final filteredMunch = widget.availableMunchies
        .where((munch) => munch.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MunchiesScreen(
          title: category.title,
          munch: filteredMunch,
          categoryId: category.id,
          categories: _categories,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to fetch categories.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchCategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      return AnimatedBuilder(
        animation: _animationController,
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            );
          },
        ),
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: child!,
        ),
      );
    }
  }
}
