import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tumaz_kitchen/models/category.dart';
import 'dart:convert';

import 'package:tumaz_kitchen/models/munch.dart';
import 'package:tumaz_kitchen/views/munch_detail.dart';
import 'package:tumaz_kitchen/widgets/munch_item.dart';

class MunchiesScreen extends StatefulWidget {
  const MunchiesScreen({
    super.key,
    this.title,
    required this.categoryId,
    required List<MunchiesModel> munch,
    required this.categories,
  });

  final String? title;
  final String categoryId;
  final List<CategoryModel> categories;

  @override
  _MunchiesScreenState createState() => _MunchiesScreenState();
}

class _MunchiesScreenState extends State<MunchiesScreen> {
  Map<String, List<MunchiesModel>> categorizedMunchies = {};
  Map<String, String> categoryNames = {};
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    _getMunchies();
  }

  void _initializeCategories() {
    categoryNames = { for (var category in widget.categories) category.id : category.title };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: isLoading
          ? _buildLoading()
          : isError
              ? _buildError()
              : _buildBody(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Failed to fetch munchies.'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getMunchies,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return categorizedMunchies.isEmpty
        ? Center(
            child: Text(
              'No munchies available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        : ListView.builder(
            itemCount: categorizedMunchies.length,
            itemBuilder: (ctx, index) {
              final category = categorizedMunchies.keys.elementAt(index);
              final munchiesInCategory = categorizedMunchies[category]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: munchiesInCategory.length,
                    itemBuilder: (ctx, index) {
                      return MunchItem(
                        munch: munchiesInCategory[index],
                        onSelectMunch:
                            (BuildContext context, MunchiesModel munch) {
                          _selectMunch(context, munch);
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
  }

Future<void> _getMunchies() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final categoryId = widget.categoryId;
      if (categoryId.isNotEmpty) {
        final response = await http.get(
          Uri.parse(
              'https://scholarcrafts.xyz/tumas_kitchen/getmunchies.php?categoryId=$categoryId'),
        );
        if (response.statusCode == 200) {
          final String responseBody = response.body;
          if (responseBody.isNotEmpty) {
            final Map<String, dynamic> data = json.decode(responseBody);
            if (data['success'] == 1) {
              final List<dynamic> munchiesData = data['munchies'];
              final List<MunchiesModel> fetchedMunchies =
                  munchiesData.map((item) {
                return MunchiesModel(
                  id: item['id'],
                  title: item['title'],
                  imagePath: item['imagePath'],
                  ingredients: List<String>.from(item['ingredients']),
                  steps: List<String>.from(item['steps']),
                  duration: item['duration'],
                  complexity: Complexity.values[item['complexity']],
                  affordability: Affordability.values[item['affordability']],
                  isGlutenFree: item['isGlutenFree'] == 1,
                  isLactoseFree: item['isLactoseFree'] == 1,
                  isVegan: item['isVegan'] == 1,
                  isVegetarian: item['isVegetarian'] == 1,
                  categoryId: item['category_id'].toString(),
                  categories: [''],
                );
              }).toList();

              // Group munchies by category
              categorizedMunchies.clear();
              for (var munch in fetchedMunchies) {
                final category = _getCategoryName(munch.categoryId);
                if (!categorizedMunchies.containsKey(category)) {
                  categorizedMunchies[category] = [];
                }
                categorizedMunchies[category]!.add(munch);
              }

              setState(() {
                isLoading = false;
              });
            } else {
              setState(() {
                isLoading = false;
                isError = true;
              });
              print('Failed to fetch munchies: ${data['message']}');
            }
          } else {
            setState(() {
              isLoading = false;
              isError = true;
            });
            print('Failed to fetch munchies: Response body is empty');
          }
        } else {
          setState(() {
            isLoading = false;
            isError = true;
          });
          print('Failed to fetch munchies: ${response.statusCode}');
        }
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        print('Category ID is null or empty');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error fetching munchies: $error');
    }
  }

  String _getCategoryName(String categoryId) {
    return categoryNames[categoryId] ?? categoryId;
  }

  void _selectMunch(BuildContext context, MunchiesModel munch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MunchDetailScreen(munch: munch),
      ),
    );
  }
}
