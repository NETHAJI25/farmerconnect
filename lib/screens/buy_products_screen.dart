import 'package:flutter/material.dart';
import 'category_products_screen.dart';

class BuyProductsScreen extends StatelessWidget {
  const BuyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Products"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            categoryCard(
              context,
              "Fruits",
              Icons.apple,
              "Fresh fruits directly from farmers",
            ),

            const SizedBox(height: 15),

            categoryCard(
              context,
              "Vegetables",
              Icons.eco,
              "Organic vegetables from farms",
            ),

            const SizedBox(height: 15),

            categoryCard(
              context,
              "Grains",
              Icons.agriculture,
              "Rice, wheat and grains",
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryCard(
    BuildContext context,
    String category,
    IconData icon,
    String description,
  ) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(
          icon,
          size: 45,
          color: Colors.green,
        ),
        title: Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(
                category: category,
              ),
            ),
          );
        },
      ),
    );
  }
}