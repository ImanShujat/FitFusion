// models.dart
class FoodItem {
  final String name;
  final String category;
  final int calories;

  FoodItem({required this.name, required this.category, required this.calories});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      category: json['category'],
      calories: json['calories'],
    );
  }
}

class DietPlan {
  final List<FoodItem> breakfast;
  final List<FoodItem> lunch;
  final List<FoodItem> dinner;

  DietPlan({required this.breakfast, required this.lunch, required this.dinner});

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      breakfast: (json['Breakfast'] as List).map((item) => FoodItem.fromJson(item)).toList(),
      lunch: (json['Lunch'] as List).map((item) => FoodItem.fromJson(item)).toList(),
      dinner: (json['Dinner'] as List).map((item) => FoodItem.fromJson(item)).toList(),
    );
  }
}
