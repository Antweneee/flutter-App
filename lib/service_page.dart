import 'package:flutter/material.dart';
import 'package:hair_appointment/sql_manipulation.dart';
import 'package:hair_appointment/user_profile.dart';
import 'package:intl/intl.dart';

class ServicesPage extends StatefulWidget {
  final String userName;
  final String password;

  const ServicesPage({
    Key? key,
    required this.userName,
    required this.password,
  }) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<String> selectedServices = [];
  int userId = -1;
  DateTime bookingDateController = DateTime.now();
  Map<String, dynamic>? userData;


  final List<String> availableServices = [
    'Cutting and Blowing',
    'Perming',
    'Straightening',
    'Bleaching',
    'Colouring',
  ];

  void _loginUser() async {
    userData = await SQLHelper.getUserByUsernameAndPassword(username: widget.userName, password: widget.password);
  }

  Future<void> _addHaibook(int userId, String appointmentDate, String appointmentTime, List<String> services) async {
    String tmp = "";
    if (services.length == 2) {
      tmp = "${services[0]}, ${services[1]}";
    } else {
      tmp = services[0];
    }
    await SQLHelper.createHairbook(userId: userId, appointmentDate: appointmentDate, appointmentTime: appointmentTime, services: tmp);
  }

  @override
  Widget build(BuildContext context) {
    String appointmentDate = "";
    String appointmentTime = "";
    List<String> dateTimeParts = [];

    _loginUser();

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
                'Choose your appointment and service(s)',
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
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Booking date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(bookingDateController)),
                      onPressed: () async {
                        final date = await pickDate(bookingDateController);
                        if (date == null) return;

                        final newDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          bookingDateController.hour,
                          bookingDateController.minute,
                        );
                        setState(() => bookingDateController = newDateTime);
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text(DateFormat('HH:mm').format(bookingDateController)),
                        onPressed: () async {
                          final time = await pickTime(bookingDateController);
                          if (time == null) return;

                          final newDateTime = DateTime(
                            bookingDateController.year,
                            bookingDateController.month,
                            bookingDateController.day,
                            time.hour,
                            time.minute,
                          );
                          setState(() => bookingDateController = newDateTime);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableServices.length,
                  itemBuilder: (context, index) {
                    final service = availableServices[index];
                    return CheckboxListTile(
                      title: Text(
                        service,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: selectedServices.contains(service),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              if (selectedServices.length < 2) {
                                selectedServices.add(service);
                              } else {
                                // Show a message indicating that at most two services can be selected
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'You can select at most two services.'),
                                  ),
                                );
                              }
                            } else {
                              selectedServices.remove(service);
                            }
                          }
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        dateTimeParts = bookingDateController.toString().split(' ');
                        appointmentDate = dateTimeParts[0];
                        appointmentTime = dateTimeParts[1];
                        int userId = userData?['userid'];
                        if (selectedServices.isNotEmpty) {
                          await _addHaibook(userId, appointmentDate, appointmentTime, selectedServices);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  User_Profile(
                                userData: userData
                              )
                            ),
                          );
                        } else {
                          // Show a message indicating that at least one service must be selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please choose at least one service.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Book'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        dateTimeParts = bookingDateController.toString().split(' ');
                        appointmentDate = dateTimeParts[0];
                        appointmentTime = dateTimeParts[1];
                        int userId = userData?['userid'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  User_Profile(
                                userData: userData
                              )
                            ),
                          );
                      },
                      child: const Text('User Profile'),
                    ),
                  ]
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate(DateTime initialDate) => showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime(DateTime initialTime) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initialTime.hour, minute: initialTime.minute),
      );
}
