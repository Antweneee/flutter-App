import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hair_appointment/admin_login.dart';
import 'login_page.dart';
import 'register_page.dart';

class FacadePage extends StatelessWidget {
  const FacadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hair Salon App'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
                  Colors.purple,
                  Colors.blue,
        ])),
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Book appointment',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            'assets/barber.jpg',
            width: 200.0, // Adjust the width as needed
            height: 200.0, // Adjust the height as needed
            fit: BoxFit.cover, // Adjust the fit as nee
          ),
          const SizedBox(height: 50,),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminLogin()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'Admin Login',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}