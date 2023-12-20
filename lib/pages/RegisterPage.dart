import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/TextForm.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    if (email == null ||
        fname == null ||
        lname == null ||
        password == null ||
        cpassword == null ||
        password?.compareTo(cpassword!) != 0) {
      return false;
    }
    return true;
  }

  bool checking = false;

  @override
  Widget build(BuildContext context) {
    bool checking = false;
    //late UserCredential userCredential;
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
                    child: TextForm(
                      controller: fnameController,
                      obscure: false,
                      textInputType: TextInputType.text,
                      text: 'First Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextForm(
                      controller: lnameController,
                      obscure: false,
                      textInputType: TextInputType.text,
                      text: 'Last Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextForm(
                      controller: emailController,
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                      text: 'Email',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextForm(
                      controller: passwordController,
                      obscure: true,
                      textInputType: TextInputType.visiblePassword,
                      text: 'Password',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextForm(
                      controller: cpasswordController,
                      obscure: true,
                      textInputType: TextInputType.visiblePassword,
                      text: 'Confirm Password',
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
                            final User user =
                                User('$fname $lname', email!, password!, 'Busy');
                            await createUser(user);
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF113953),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 10,
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.all(16.0), // Adjust the padding as needed
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
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already Hava An Account',
            ),
            InkWell(
              onTap: () {
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
