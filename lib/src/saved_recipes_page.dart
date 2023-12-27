import 'package:flutter/material.dart';
import 'package:recipe_app/src/user_data.dart';
import 'account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key});

  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {

  void _goToAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: const Text("Saved Recipes"),
        actions: [
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
      body: Center(
        child: Text('Saved Recipes'),
      ),
    );
  }


}