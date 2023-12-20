
import 'package:connect/Models/User.dart';
import 'package:connect/Querys/UserAction.dart';
import 'package:connect/widgets/customAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _expanded = ValueNotifier<bool>(false);

  String email = '';
  String password = '';
  String name = '';

  void initState() {
    super.initState();
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavigationDrawer(
        email: currentUser.email,
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
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 40),
              ClipRRect(
                child: Image.network(
                  'https://eliebarbar.000webhostapp.com/profileImages/${currentUser.photo}',
                  height: 250,
                  width: 250,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF113953),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _selectImage,
                  child: const Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              NameitemProfile(
                  'Name', currentUser.name, Icons.person, nameController),
              const SizedBox(height: 10),
              EmailitemProfile('Email', currentUser.email, Icons.mail, emailController),
              const SizedBox(height: 10),
              PassworditemProfile(
                  'Password', currentUser.password, Icons.password, passwordController),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  NameitemProfile(String title, String subtitle, IconData iconData,
      TextEditingController chatTextController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ExpansionTile(
          onExpansionChanged: (bool expanding) => _expanded.value = expanding,
          title: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData),
            tileColor: Colors.white,
          ),
          initiallyExpanded: _expanded.value,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    child: TextFormField(
                      controller: chatTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
               Container(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                    IconButton(
                      onPressed: () async{
                        setState(() {
                          name = nameController.text;
                        });

                        if(name.compareTo('')==0){
                          return ;
                        }
                        else{
                          var response = await updateName(name!);
                          if(response==200){
                            showDialog(context: (context), builder: (builder){
                              return CustomAlertDialog(
                                  title: 'Name Settings',
                                  description: 'Name Updated Succesfully',);
                            });
                          }else{
                            showDialog(context: (context), builder: (builder){
                              return CustomAlertDialog(
                                  title: 'Name Settings',
                                  description: 'Error updating name.Please try again',);
                            });
                          }
                        }
                        setState(() {
                          nameController.clear();
                        });
                      },
                      icon: Icon(Icons.done,size: 30,),
                    )
                ),
              ],
            ),
          ]),
    );
  }

  EmailitemProfile(String title, String subtitle, IconData iconData,
      TextEditingController chatTextController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ExpansionTile(
          title: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData),
            tileColor: Colors.white,
          ),
          initiallyExpanded: false,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    child: TextFormField(
                      controller: chatTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                    IconButton(
                      onPressed: () async{
                        setState(() {
                          email = emailController.text;
                        });

                        if(email.compareTo('')==0){
                          return ;
                        }
                        else{
                          var response = await updateEmail(email);
                          if(response==200){
                            showDialog(context: (context), builder: (builder){
                              return CustomAlertDialog(
                                  title: 'Email Settings',
                                  description: 'Email Updated Succesfully',);
                            });
                          }
                          else if(response ==404){
                            showDialog(context: (context), builder: (builder){
                              return CustomAlertDialog(
                                  title: 'Email Settings',
                                  description: "Email Already Being Used",);
                            });
                          }
                        }

                        setState(() {
                          emailController..clear();
                        });
                      },
                      icon: Icon(Icons.done,size: 30,),
                    )
                ),
              ],
            ),
          ]),
    );
  }

  PassworditemProfile(String title, String subtitle, IconData iconData,
      TextEditingController chatTextController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ExpansionTile(
          title: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData),
            tileColor: Colors.white,
          ),
          initiallyExpanded: false,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    child: TextFormField(
                      controller: chatTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter new Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                    IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.done,size: 30,),
                    )
                ),
              ],
            ),
          ]),
    );
  }

  PhoneitemProfile(String title, String subtitle, IconData iconData,
      TextEditingController chatTextController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ExpansionTile(
          title: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData),
            tileColor: Colors.white,
          ),
          initiallyExpanded: false,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    child: TextFormField(
                      controller: chatTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {

                    },
                    child: chatTextController.text != ''
                        ? const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.done,
                              color: Color(0xFF113953),
                              size: 30,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.done,
                              color: Color(0xFF113953),
                              size: 30,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final String name, email;
  NavigationDrawer({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF113953),
      padding: const EdgeInsets.only(
        top: 50,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              'https://eliebarbar.000webhostapp.com/profileImages/${currentUser.photo}',
              height: 150,
              width: 150,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 28, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            email,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.home_outlined,
              color: Color(0xFF113953),
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("homepage");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.person,
              color: Color(0xFF113953),
            ),
            title: const Text('Friends'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("Friends");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.pending,
              color: Color(0xFF113953),
            ),
            title: const Text('Pending Friend Request'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("FriendsRequests");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.search,
              color: Color(0xFF113953),
              weight: 500,
            ),
            title: const Text('Search People'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("searchFriends");
            },
          ),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.settings,
              color: Color(0xFF113953),
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("setting");
            },
          ),
          const Divider(color: Color(0xFF113953)),
          ListTile(
            titleTextStyle: const TextStyle(color: Color(0xFF113953)),
            leading: const Icon(
              Icons.logout,
              color: Color(0xFF113953),
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('LoginPage');
            },
          ),
        ],
      ),
    );
  }
}
