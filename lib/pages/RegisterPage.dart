import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();

  String? email;
  String? fname;
  String? lname;
  String? password;
  String? cpassword;

  bool validate() {
    if (_formKey.currentState?.validate() != true ||
        password?.compareTo(cpassword!) != 0) {
      return false;
    }
    return true;
  }

  bool checking = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logo',
          style: TextStyle(
              color: Color(0xFF113953),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: checking,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Register Here',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fnameController,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First Name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: lnameController,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last Name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        validator: validateEmail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        validator: validatePassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: cpasswordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              email = emailController.text;
                              fname = fnameController.text;
                              lname = lnameController.text;
                              password = passwordController.text;
                              cpassword = passwordController.text;
                            });
                            if (validate()) {
                              setState(() {
                                checking=true;
                              });
                              final User user = User(
                                '$fname $lname',
                                email!,
                                password!,
                                'Busy',
                              );
                              final response = await createUser(user);
                              setState(() {
                                checking=false;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  if (response == 201) {
                                    return AlertDialog(
                                      title: const Text('Register Success'),
                                      content:
                                          const Text('Login And Enjoy Your Time'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  } else if (response == 400) {
                                    return AlertDialog(
                                      title: const Text('Registration Failed'),
                                      content: const Text(
                                          'File field is missing in the request.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  } else if (response == 409) {
                                    return AlertDialog(
                                      title: const Text('Registration Failed'),
                                      content:
                                          const Text('Duplicate entry for email.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  } else if (response == 500) {
                                    return AlertDialog(
                                      title: const Text('Registration Failed'),
                                      content: const Text('Internal server error.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Generic case for any other status code
                                    return AlertDialog(
                                      title: const Text('Registration Failed'),
                                      content:
                                          Text('Unexpected Error: $response'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              );
                            } else {
                              print('Validation failed');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF113953),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 10,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(
                                16.0), // Adjust the padding as needed
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already Have an Account',
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("LoginPage");
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Color(0xFF113953),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
