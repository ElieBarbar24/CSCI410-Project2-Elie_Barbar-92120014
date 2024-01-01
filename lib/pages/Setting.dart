import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/customAlertDialog.dart';
import 'package:connect/widgets/Navigator.dart';
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  String name = '';

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await updateProfile(currentUser.id!, File(image.path));
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length <= 8) {
      return 'Password must be longer than 8 characters';
    }

    final specialCharRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
    if (!specialCharRegex.hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }

    final uppercaseRegex = RegExp(r'[A-Z]');
    final lowercaseRegex = RegExp(r'[a-z]');
    if (!uppercaseRegex.hasMatch(value) || !lowercaseRegex.hasMatch(value)) {
      return 'Password must have at least one uppercase and one lowercase character';
    }

    // Check for consecutive characters or series like 1234 or abcd
    for (int i = 0; i < value.length - 3; i++) {
      if (value.codeUnitAt(i) + 1 == value.codeUnitAt(i + 1) &&
          value.codeUnitAt(i) + 2 == value.codeUnitAt(i + 2) &&
          value.codeUnitAt(i) + 3 == value.codeUnitAt(i + 3)) {
        return 'Avoid consecutive characters or series in the password';
      }
    }

    return null;
  }

  String? validateName(String? value){
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    return null;

  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Check if the email has the format @gmail.com
    if (!value.endsWith('@gmail.com')) {
      return 'Enter a valid Gmail address';
    }

    return null;
  }

  bool _validateAndSave(String field, String value, String? Function(String?)? validator) {
    if (validator != null) {
      final error = validator(value);
      if (error != null) {
        _showErrorDialog(error);
        return false;
      }
    }
    return true;
  }

  Future<void> _updateProfileField(String field, String value, String? Function(String?)? validator) async {
    if (!_validateAndSave(field, value, validator)) {
      return;
    }

    int? response;
    switch (field) {
      case 'name':
        setState(() {
          name = value;
        });
        response = await updateName(value);
        break;
      case 'email':
        setState(() {
          email = value;
        });
        response = await updateEmail(value);
        break;
      case 'password':
        setState(() {
          password = value;
        });
        // Handle password update logic
        break;
    }

    if (response == 200) {
      _showSuccessDialog('Update Successful');
    } else if (response == 404) {
      _showErrorDialog('Email Already Being Used');
    } else {
      _showErrorDialog('Error updating $field. Please try again.');
    }

    // Clear the text field after updating
    switch (field) {
      case 'name':
        nameController.clear();
        break;
      case 'email':
        emailController.clear();
        break;
      case 'password':
        passwordController.clear();
        break;
    }
  }

  void _showSuccessDialog(String description) {
    showDialog(
      context: context,
      builder: (builder) {
        return CustomAlertDialog(
          title: 'Profile Settings',
          description: description,
        );
      },
    );
  }

  void _showErrorDialog(String description) {
    showDialog(
      context: context,
      builder: (builder) {
        return CustomAlertDialog(
          title: 'Profile Settings',
          description: description,
        );
      },
    );
  }

  Widget _buildProfileField(String title, String subtitle, IconData iconData,
      TextEditingController controller, String field, String? Function(String?) validator) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ExpansionTile(
        title: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          leading: Icon(iconData),
        ),
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter ${title.toLowerCase()}",
                      border: InputBorder.none,
                      errorText: validator(controller.text),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () => _updateProfileField(field, controller.text, validator),
                  icon: const Icon(
                    Icons.done,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigatorDrawer(
        email: currentUser.email!,
        name: currentUser.name,
      ),
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: Image.network(
                  'https://eliebarbar.000webhostapp.com/profileImages/${currentUser.photo}',
                  height: 250,
                  width: 250,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              _buildProfileField(
                'Name',
                currentUser.name,
                Icons.person,
                nameController,
                'name',
                validateName,
              ),
              const SizedBox(height: 10),
              _buildProfileField(
                'Email',
                currentUser.email!,
                Icons.mail,
                emailController,
                'email',
                validateEmail,
              ),
              const SizedBox(height: 10),
              _buildProfileField(
                'Password',
                currentUser.password!,
                Icons.password,
                passwordController,
                'password',
                validatePassword,
              ),
              // Add other profile fields as needed
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
