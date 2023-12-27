import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/app_bar.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  // Define the controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<TextEditingController> _ingredientsControllers = [TextEditingController()];
  List<TextEditingController> _stepsControllers = [TextEditingController()];

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nameController.dispose();
    _cookingTimeController.dispose();
    _descriptionController.dispose();
    for (var controller in _ingredientsControllers) {
      controller.dispose();
    }
    for (var controller in _stepsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addNewField(List<TextEditingController> text_controller) {
    setState(() {
      text_controller.add(TextEditingController());
    });
  }

  void _removeField(List<TextEditingController> text_controller, int index) {
      setState(() {
        text_controller.removeAt(index);
      });
    }

  void _submitError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    String errorMessage = "Error: $message";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }


  void _submitRecipe() async {
    setState(() {

      if (_nameController.text.isEmpty) {
        _submitError('Please enter a name');
        return;
      }
      if (_cookingTimeController.text.isEmpty) {
        _submitError('Please enter cooking time');
        return;
      }
      if (_ingredientsControllers.isEmpty) {
        _submitError('Please enter ingredients');
        return;
      }
      if (_stepsControllers.isEmpty) {
        _submitError('Please enter steps');
        return;
      }

      CollectionReference recipes = FirebaseFirestore.instance.collection('recipes');
      recipes.add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'cookingTime': int.parse(_cookingTimeController.text),
        'ingredients': _ingredientsControllers.map((controller) => controller.text).toList(),
        'steps': _stepsControllers.map((controller) => controller.text).toList(),
      });

      // Clear the text fields
      _nameController.clear();
      _cookingTimeController.clear();
      _descriptionController.clear();
      _ingredientsControllers.clear();
      _stepsControllers.clear();

    });
  }


  Widget _buildField(List<TextEditingController> text_controller, int index, String label) {
    return ListTile(
      title: TextFormField(
        controller: text_controller[index],
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.all(8.0),
          border: OutlineInputBorder( ),
          isDense: true,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () => _removeField(text_controller, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Recipe',
        showAccountButton: true,
        showSavedRecipesButton: true,
        showLogoutButton: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                TextFormField(
                  controller: _cookingTimeController,
                  decoration: const InputDecoration(labelText: 'Cooking Time (minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cooking time';
                    }
                    return null;
                  },
                ),
                 Text('Ingredients:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.left
                  ),
                ...List.generate(_ingredientsControllers.length, (index) => _buildField( _ingredientsControllers, index, "Ingredients")),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _addNewField(_ingredientsControllers),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                    ),
                    child: Text('Add New Ingredient'),
                  ),
                ),
                const Text('Steps:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, )
                ),
                ...List.generate(_stepsControllers.length, (index) => _buildField( _stepsControllers, index, "Step")),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _addNewField(_stepsControllers),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                    ),
                    child: Text('Add New Step'),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () => _submitRecipe(),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                    onPrimary: Colors.white,
                    alignment: Alignment.center,
                  ),
                  child: Text('Submit Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
