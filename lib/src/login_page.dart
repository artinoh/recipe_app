import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/src/user_data.dart';
import 'search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showError('Please enter your email to reset password.');
      return;
    }

    try {
      await auth.sendPasswordResetEmail(email: _emailController.text.trim());
      _showError('Password reset email sent. Please check your email.', Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError('No user found for that email.');
      } else {
        _showError('Password reset failed: ${e.message}');
      }
    } catch (e) {
      _showError('Password reset failed: ${e.toString()}');
    }
  }


  void _setUserData(String email) async {
    try {
      UserData().email = email.toLowerCase();
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;

        if (documentSnapshot.exists) {
          var userData = documentSnapshot.data();

          UserData().name = userData['name'];

          // Check for null and then convert to List<String>
          UserData().allergies = userData['allergies'] != null
              ? List<String>.from(userData['allergies'])
              : <String>[];

          UserData().savedRecipes = userData['SavedRecipes'] != null
              ? List<String>.from(userData['SavedRecipes'])
              : <String>[];

        } else {
          _addUserToFirestore(email);
        }
      } else {
        _addUserToFirestore(email);
      }
    } catch (e) {
      _showError('Failed to get user data: ${e.toString()}');
    }
  }



  Future<void> _submitLogin() async {
    if (!_validateCredentials()) {
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _setUserData(_emailController.text.trim());
      // Navigate to the next screen if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage(title: 'Search')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showError('Wrong password provided.');
      } else {
        _showError('Login failed: ${e.message}');
      }
    } catch (e) {
      _showError('Login failed: ${e.toString()}');
    }
  }

  void _addUserToFirestore(String email) async {
    FirebaseFirestore.instance.collection('users').doc(email).set({
      'name': '',
      'email': email,
      'allergies': [],
      'savedRecipes': [],
    });
  }

  Future<void> _signUp() async {
    if (!_validateCredentials()) {
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _showError('User successfully registered.', Colors.green);
      _submitLogin();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showError('The account already exists for that email.');
      } else {
        _showError('Registration failed: ${e.message}');
      }
    } catch (e) {
      _showError('Registration failed: ${e.toString()}');
    }
  }

  void _showError(String message, [Color backgroundColor = Colors.red]) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  bool _validateCredentials() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please enter email and password.');
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Image.asset(
              'images/crave_logo.png', // Replace with your logo asset path
              width: 120,
              height: 120,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _submitLogin();
                    },
                  ),
                  const Divider(),
                  CustomButton(text: 'Login', onPressed: _submitLogin),
                  CustomButton(text: 'Sign Up', onPressed: _signUp),
                  CustomButton(text: 'Forgot Password', onPressed: _handleForgotPassword),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
