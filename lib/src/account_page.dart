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

  Future<void> _removeAllergy(String allergy) async {
    try {
      await UserData().removeAllergy(allergy);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Allergy removed'),
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
    _allergiesController.clear();
  }

  Future<void> _addAllergy(String allergy) async {
    try {
      await UserData().addAllergy(allergy);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Allergy added'),
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
    _allergiesController.clear();
  }

  Future<void> _updateUserData() async {
    try {
      await UserData().updateName(_nameController.text);
      // Update other fields if you have more
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
    List<String> allergies = UserData().allergies ?? [];
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
                  'Account Details',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  auth.currentUser!.email!,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _updateUserData();
                      });
                    },
                  ),
                ),
              ),
              Divider(),
              Text(
                'Allergies',
                style: Theme.of(context).textTheme.headline6,
              ),
              for (var allergy in allergies)
                ListTile(
                  title: Text(allergy),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _removeAllergy(allergy);
                      });
                    },
                  ),
                ),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(
                  labelText: 'Add an allergy',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _addAllergy(_allergiesController.text);
                      });
                    },
                  ),
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _addAllergy(value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      );
  }
}
