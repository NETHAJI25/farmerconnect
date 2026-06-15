import 'package:flutter/material.dart';
import '../services/user_data.dart';
import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // User Profile Header
          Container(
            width: double.infinity,
            color: Colors.green.shade100,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  UserData.name.isEmpty
                      ? "FarmConnect User"
                      : UserData.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  UserData.phone,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.green,
                  ),
                  title: const Text("Profile"),
                  trailing:
                      const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          name: UserData.name,
                          phone: UserData.phone,
                          address: UserData.address,
                          district: UserData.district,
                        ),
                      ),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: Colors.orange,
                  ),
                  title: const Text("Change Password"),
                  trailing:
                      const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  title: const Text("About App"),
                  trailing:
                      const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AboutAppScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "FarmConnect",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Version 1.0",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}