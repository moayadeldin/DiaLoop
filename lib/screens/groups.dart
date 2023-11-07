import 'package:flutter/material.dart';
import 'package:phase_1_app/data/data.dart';
import 'package:phase_1_app/screens/meals.dart';
import 'package:phase_1_app/utils/category_grid_part.dart';
import 'package:phase_1_app/components/category.dart';
import 'package:phase_1_app/utils/meal.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage(
      {super.key,
      required this.onToggleFavorite,
      required this.availableMeals});

  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MealsScreen(
        title: category.title,
        meals: filteredMeals,
        onToggleFavorite: onToggleFavorite,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          for (final category in availableCategories)
            CategoryGridPart(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                })
        ]);
  }
}
