import 'package:flutter/material.dart';
import 'user_data.dart';
import '../utils/app_bar.dart';

class Recipe
{
  String name;
  String description;
  int cookingTime;
  List<String> ingredients;
  List<String> steps;
  List<String>? imageUrls;

  Recipe(
      this.name,
      this.description,
      this.cookingTime,
      this.ingredients,
      this.steps,
      this.imageUrls
      );

  List<String> getIngredients() {
    return ingredients ?? [];
  }
  List<String> getSteps() {
    return steps ?? [];
  }
  List<String> getImageUrls() {
    return imageUrls ?? [];
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

  void updateFireStore() async {
    setState(() {
      UserData().updateSavedRecipes(widget.recipe.name, _isSaved);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  bool _checkSavedStatus() {
    bool isSaved = UserData().savedRecipes?.contains(widget.recipe.name) ?? false;
    if (mounted) {
      setState(() {
        _isSaved = isSaved;
      });
    }
    return isSaved;
  }

  void _toggleSaved() {
    setState(() {
      _isSaved = !_isSaved;
      _toast(_isSaved ? 'Added to saved recipes' : 'Removed from saved recipes');
      updateFireStore();
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _isSaved ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showAccountButton: true,
        showLogoutButton: true,
        showSavedRecipesButton: false,
        showBackButton: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Recipe: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.recipe.name), // Regular part
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '\n${widget.recipe.description}'), // Regular part
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Cooking Time: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${widget.recipe.cookingTime.toString()} minutes'),
                ],
              ),
            ),
          ),
          if (widget.recipe.imageUrls != null && widget.recipe.imageUrls!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                widget.recipe.imageUrls!.first,
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
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                ingredient,
                style: const TextStyle(fontSize: 14.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                step,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                _checkSavedStatus() ? Icons.remove_circle : Icons.add_circle,
                color: Colors.pink,
                size: 40,
              ),
              tooltip: _checkSavedStatus() ? 'Remove from saved recipes' : 'Add to saved recipes',
              onPressed: _toggleSaved,
            ),
          ],
        ),
      )
    );
  }
}