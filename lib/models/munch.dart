enum Complexity {
  Simple,
  Challenging,
  Hard,
}

enum Affordability {
  Affordable,
  Pricey,
  Luxurious,
}


class MunchiesModel {
  final String id;
  final String title;
  final String imagePath;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
  final String categoryId;
  final List<String> categories;

  const MunchiesModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
    required this.categoryId,
    required this.categories,

  });

  factory MunchiesModel.fromJson(Map<String, dynamic> json) {
    return MunchiesModel(
      id: json['id'],
      title: json['title'],
      imagePath: json['imagePath'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      duration: json['duration'] as int,
      complexity: _mapComplexity(json['complexity']),
      affordability: _mapAffordability(json['affordability']),
      isGlutenFree: json['isGlutenFree'] == 1,
      isLactoseFree: json['isLactoseFree'] == 1,
      isVegan: json['isVegan'] == 1,
      isVegetarian: json['isVegetarian'] == 1,
      categoryId: json['category_id'],
      categories: List<String>.from(json['categories']),
    );
  }

  static Complexity _mapComplexity(int value) {
    switch (value) {
      case 0:
        return Complexity.Simple;
      case 1:
        return Complexity.Challenging;
      case 2:
        return Complexity.Hard;
      default:
        return Complexity.Simple;
    }
  }

  static Affordability _mapAffordability(int value) {
    switch (value) {
      case 0:
        return Affordability.Affordable;
      case 1:
        return Affordability.Pricey;
      case 2:
        return Affordability.Luxurious;
      default:
        return Affordability.Affordable;
    }
  }
}
