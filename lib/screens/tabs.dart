import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_flutter/providers/favorite_meals.dart';
import 'package:meals_flutter/providers/filter_meals.dart';
import 'package:meals_flutter/screens/categories.dart';
import 'package:meals_flutter/screens/filters.dart';
import 'package:meals_flutter/screens/meals.dart';
import 'package:meals_flutter/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _selectScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activeWidget = CategoriesScreen(availableMeals: availableMeals);
    String activeScreenAppbar = 'Categories';

    if (_selectedPageIndex == 1) {
      activeWidget = MealsScreen(meals: ref.watch(favoriteMealsProvider));
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
