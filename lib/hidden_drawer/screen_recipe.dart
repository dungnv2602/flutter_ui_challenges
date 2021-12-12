import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

import 'model.dart';

const _gray = Color(0xFFAAAAAA);

final restaurantScreens = [
  ScreenRecipe(
    title: 'THE PALEO PADDOCK',
    backgroundPath: 'assets/images/paddock/wood_bk.jpg',
    body: ListView(
      children: restaurantMeals
          .map((e) => RestaurantCard(model: e))
          .toList(growable: false),
    ),
  ),
  ScreenRecipe(
    title: 'THE DARK GRUNGE',
    backgroundPath: 'assets/images/paddock/dark_grunge_bk.jpg',
    body: ListView(
      children: restaurantMeals
          .map((e) => RestaurantCard(model: e))
          .toList(growable: false),
    ),
  ),
  ScreenRecipe(
    title: 'RECIPES',
    backgroundPath: 'assets/images/paddock/other_screen_bk.jpg',
    body: ListView(
      children: restaurantMeals
          .map((e) => RestaurantCard(model: e))
          .toList(growable: false),
    ),
  ),
  const ScreenRecipe(
    title: 'SETTINGS',
    body: Center(child: Text('SETTINGS')),
  ),
];

class ScreenRecipe {
  const ScreenRecipe({
    @required this.body,
    @required this.title,
    this.backgroundPath,
  });
  final Widget body;
  final String title;
  final String backgroundPath;
}

class ScreenRecipeBuilder extends StatelessWidget {
  const ScreenRecipeBuilder({
    Key key,
    @required this.recipe,
    this.onMenuPressed,
  }) : super(key: key);

  final ScreenRecipe recipe;
  final VoidCallback onMenuPressed;

  static const _defaultBackground = 'assets/images/paddock/wood_bk.jpg';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(recipe.backgroundPath ?? _defaultBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            recipe.title,
            style: context.headline5.textColor(Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuPressed,
          ),
        ),
        body: recipe.body,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScreenRecipe>('recipe', recipe));
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    Key key,
    @required this.model,
  }) : super(key: key);

  final RestaurantMeal model;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      elevation: 10,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              model.imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: model.iconColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    model.icon,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: context.headline6,
                    ),
                    Text(
                      model.subtitle,
                      style: context.bodyText1.letterSpace(1).textColor(_gray),
                    ),
                  ],
                ),
              ),
              Container(
                width: 2,
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white,
                      _gray,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                    Text('${model.likes}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantMeal>('model', model));
  }
}
