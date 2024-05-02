import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tumaz_kitchen/main.dart';
import 'package:tumaz_kitchen/views/login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _selectedIndex = 1;
  TextEditingController uName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Get.to(() => const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 218, 163, 127)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/images/logo2.jpg"),
            ),
            const Text(
              "Simply The Best",
              style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 218, 163, 127)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: uName,
                    style: const TextStyle(color: Colors.white), // Text color
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.grey), // Label color
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: phone,
                    style: const TextStyle(color: Colors.white), // Text color
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.grey), // Label color
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white), // Text color
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey), // Label color
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      serverRegistrationScreen();
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Register',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> serverRegistrationScreen() async {
    if (uName.text.trim().isEmpty ||
        phone.text.trim().isEmpty ||
        password.text.trim().isEmpty) {
      const snackBar = SnackBar(
        content: Text(
          'Please Fill in all Fields',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    http.Response response;
    var bodyFields = {
      'username': uName.text.trim(),
      'phone': phone.text.trim(),
      'password': password.text.trim()
    };
    response = await http.post(
        Uri.parse("https://scholarcrafts.xyz/tumas_kitchen/registration.php"),
        body: bodyFields);
    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int signedUp = serverResponse['success'];
      if (signedUp == 1) {
        const snackBar = SnackBar(
          content: Text(
            'Account Created Successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Get.offAndToNamed("/");
      }
    }
  }
}
