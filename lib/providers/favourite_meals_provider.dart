import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/filters_provider.dart';

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  void toggleMealFavoriteStatus(BuildContext context, Meal meal) {
    final mealIsFavorite = state.contains(meal);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (mealIsFavorite) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from favorites!'),
          duration: const Duration(seconds: 2),
        ),
      );
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to favorites!'),
          duration: const Duration(seconds: 2),
        ),
      );
      state = [...state, meal];
    }
  }
}

final filteredMealsProvider = Provider((ref) {
  final meals = dummyMeals;
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) return false;
    if (activeFilters[Filter.vegan]! && !meal.isVegan) return false;
    return true;
  }).toList();
});
