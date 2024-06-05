import 'package:flutter/material.dart';
import 'package:hair_appointment/sql_manipulation.dart';
import 'edit_user_haibook.dart';

class EditUserData extends StatefulWidget {
  final String userData;
  final String dataString;
  final int userid;
  final Function(int) callback;

  const EditUserData(
    {Key ? key,
    required this.userData,
    required this.dataString,
    required this.userid,
    required this.callback,
    });

  @override
  _EditUserDataState createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  TextEditingController _textEditingController = TextEditingController();

  void _changeName(userId, newName) async {
    await SQLHelper.modifyUserName(userId: userId, newName: newName);
  }

  void _changeEmail(userId, newEmail) async {
    await SQLHelper.modifyUserEmail(userId: userId, newEmail: newEmail);
  }

  void _changePhone(userId, newPhone) async {
    await SQLHelper.modifyUserPhone(userId: userId, newPhone: newPhone);
  }

  void _changeUsername(userId, newUsername) async {
    await SQLHelper.modifyUserUsername(userId: userId, newUsername: newUsername);
  }

  void _changePassword(userId, newPassword) async {
    await SQLHelper.modifyUserPassword(userId: userId, newPassword: newPassword);
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.userData;
  }

  @override
  Widget build(BuildContext context) {
    return (
      AlertDialog(
        title: const Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _textEditingController,
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
              ]
           )
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
              switch (widget.dataString) {
                case 'Name:':
                  _changeName(widget.userid, _textEditingController.text);
                  widget.callback(widget.userid);
                  break;
                case 'Email:':
                  _changeEmail(widget.userid, _textEditingController.text);
                  widget.callback(widget.userid);
                  break;
                case 'Phone:':
                  _changePhone(widget.userid, _textEditingController.text);
                  widget.callback(widget.userid);
                  break;
                case 'UserName:':
                  _changeUsername(widget.userid, _textEditingController.text);
                  widget.callback(widget.userid);
                  break;
                case 'Password:':
                  _changePassword(widget.userid, _textEditingController.text);
                  widget.callback(widget.userid);
                  break;
              }
              Navigator.of(context).pop();
            },
            child: Text("Edit"),
          ),
        ],
      )
    );
  }
}

class MyUserDataWidget extends StatefulWidget {
  final String userData;
  final String dataString;
  final int userId;
  final Function(int) callback;

  const MyUserDataWidget ({
    Key? key,
    required this.userData,
    required this.dataString,
    required this.userId,
    required this.callback,
  });

  @override
  _MyUserDataWidgetState createState() => _MyUserDataWidgetState();
}

class _MyUserDataWidgetState extends State<MyUserDataWidget> {

  void showEditPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditUserData(userData: widget.userData, dataString: widget.dataString, userid: widget.userId, callback: widget.callback);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.dataString,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          widget.userData,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            showEditPopup(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0), // No padding
          ),
          child: const Icon(Icons.edit , size: 20),
        ),
      ]
    );               
  }
}

class User_Profile extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const User_Profile({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _User_ProfileState createState() => _User_ProfileState();
}
class _User_ProfileState extends State<User_Profile> {
  List<Map<String, dynamic>> userHairbooks = [];
  bool _isTextFieldVisible = false;
  Map<String, dynamic>? userDataModifiable = {};
  int userId = 0;

  void _refreshDatas(int userId) async {
    List<Map<String, dynamic>> hairbooks = await SQLHelper.getHairbooksByUser(userId: userId);
    Map<String, dynamic>? datas = await SQLHelper.getUserByUserId(userId: userId);
    setState(() {
        userHairbooks = hairbooks;
        userDataModifiable = datas;
      });
  }

  @override
  void initState() {
    super.initState();
    
    // Call the function here that you want to execute once.
    userDataModifiable = widget.userData;
    userId = widget.userData?['userid'];
    _refreshDatas(userId);
  }

  @override
  Widget build(BuildContext context) {
    // I have this piece of code here, this is a call to another widget that is used to change the value in the database of different fields, the call back is simply a ping to the database and update the variable userdataModifiable with a setState, but I don't know why the newly changed field in the db
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
                'User Profile',
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
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10.0), // Round border
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      MyUserDataWidget(userData: userDataModifiable?['name'], dataString: "Name:", userId: userId, callback: _refreshDatas,),
                      const SizedBox(height: 5),
                      MyUserDataWidget(userData: userDataModifiable?['email'], dataString: "Email:", userId: userId, callback: _refreshDatas,),
                      const SizedBox(height: 5),
                      MyUserDataWidget(userData: userDataModifiable?['phone'], dataString: "Phone:", userId: userId, callback: _refreshDatas,),
                      const SizedBox(height: 5),
                      MyUserDataWidget(userData: userDataModifiable?['username'], dataString: "UserName:", userId: userId, callback: _refreshDatas),  
                      const SizedBox(height: 5),
                      MyUserDataWidget(userData: userDataModifiable?['password'], dataString: "Password:", userId: userId, callback: _refreshDatas,),
                    ],
                  )
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userHairbooks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ViewHairBooks(
                        hairbookData: userHairbooks[index],
                        callback: _refreshDatas,
                      ),
                    );
                  },
                ),
              ]
            )
          ),
        ])
    );
  }
}
