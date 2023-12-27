import 'package:flutter/material.dart';
import '../src/account_page.dart'; // Import your AccountPage
import '../src/saved_recipes_page.dart'; // Import your SavedRecipesPage
import '../src/login_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showAccountButton;
  final bool showSavedRecipesButton;
  final bool showLogoutButton;
  final bool toggleSavedButton;
  final VoidCallback? onToggleSaved;
  final String leadingImage;

  CustomAppBar({
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.showAccountButton = false,
    this.showSavedRecipesButton = false,
    this.showLogoutButton = false,
    this.toggleSavedButton = false,
    this.onToggleSaved,
    this.leadingImage = "images/crave_logo.png"
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> allActions = actions ?? [];

    if (showBackButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ));
    }

    if (showAccountButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountPage()),
        ),
      ));
    }

    if (showSavedRecipesButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.bookmark),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedRecipesPage()),
        ),
      ));
    }

    if (toggleSavedButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.bookmark_border),
        onPressed: () {
          onToggleSaved?.call();
        },
      ));
    }

    if (showLogoutButton) {
      allActions.add(IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          // Add your logout logic here
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login',)),
          );
        },
      ));
    }

    Widget leadingWidget = Padding(
      padding: EdgeInsets.all(2.0), // Add padding if needed
      child: Image.asset(
        leadingImage,
        width: 500, // Adjust the width as needed
        height: 50, // Adjust the height as needed
      ),
    );

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: leadingWidget,
      title: Text(title),
      actions: allActions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
}
