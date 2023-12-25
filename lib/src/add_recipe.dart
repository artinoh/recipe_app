import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text("Add New Recipe"),
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
                  onPressed: () {
                    print('Submit Recipe');
                    print("name=" + _nameController.text);
                    print("description=" + _descriptionController.text);
                    print("cooking time=" + _cookingTimeController.text);
                    print("ingredients=" + _ingredientsControllers.map((e) => e.text).join(","));
                    print("steps=" + _stepsControllers.map((e) => e.text).join(","));
                  },
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
