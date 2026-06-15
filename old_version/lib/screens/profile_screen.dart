import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String district;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.district,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Farmer Details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text("Name : $name"),
                const SizedBox(height: 10),

                Text("Phone : $phone"),
                const SizedBox(height: 10),

                Text("Address : $address"),
                const SizedBox(height: 10),

                Text("District : $district"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}