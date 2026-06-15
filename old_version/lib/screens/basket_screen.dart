import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/app_data.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  Future<void> makeCall(String phone) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    if (AppData.basket.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("Basket Empty"),
        ),
      );
    }

    final item = AppData.basket.first;
    final product = item["product"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Basket"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          child: ListTile(
            title: Text(product.productName),
            subtitle: Text(
              "Farmer: ${product.farmerName}\n"
              "Price: ₹${product.price}/kg\n"
              "Phone: ${product.phone}\n"
              "Address: ${product.address}",
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.call,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                makeCall(product.phone);
              },
            ),
          ),
        ),
      ),
    );
  }
}