import 'package:flutter/material.dart';
import 'package:meals/components/meal_item.dart';

import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';

class CategoriesMealsScreen extends StatelessWidget {
  const CategoriesMealsScreen({super.key, required this.meals});

  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    final categoryMeals = meals.where((meal) {
      return meal.categories.contains(category.id);
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(category.title),
        ),
        body: categoryMeals.isNotEmpty
            ? ListView.builder(
                itemCount: categoryMeals.length,
                itemBuilder: (ctx, index) => MealItem(
                  meal: categoryMeals[index],
                ),
              )
            : Center(
                child: Text(
                  'Nada aqui!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ));
  }
}
