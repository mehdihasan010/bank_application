import 'package:bank_application/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/api.dart';
import '../../data/model/user.dart'; // For using the Iconsax icons

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  int userId = 1;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    var response =
        await ApiService.getUser(userId); // Call getBalance statically
    setState(() {
      user = response; // Update your state with the fetched balance
    });
    //print(user?.email.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Profile Picture and Edit Button
          const Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/profile.jpeg'), // Replace with actual image asset or network image
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Color(0xFF0B438C),
                  radius: 16,
                  child: Icon(
                    Iconsax.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Username and Email
          Text(
            user != null ? user!.name.toString() : 'Name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            user != null ? user!.email.toString() : 'Email',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          // Edit Profile Button
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.4,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B438C),
              ),
              onPressed: () {
                // Handle edit profile action
              },
              child: Text(
                'Edit Profile',
                style: textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // List of Options
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(Iconsax.setting_2, 'Settings', () {
                  // Navigate to settings
                }),
                _buildProfileOption(Iconsax.card, 'Billing Details', () {
                  // Navigate to billing details
                }),
                _buildProfileOption(Iconsax.user, 'User Management', () {
                  // Navigate to user management
                }),
                _buildProfileOption(Iconsax.info_circle, 'Information', () {
                  // Navigate to information page
                }),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton.icon(
                onPressed: () {
                  // Your action here
                  Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(
                  Iconsax.logout,
                  color: Colors.red,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ))
        ],
      ),
    );
  }

  // Function to build each profile option
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap,
      {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
