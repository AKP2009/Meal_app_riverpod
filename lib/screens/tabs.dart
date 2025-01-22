import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favourite_meals_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/filters_provider.dart';

final selectedTabProvider = StateProvider((ref) => 0);

class TabsScreen extends ConsumerWidget {
  const TabsScreen({super.key});

  void _setScreen(BuildContext context, String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageIndex = ref.watch(selectedTabProvider);
    final availableMeals = ref.watch(filteredMealsProvider);
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    Widget activePage = CategoriesScreen(
      onToggleFavorite: (meal) => ref
          .read(favoriteMealsProvider.notifier)
          .toggleMealFavoriteStatus(context, meal),
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeals,
        onToggleFavourite: (meal) => ref
            .read(favoriteMealsProvider.notifier)
            .toggleMealFavoriteStatus(context, meal),
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: (identifier) => _setScreen(context, identifier),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
