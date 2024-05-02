import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tumaz_kitchen/controllers/authcontroller.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField(context, 'Name', authController.userName.value),
            const SizedBox(height: 16.0),
            _buildProfileField(
                context, 'Phone Number', authController.phoneNumber.value),
            const SizedBox(height: 32.0),
            _buildEditProfileButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showEditProfileDialog(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSecondary, backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profile'),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: authController.userName.value,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  onChanged: (value) {
                    authController.userName.value = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: authController.phoneNumber.value,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  onChanged: (value) {
                    authController.phoneNumber.value = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSecondary, backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save profile changes
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSecondary, backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Save'),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.background,
        );
      },
    );
  }
}
