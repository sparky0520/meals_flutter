import 'package:flutter/material.dart';
import 'package:meals_flutter/models/meal.dart';
import 'package:meals_flutter/widgets/meals_list_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  final String? title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (BuildContext context, int index) {
        return MealsListItem(meal: meals[index]);
      },
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "No meals to show",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Column(
              children: [
                Text(
                  "Try choosing a different category",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "or",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "Add new favorites",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(appBar: AppBar(title: Text(title!)), body: content);
  }
}
