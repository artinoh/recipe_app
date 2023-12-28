import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'user_data.dart';
import '../utils/app_bar.dart';
import '../utils/custom_button.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController(text: UserData().name);
  final TextEditingController _allergiesController = TextEditingController();
  // Add more controllers if you have more fields

  @override
  void dispose() {
    _nameController.dispose();
    // Dispose other controllers if you have more
    super.dispose();
  }

  Future<void> _updateUserData() async {
    try {
      await UserData().updateName(_nameController.text);
      // Update other fields if you have more
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data updated'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = UserData().name ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showAccountButton: false,
        showLogoutButton: true,
        showSavedRecipesButton: true,
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  auth.currentUser!.email!,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(height: 24.0),
              CustomButton(
                text: 'Save',
                onPressed: _updateUserData
              ),
              Divider(),
              const ListTile(
                title: Text('Account Preferences'),
                subtitle: Text('Your account preferences will be listed here'),
                // Add more preference display widgets
              ),
              // Add more preferences
            ],
          ),
        ),
      ),
    );
  }
}
