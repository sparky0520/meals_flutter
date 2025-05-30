import 'package:flutter/material.dart';
import 'package:meals_flutter/data/dummy_data.dart';
import 'package:meals_flutter/models/meal.dart';
import 'package:meals_flutter/screens/categories.dart';
import 'package:meals_flutter/screens/filters.dart';
import 'package:meals_flutter/screens/meals.dart';
import 'package:meals_flutter/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleFavorite(Meal meal) {
    final bool isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage("Removed from Favorites");
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage("Added to Favorites");
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _selectScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      final result = await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(activeFilters: _selectedFilters),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals =
        dummyMeals.where((meal) {
          if ((_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) ||
              (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) ||
              (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) ||
              (_selectedFilters[Filter.vegan]! && !meal.isVegan)) {
            return false;
          }
          return true;
        }).toList();

    Widget activeWidget = CategoriesScreen(
      onToggleFavorite: _toggleFavorite,
      availableMeals: availableMeals,
    );
    String activeScreenAppbar = 'Categories';

    if (_selectedPageIndex == 1) {
      activeWidget = MealsScreen(
        onToggleFavorite: _toggleFavorite,
        meals: _favoriteMeals,
      );
      activeScreenAppbar = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activeScreenAppbar)),
      drawer: MainDrawer(onSelectScreen: _selectScreen),
      body: activeWidget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
