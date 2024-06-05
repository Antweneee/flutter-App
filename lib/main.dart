import 'package:flutter/material.dart';
import 'facade_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wedding Booking App',
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: FacadePage(),
    );
  }
}
