import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'user_data.dart';
import '../utils/app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    _nameController.text = UserData().name ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
        showAccountButton: false,
        showLogoutButton: true,
        showSavedRecipesButton: true,
        showBackButton: true,
        toggleSavedButton: false,
        onToggleSaved: () {},
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              ElevatedButton(
                onPressed: () {
                  print('Updating details');
                },
                child: const Text('Update Details'),
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
