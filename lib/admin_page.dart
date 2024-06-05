import 'package:flutter/material.dart';
import 'sql_manipulation.dart';
import 'dart:ui';
import 'edit_hairbook.dart';

class ViewUserComponent extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function() callback;

  const ViewUserComponent({
    Key? key,
    required this.userData,
    required this.callback
  });

  @override
  _ViewUserComponentState createState() => _ViewUserComponentState();
}

class _ViewUserComponentState extends State<ViewUserComponent> {
  void deleteUser(int userid) async {
    await SQLHelper.deleteUser(userid: userid);
  }

  void showEditPopup(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    nameController.text = widget.userData['name'];
    emailController.text = widget.userData['email'];
    phoneController.text = widget.userData['phone'];
    usernameController.text = widget.userData['username'];
    passwordController.text = widget.userData['password'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Blurred background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // Popup content
            AlertDialog(
              title: const Text("Edit User"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
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
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone';
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
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
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
                      const SizedBox(height: 5,),
                      TextFormField(
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
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ]
                  ),
                ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, size: 20),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Handle edit action
                    await SQLHelper.modifyUser(
                      userid: widget.userData['userid'],
                      newName: nameController.text,
                      newEmail: emailController.text,
                      newPhone: phoneController.text,
                      newUsername: usernameController.text,
                      newPassword: passwordController.text,
                    );
                    widget.callback();
                    Navigator.of(context).pop();
                  },
                  child: Text("Edit"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String tmpuserid = widget.userData["userid"].toString();
    String tmpusername = widget.userData["username"];
    String tmpname = widget.userData["name"];

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 213, 209, 209), // Set your desired background color
        borderRadius: BorderRadius.circular(16.0), // Set the border radius
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 2),
          Flexible(
            child : Text(
              tmpusername,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child : Text(
              tmpname,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                showEditPopup(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0), // No padding
              ),
              child: const Icon(Icons.edit , size: 20),
            )
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                deleteUser(widget.userData['userid']);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0), // No padding
              ),
              child: const Icon(Icons.delete , size: 20),
            ),
          ),
          const SizedBox(width: 2)
        ],
      ),
    );
  }
}

class AdminPage extends StatefulWidget {
    final String userName;
    final String password;
    final List<Map<String, dynamic>> users;
    final List<Map<String, dynamic>> hairbooks;

    const AdminPage({
    Key? key,
    required this.userName,
    required this.password,
    required this.users,
    required this.hairbooks,
  }) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late List<Map<String, dynamic>> tmpUsers;
  late List<Map<String, dynamic>> tmpHairbooks;

  void _refreshDatas() async {
    List<Map<String, dynamic>> updatedUsers = await SQLHelper.getAllUsers();
    List<Map<String, dynamic>> updatedHairbooks = await SQLHelper.getAllHairbooks();

    setState(() {
      tmpUsers = updatedUsers;
      tmpHairbooks = updatedHairbooks;
    });

  }

  @override
  void initState() {
    super.initState();

    tmpUsers = widget.users;
    tmpHairbooks = widget.hairbooks;
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
                'Admin view',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "User name",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tmpUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ViewUserComponent(
                        userData: tmpUsers[index],
                        callback: _refreshDatas,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                const Row(
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tmpHairbooks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ViewHairBooks(
                        hairbookData: tmpHairbooks[index],
                        callback: _refreshDatas,
                      ),
                    );
                  },
                ),
              ]
            )
          )
        ]
      )
    );
  }
}
