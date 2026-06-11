import 'package:flutter/material.dart';
import '../services/app_data.dart';

class FarmerDetailsScreen extends StatelessWidget {
  const FarmerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Farmers"),
        backgroundColor: Colors.green,
      ),

      body: ListView.builder(
        itemCount: AppData.products.length,

        itemBuilder: (context, index) {

          final product =
              AppData.products[index];

          return Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(
              leading:
                  const Icon(Icons.person),

              title:
                  Text(product.farmerName),

              subtitle: Text(
                "Product : ${product.productName}\n"
                "Phone : ${product.phone}\n"
                "Address : ${product.address}\n"
                "Price : ₹${product.price}/kg",
              ),
            ),
          );
        },
      ),
    );
  }
}