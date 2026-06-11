import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/app_data.dart';
import '../models/product.dart';
import 'basket_screen.dart';

class AvailableFarmersScreen extends StatelessWidget {
  final String productName;

  const AvailableFarmersScreen({
    super.key,
    required this.productName,
  });

  Future<List<dynamic>> getFarmers() async {
    return await SupabaseService.supabase
        .from('products')
        .select()
        .eq('product_name', productName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        backgroundColor: Colors.green,
      ),

      body: FutureBuilder(
        future: getFarmers(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final farmers = snapshot.data as List;

          if (farmers.isEmpty) {
            return const Center(
              child: Text(
                "No Farmers Available",
              ),
            );
          }

          // Find lowest price
          double lowestPrice = farmers
              .map(
                (e) => (e['price'] as num)
                    .toDouble(),
              )
              .reduce(
                (a, b) => a < b ? a : b,
              );

          return ListView.builder(
            itemCount: farmers.length,

            itemBuilder: (context, index) {

              final farmer = farmers[index];

              bool isLowest =
                  (farmer['price'] as num)
                          .toDouble() ==
                      lowestPrice;

              return Card(
                margin:
                    const EdgeInsets.all(10),

                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: isLowest
                        ? Colors.orange
                        : Colors.green,
                  ),

                  title: Row(
                    children: [

                      Expanded(
                        child: Text(
                          farmer['farmer_name'],
                        ),
                      ),

                      if (isLowest)
                        const Chip(
                          label: Text(
                            "⭐ Best Price",
                          ),
                        ),
                    ],
                  ),

                  subtitle: Text(
                    "Price : ₹${farmer['price']}/kg\n"
                    "Available : ${farmer['quantity']} kg\n"
                    "Phone : ${farmer['phone']}\n"
                    "Address : ${farmer['address']}",
                  ),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 35,
                    ),

                    onPressed: () {

                      AppData.basket.clear();

                      AppData.basket.add({
                        "product": Product(
                          farmerName:
                              farmer['farmer_name'],
                          phone:
                              farmer['phone'],
                          address:
                              farmer['address'],
                          category:
                              farmer['category'],
                          productName:
                              farmer['product_name'],
                          price:
                              (farmer['price']
                                      as num)
                                  .toDouble(),
                          quantity:
                              farmer['quantity'],
                        ),
                        "qty": 1,
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const BasketScreen(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}