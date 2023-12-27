import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_recipe.dart';
import 'account_page.dart';
import 'login_page.dart';
import 'recipe_page.dart';
import 'saved_recipes_page.dart';
import 'user_data.dart';

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
      print("pre-filter");
      for (var recipe in _searchResults) {
        recipe.printRecipe();
      }
      for (var term in _searchTerms) {
        _searchResults.retainWhere((recipe) => recipe.ingredients.contains(term.toLowerCase()));
      }

      for (var allergy in UserData().allergies ?? []) {
        _searchResults.removeWhere((recipe) => recipe.ingredients.contains(allergy));
      }

      print("post-filter");
      for (var recipe in _searchResults) {
        recipe.printRecipe();
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

          _searchResults.add(Recipe(doc["name"], doc["description"], doc["cookingTime"], ingredients, steps));
          // Debug print, if needed
          // print("added recipe: ${doc["name"]}");
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

  bool _updateSearchTerms() {
    if (_searchController.text.isEmpty) {
      return false;
    }

    setState(() {
      _updateSearchResults(_searchController.text);
      _searchController.clear();
    });

    return true;
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

  void _clearSearch() {
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
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: const Text("Search"),
        actions: [
          IconButton(
            onPressed: () => _goToSavedRecipes(),
            icon: const Icon(Icons.bookmark),
          ),
          IconButton(
            onPressed: () => _goToAccountPage(),
            icon: const Icon(Icons.account_circle),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage(title: 'Crave: Login')),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // Use the controller here
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for a Recipe',
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
              label: Text(term),
              onDeleted: () => _removeSearchTerm(term),
            )).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:() => _updateSearchTerms(),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed:() => _clearSearch(),
                child: const Text(
                  'Clear',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index].name),
                  subtitle: Text(_searchResults[index].description),
                  onTap: () => displayRecipe(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToAddRecipe(),
        tooltip: 'Add Recipe',
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }
}

