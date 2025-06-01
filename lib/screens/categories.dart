import 'package:flutter/material.dart';
import 'package:meals_flutter/data/dummy_data.dart';
import 'package:meals_flutter/models/category.dart';
import 'package:meals_flutter/screens/meals.dart';
import 'package:meals_flutter/widgets/categories_grid_item.dart';
import 'package:meals_flutter/models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  // Navigate to meals screen
  void _selectCategory(BuildContext context, String title, List<Meal> meals) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(title: title, meals: meals),
      ),
    );
  }

  // Extracting list of meals
  List<Meal> _getMealsList(Category category) {
    return availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoriesGridItem(
            category: category,
            onSelectCategory:
                () => _selectCategory(
                  context,
                  category.name,
                  _getMealsList(category),
                ),
          ),
      ],
    );
  }
}
