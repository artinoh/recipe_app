import 'package:flutter/material.dart';

class Recipe
{
  String name;
  String description;
  int cookingTime;
  List<String> ingredients;
  List<String> steps;

  Recipe(this.name, this.description, this.cookingTime, this.ingredients, this.steps);

  void printRecipe() {
    print('Name: $name');
    print('Description: $description');
    print('Cooking time: $cookingTime');
    print('Ingredients:');
    for (var ingredient in ingredients) {
      print(ingredient);
    }
    print('Steps:');
    for (var step in steps) {
      print(step);
    }
  }
}

class RecipePage extends StatefulWidget {
  RecipePage({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool _isSaved = false;

  void _toggleSaved() {
    // save recipe to firestore
    //print('saving recipe');
    setState(() {
      _isSaved = !_isSaved;
      if (_isSaved) {
        print('saved recipe');
      } else {
        print('unsaved recipe');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleSaved,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text("Description:\n${widget.recipe.description}",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              'Cooking time: ${widget.recipe.cookingTime} minutes',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          for (var ingredient in widget.recipe.ingredients)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                ingredient,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              'Steps:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          for (var step in widget.recipe.steps)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                step,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
        ],
      ),
    );
  }
}