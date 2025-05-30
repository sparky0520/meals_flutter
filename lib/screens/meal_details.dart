import 'package:flutter/material.dart';

import 'package:meals_flutter/models/meal.dart';
import 'package:meals_flutter/widgets/meal_item_trait.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    required this.title,
    required this.onToggleFavorite,
  });

  final Meal meal;
  final String title;
  final void Function(Meal meal) onToggleFavorite;
  @override
  Widget build(BuildContext context) {
    final flags = [
      meal.isGlutenFree ? "Gluten Free" : "",
      meal.isLactoseFree ? "Lactose Free" : "",
      meal.isVegan ? "Vegan" : "",
      meal.isVegetarian ? "Vegetarian" : "",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              onToggleFavorite(meal);
            },
            icon: Icon(Icons.star_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          children: [
            Image.network(meal.imageUrl),
            Text(
              meal.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                MealItemTrait(
                  icon: Icon(Icons.schedule),
                  text: '${meal.duration} min',
                ),

                MealItemTrait(
                  icon: Icon(Icons.attach_money),
                  text:
                      meal.affordability.name[0].toUpperCase() +
                      meal.affordability.name.substring(1),
                ),

                MealItemTrait(
                  icon: Icon(Icons.work),
                  text:
                      meal.complexity.name[0].toUpperCase() +
                      meal.complexity.name.substring(1),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                for (final flag in flags)
                  Text(
                    flag.isNotEmpty ? '● $flag' : '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children:
                  meal.ingredients
                      .map(
                        (ingredient) => Text(
                          ingredient,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                      .toList(),
            ),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children:
                  meal.steps
                      .asMap()
                      .entries
                      .map(
                        (entry) => Text(
                          '${entry.key + 1}. ${entry.value}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
