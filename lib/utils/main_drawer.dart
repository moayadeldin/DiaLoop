import 'package:flutter/material.dart';
import 'config.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Config.primaryColor,
              Config.primaryColor.withOpacity(0.8),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Row(
            children: [
              Icon(
                Icons.fastfood,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 18),
              Text('Cooking Up!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Config.primaryColor))
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.restaurant, size: 26, color: Config.primaryColor),
          title: Text(
            'Meals',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Config.primaryColor, fontSize: 24),
          ),
          onTap: () {
            onSelectScreen('meals');
          },
        ),
        ListTile(
          leading: Icon(Icons.settings, size: 26, color: Config.primaryColor),
          title: Text(
            'Filters',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Config.primaryColor, fontSize: 24),
          ),
          onTap: () {
            onSelectScreen('filters');
          },
        ),
      ],
    ));
  }
}
