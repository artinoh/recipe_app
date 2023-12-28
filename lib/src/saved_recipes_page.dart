import 'package:flutter/material.dart';
import 'package:recipe_app/src/user_data.dart';
import 'account_page.dart';
import 'recipe_page.dart'; // Make sure this is correctly imported
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../utils/app_bar.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key});

  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  late Future<List<Recipe>> _savedRecipesFuture;

  void _goToAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountPage()),
    );
  }

  void _goToRecipePage(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
    );
    _loadSavedRecipes(); // Refresh the recipes list upon returning
  }

  void _loadSavedRecipes() {
    setState(() {
      _savedRecipesFuture = UserData().getSavedRecipes();
    });
  }


  @override
  Widget build(BuildContext context) {
    _loadSavedRecipes();
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showAccountButton: true,
        showLogoutButton: true,
        showSavedRecipesButton: false,
        showBackButton: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(1), // Add padding for aesthetics
            child: Text(
              'Saved Recipes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: UserData().getSavedRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Recipe recipe = snapshot.data![index];
                      return ListTile(
                        title: Text(recipe.name),
                        subtitle: Text(recipe.description),
                        onTap: () => _goToRecipePage(recipe),
                        trailing: SizedBox(
                          width: 50, // Set a specific width
                          height: 50, // Set a specific height
                          child: Image.network(
                            recipe.imageUrls?.first ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No saved recipes found.');
                }
              },
            ),
          ),
        ],
    ),
    );
  }

}
