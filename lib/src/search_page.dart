import 'package:flutter/material.dart';
import 'add_recipe.dart';


class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  String searchTerm = '';

  void _printSearchByRecipe() {
    setState(() {
      print('Searching by Recipe: $searchTerm');
    });
  }

  void _printSearchByIngredient() {
    setState(() {
      print('Searching by Ingredient: $searchTerm');
    });
  }

  void _printSearchByKeyWord() {
    setState(() {
      print('Searching by Keyword: $searchTerm');
    });
  }

  void _goToAddRecipe() {
    setState(() {
      print('Going to Add Recipe Page');
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRecipePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for a Recipe',
              ),
              onChanged: (text) {
                searchTerm = text;
              },
            ),

            // Updated Row widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: ElevatedButton(
                    onPressed: _printSearchByRecipe,
                    child: Text(
                      'Search by Name',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: _printSearchByIngredient,
                    child: Text(
                      'Search by Ingredient',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: _printSearchByKeyWord,
                    child: Text(
                      'Search by Keyword',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddRecipe,
        tooltip: 'Add Recipe',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

