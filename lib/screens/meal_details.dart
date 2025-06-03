import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_flutter/models/meal.dart';
import 'package:meals_flutter/providers/favorite_meals.dart';
import 'package:meals_flutter/widgets/meal_item_trait.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.meal, required this.title});

  final Meal meal;
  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);

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
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleFavoriteMealStatus(meal);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded ? 'Meal added to favorites' : 'Meal removed',
                  ),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.6, end: 1).animate(animation),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            ),
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
