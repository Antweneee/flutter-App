import 'package:flutter/material.dart';
import 'sql_manipulation.dart';
import 'package:intl/intl.dart';

class ViewHairBooks extends StatefulWidget {
  final Map<String, dynamic> hairbookData;
  final Function(int) callback;

  const ViewHairBooks(
    {Key? key,
    required this.hairbookData,
    required this.callback,
  });
  
  @override
  _ViewHairBooksState createState() => _ViewHairBooksState();
}

class _ViewHairBooksState extends State<ViewHairBooks> {
  late Map<String, dynamic>? userData;
  late int userId;
  late String tmpStringUserId;
  late String userName;
  late String appointmentDate;
  late String appointmentTime;

  void deleteHairBook (bookId) async {
    await SQLHelper.deleteHairbook(bookId: bookId);
  }

  Future<void> getUserFromUserId(int userId) async {
    userData = await SQLHelper.getUserByUserId(userId: userId);
    userName = userData?['username'] ?? "Loading. . .";
  }

  @override
  void initState() {
    super.initState();

    userId = widget.hairbookData['userId'];
    tmpStringUserId = userId.toString();
    userName = "Loading. .";
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getUserFromUserId(userId);
    // Ensure that the widget is mounted before calling setState
    if (mounted) {
      setState(() {
        userName = userName; // This is just to trigger a rebuild
      });
    }
  }

  void showEditPopup(BuildContext context, bookid, services, appointmentDate, appointmentTime, Function(int) callback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditHairBook(bookid: bookid, services: services, appointmentDate: appointmentDate, appointmentTime: appointmentTime, userId: userId,callback: callback);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder(
              future: getUserFromUserId(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    userName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  );
                } else {
                  return const Text(
                    "Loading. . .", // Or any other placeholder text
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                showEditPopup(context, widget.hairbookData['bookid'], widget.hairbookData['services'], widget.hairbookData['appointmentdate'], widget.hairbookData['appointmenttime'], widget.callback);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0), // No padding
              ),
              child: const Icon(Icons.edit , size: 20),
            )
          ),
          ElevatedButton(
            onPressed: () {
              deleteHairBook(widget.hairbookData['bookid']);
              widget.callback(userId);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0), // No padding
            ),
            child: const Icon(Icons.delete, size: 20),
          ),
          const SizedBox(width: 2),
        ],
      )
    );
  }
}


class EditHairBook extends StatefulWidget {
  final int bookid;
  final String services;
  final String appointmentDate;
  final String appointmentTime;
  final int userId;
  final Function(int) callback;

  const EditHairBook(
    {Key? key,
    required this.bookid,
    required this.services,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.userId,
    required this.callback
  });

  @override
  _EditHairBookState createState() => _EditHairBookState();
}

class _EditHairBookState extends State<EditHairBook> {
  late List<String> selectedServices;
  late DateTime bookingDateController;
  late List<String> availableServices;

  @override
  void initState() {
    super.initState();

    selectedServices = parseServices(widget.services);
    bookingDateController = DateTime.parse("${widget.appointmentDate} ${widget.appointmentTime}");

    availableServices = [
      'Cutting and Blowing',
      'Perming',
      'Straightening',
      'Bleaching',
      'Colouring',
    ];    
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

  List<String> parseServices(String services) {
    List<String> parsedServices = services.split(", ");
    return parsedServices;
  }

  @override
  Widget build(BuildContext context) {
    return (
      Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking date:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(DateFormat('dd/MM/yyyy').format(bookingDateController)),
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
                    const SizedBox(width: 5),
                    ElevatedButton(
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
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableServices.length,
                  itemBuilder: (context, index) {
                    final service = availableServices[index];
                    return CheckboxListTile(
                      title: Text(
                        service,
                        style: const TextStyle(color: Colors.black),
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
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close, size: 20),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        
                        String tmpService = "";
                        if (selectedServices.length == 2) {
                          tmpService  = "${selectedServices[0]}, ${selectedServices[1]}";
                        } else {
                          tmpService = selectedServices[0];
                        }
                        List<String> tmpTime = bookingDateController.toString().split(' ');

                        await SQLHelper.modifyHairbook(bookid: widget.bookid, appointmentdate: tmpTime[0], appointmenttime: tmpTime[1], services: tmpService);
                        widget.callback(widget.userId);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Edit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}