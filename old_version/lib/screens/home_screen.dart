import 'package:flutter/material.dart';
import 'buy_products_screen.dart';
import 'sell_products_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FarmConnect"),
        backgroundColor: Colors.green,
        actions: [
          // Settings Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),

          // Logout Button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Buy Products Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text("Buy Products"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BuyProductsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Sell Products Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.sell),
                title: const Text("Sell Products"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellProductsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}