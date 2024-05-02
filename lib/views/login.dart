import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tumaz_kitchen/controllers/authcontroller.dart';
import 'package:tumaz_kitchen/views/admin.dart';
import 'package:tumaz_kitchen/views/registration.dart';
import 'package:tumaz_kitchen/views/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  int _selectedIndex = 0;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthController authController = Get.put(AuthController());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Get.to(() => const RegistrationScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Login",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 218, 163, 127)),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipOval(
                child: Image.asset(
                  "assets/images/logo2.jpg",
                  height: 200,
                  width: 200,
                ),
              ),
              const Text(
                "Simply The Best",
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 218, 163, 127)),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: phoneController,
                      style: const TextStyle(color: Colors.white), // Text color
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(color: Colors.grey), // Label color
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white), // Text color
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.grey), // Label color
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await remoteLogin();
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> remoteLogin() async {
    try {
      if (phoneController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        throw Exception("Please Enter both Phone Number and Password");
      }

      final response = await http.get(Uri.parse(
          "https://scholarcrafts.xyz/tumas_kitchen/login.php?phone=${phoneController.text.trim()}&password=${passwordController.text.trim()}"));

      if (response.statusCode == 200) {
        final serverResponse = json.decode(response.body);
        final loginStatus = serverResponse['success'];
        if (loginStatus == 1) {
          final userData = serverResponse['userdata'];
          final phone = userData[0]['phone'];
          final role = userData[0]['role'];
          final name = userData[0]['username'];

          if (role == '1') {
            // Navigate to user screen
            Get.to(() => UserHomeScreen());
          } else if (role == '0') {
            // Navigate to admin screen
            Get.to(() => AdminHomeScreen());
          } else {
            throw Exception("Invalid Role");
          }
          authController.updateUserInfo(number: phone, name: name);
          print("Login Success");
        } else {
          throw Exception("Invalid Phone Number or Password");
        }
      } else {
        throw Exception("Server Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
