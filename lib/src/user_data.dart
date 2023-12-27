


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

  reset() {
    name = null;
    email = null;
    allergies = null;
    savedRecipes = null;
  }

}
