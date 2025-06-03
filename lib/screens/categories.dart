import 'package:flutter/material.dart';
import 'package:meals_flutter/data/dummy_data.dart';
import 'package:meals_flutter/models/category.dart';
import 'package:meals_flutter/screens/meals.dart';
import 'package:meals_flutter/widgets/categories_grid_item.dart';
import 'package:meals_flutter/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    return widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
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
      ),
      builder:
          (ctx, child) => SlideTransition(
            position: Tween(begin: Offset(0, 3), end: Offset(0, 0)).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          ),
    );
  }
}
