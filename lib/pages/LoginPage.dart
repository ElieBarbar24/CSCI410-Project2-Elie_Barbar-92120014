import 'package:connect/Querys/UserAction.dart';
import 'package:connect/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;
  bool checking = false;
  String error = '';

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!value.endsWith('@gmail.com')) {
      return 'Enter a valid Gmail address';
    }

    return null;
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

    for (int i = 0; i < value.length - 3; i++) {
      if (value.codeUnitAt(i) + 1 == value.codeUnitAt(i + 1) &&
          value.codeUnitAt(i) + 2 == value.codeUnitAt(i + 2) &&
          value.codeUnitAt(i) + 3 == value.codeUnitAt(i + 3)) {
        return 'Avoid consecutive characters or series in the password';
      }
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
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: checking,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Login to your account',
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
                      onChanged: (String value) {
                        setState(() {
                          if (error != '') {
                            error = '';
                          }
                        });
                      },
                    ),
                  ),
                  error != ''
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      : Center(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                              checking = true;
                            });

                            final r = await logIn(email!, password!);
                            if (r == 200) {
                              setState(() {
                                checking = false;
                              });
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (builder) => const HomePage(),
                                ),
                              );
                            } else if (r == 401) {
                              setState(() {
                                checking = false;
                                error = 'Wrong Password.';
                              });
                            } else if (r == 404) {
                              setState(() {
                                checking = false;
                                error = 'Email Not Found.';
                              });
                            }
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
                            'Sign In',
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
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Don\'t have an account?',
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("RegisterPage");
              },
              child: const Text(
                'Sign Up',
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
