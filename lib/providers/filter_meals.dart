import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_flutter/providers/meals.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FilterMealsNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterMealsNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegetarian: false,
        Filter.vegan: false,
      });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FilterMealsNotifier, Map<Filter, bool>>(
      (ref) => FilterMealsNotifier(),
    );

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if ((activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) ||
        (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) ||
        (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) ||
        (activeFilters[Filter.vegan]! && !meal.isVegan)) {
      return false;
    }
    return true;
  }).toList();
});
