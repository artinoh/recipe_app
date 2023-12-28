import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_recipe.dart';
import 'account_page.dart';
import 'login_page.dart';
import 'recipe_page.dart';
import 'saved_recipes_page.dart';
import 'user_data.dart';
import '../utils/app_bar.dart';
import '../utils/custom_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.title});

  final String title;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchTerms = [];
  List<Recipe> _searchResults = [];

  void _goToAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountPage()),
    );
  }

  void displayRecipe(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
    );
  }

  void _filterSearchResults() {
    setState(() {
      for (var term in _searchTerms) {
        _searchResults.retainWhere((recipe) => recipe.ingredients.contains(term.toLowerCase()));
      }

      for (var allergy in UserData().allergies ?? []) {
        _searchResults.removeWhere((recipe) => recipe.ingredients.contains(allergy));
      }
    });
  }

  void _updateSearchResults(String? text) {
    setState(() {
      if (text != null && !_searchTerms.contains(text)) {
        _searchTerms.add(text);
      }

      if (_searchResults.isEmpty || text == null) {
        _getRecipes();
      }

      _filterSearchResults();
    });
  }

  void _getRecipes() async {
    setState(() {
      _searchResults.clear();
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('recipes').get();
      setState(() {
        for (var doc in querySnapshot.docs) {
          List<String> ingredients = List<String>.from(doc["ingredients"]);
          List<String> steps = List<String>.from(doc["steps"]);
          List<String> imageUrls = List<String>.from(doc["imageUrls"]);

          _searchResults.add(Recipe(doc["name"], doc["description"], doc["cookingTime"], ingredients, steps, imageUrls));
        }
      });

      // Now that data is fetched, filter the search results
      _filterSearchResults();
    } catch (e) {
      _showError('Failed to get recipes: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    String errorMessage = "Error: $message";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _updateSearchTerms() async {
    if (_searchController.text.isEmpty) {
      return;
    }

    setState(() {
      _updateSearchResults(_searchController.text);
      _searchController.clear();
    });

  }

  void _removeSearchTerm(String term) {
    setState(() {
      _searchTerms.remove(term);

      if (_searchTerms.isEmpty) {
        _clearSearch();
        return;
      }
      _updateSearchResults(null);
    });
  }

  Future<void> _clearSearch() async {
    setState(() {
      _searchTerms.clear();
      _searchResults.clear();
      _searchController.clear();
    });
  }

  void _goToAddRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipePage()),
    );
  }

  void _goToSavedRecipes() {
    Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const SavedRecipesPage()),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showAccountButton: true,
        showSavedRecipesButton: true,
        showLogoutButton: true,
        showAddRecipeButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // Use the controller here
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for an Ingredient',
              ),
              onSubmitted: (value) {
                setState(() {
                  _updateSearchTerms();
                });
              },
            ),

          ),
          Wrap(
            spacing: 6.0,
            children: _searchTerms.map((term) => Chip(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.pink),
                borderRadius: BorderRadius.circular(0),
              ),
              label: Text(term, style: TextStyle(fontSize: 12)),
              onDeleted: () => _removeSearchTerm(term),
            )).toList(),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var imageUrls = _searchResults[index].getImageUrls();
                Widget trailingWidget = const SizedBox.shrink();
                if (imageUrls.isNotEmpty) {
                  trailingWidget = Image.network(
                    imageUrls.first,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  );
                }
                return ListTile(
                  title: Text(_searchResults[index].name),
                  subtitle: Text(_searchResults[index].description),
                  onTap: () => displayRecipe(_searchResults[index]),
                  trailing: trailingWidget,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              onPressed: () => _updateSearchTerms(),
              text: 'Search',
              buttonWidth: 150,
            ),
            CustomButton(
              onPressed: () => _clearSearch(),
              text: 'Clear',
              buttonWidth: 150,
            ),
          ],
        ),
      ),
    );
  }
}

