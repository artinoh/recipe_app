
import 'package:cloud_firestore/cloud_firestore.dart';

import 'recipe_page.dart';


class UserData {
  String? name;
  String? email;
  List<String>? allergies;
  List<String>? savedRecipes;

  // Private constructor
  UserData._privateConstructor();

  // Static instance of the class
  static final UserData _instance = UserData._privateConstructor();

  // Factory constructor to return the same instance
  factory UserData() {
    return _instance;
  }

  void updateSavedRecipes(String recipeName, bool isSaved) {
    if (isSaved) {
      savedRecipes ??= [];
      savedRecipes!.add(recipeName);
    } else {
      savedRecipes?.remove(recipeName);
    }
    FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        documentSnapshot.reference.update({'savedRecipes': savedRecipes});
      }
    });
  }

  Future<List<Recipe>> getSavedRecipes() async {
    List<Recipe> savedRecipes = [];

    var querySnapshot = await FirebaseFirestore.instance.collection('recipes').get();

    for (var doc in querySnapshot.docs) {
      if (this.savedRecipes?.contains(doc['name']) ?? false) {
        List<String> ingredients = List<String>.from(doc["ingredients"]);
        List<String> steps = List<String>.from(doc["steps"]);

        savedRecipes.add(Recipe(doc["name"], doc["description"], doc["cookingTime"], ingredients, steps));
      }
    }

    return savedRecipes;
  }


  reset() {
    name = null;
    email = null;
    allergies = null;
    savedRecipes = null;
  }

}
