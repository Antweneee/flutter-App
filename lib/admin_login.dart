  import 'package:flutter/material.dart';
  import 'package:hair_appointment/admin_page.dart';
  import 'package:hair_appointment/sql_manipulation.dart';
  import 'service_page.dart';

  class AdminLogin extends StatefulWidget {
    const AdminLogin({super.key});
    
    @override
    _AdminLoginState createState() => _AdminLoginState();
  }

  class _AdminLoginState extends State<AdminLogin> {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    List<Map<String, dynamic>> hairbooks = [];
    List<Map<String, dynamic>> users = [];

    Future<bool> isAdmin(String username, String password) async {
      Map<String, dynamic>? tmp = await SQLHelper.isAdmin(username: username, password: password);
      if (tmp != null && tmp.isNotEmpty) {
        return true;   
      } else {
        return false;
      }
    }

    Future<void> getUsers() async {
      List<Map<String, dynamic>> tmp = await SQLHelper.getAllUsers();
      setState(() {
        users = tmp;
      });
    }

    Future<void> getHaribooks() async {
      List<Map<String, dynamic>> tmp = await SQLHelper.getAllHairbooks();
      setState(() {
        hairbooks = tmp;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height - 200,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.check,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Colors.purple,
                                Colors.blue,
                              ]),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool tmp = await isAdmin(nameController.text, passwordController.text);
                                  if (tmp == true) {
                                    await getUsers(); // Wait for getUsers to complete
                                    await getHaribooks(); // Wait for getHaribooks to complete

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminPage(
                                          userName: nameController.text,
                                          password: passwordController.text,
                                          users: users,
                                          hairbooks: hairbooks,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle the case where isAdmin is false
                                  }
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Set to transparent to use the decoration gradient
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Admin Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
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
          ]),
        );
    }

    
  }
