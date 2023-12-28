import 'package:flutter/material.dart';
import '../src/account_page.dart';
import '../src/saved_recipes_page.dart';
import '../src/login_page.dart';
import '../src/add_recipe.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showAccountButton;
  final bool showSavedRecipesButton;
  final bool showLogoutButton;
  final String leadingImage;
  final bool useLogo;
  final bool showAddRecipeButton;


  CustomAppBar({super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.showAccountButton = false,
    this.showSavedRecipesButton = false,
    this.showLogoutButton = false,
    this.leadingImage = "images/crave_icon.png",
    this.useLogo = true,
    this.showAddRecipeButton = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> allActions = actions ?? [];

    if (showBackButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ));
    }

    if (showAccountButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.account_circle),
        color: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountPage()),
        ),
      ));
    }

    if (showSavedRecipesButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.bookmark),
        color: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedRecipesPage()),
        ),
      ));
    }

    if (showAddRecipeButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.add),
        color: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddRecipePage()),
        ),
      ));
    }

    if (showLogoutButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.logout),
        color: Colors.white,
        onPressed: () {
          // Add your logout logic here
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login',)),
          );
        },
      ));
    }

    Widget? leadingWidget;
    if (useLogo) {
      leadingWidget = Padding(
        padding: const EdgeInsets.all(0), // Adjust padding as needed
        child: Image.asset(
          leadingImage,
          width: 500,
          height: 400,
        ),
      );
    }



    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: useLogo ? leadingWidget : null,
      leadingWidth: useLogo ? 100 : null,
      title: Text(title, style: TextStyle(color: Colors.white)),
      actions: allActions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
}
