import 'package:flutter/material.dart';
import 'package:meals_flutter/models/meal.dart';
import 'package:meals_flutter/screens/meal_details.dart';
import 'package:meals_flutter/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealsListItem extends StatelessWidget {
  const MealsListItem({super.key, required this.meal});

  final Meal meal;

  void _selectMeal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(title: meal.title, meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          _selectMeal(context);
        },
        splashColor: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            FadeInImage(
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black54,
                child: Column(
                  spacing: 12,
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
