import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("About FarmConnect"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "FarmConnect",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "FarmConnect is a direct farmer-to-consumer marketplace that enables buyers to purchase fruits, vegetables, and grains directly from farmers without any intermediaries.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Key Features",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "• Direct farmer connection\n"
              "• No middlemen\n"
              "• Product comparison\n"
              "• Farmer contact support\n"
              "• Fair pricing\n"
              "• Web & Mobile support",
            ),

            const SizedBox(height: 25),

            const Text(
              "Version 1.0",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Developed by Sathish Kumar",
            ),
          ],
        ),
      ),
    );
  }
}