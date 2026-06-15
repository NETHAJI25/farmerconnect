import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'available_farmers_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  Future<List<dynamic>> getProducts() async {

    return await SupabaseService.supabase
        .from('products')
        .select()
        .eq('category', category);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.green,
      ),

      body: FutureBuilder(
        future: getProducts(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data as List;

          if (data.isEmpty) {
            return const Center(
              child: Text("No Products Available"),
            );
          }

          final uniqueProducts = data
              .map((e) => e['product_name'])
              .toSet()
              .toList();

          return ListView.builder(
            itemCount: uniqueProducts.length,

            itemBuilder: (context, index) {

              String productName =
                  uniqueProducts[index];

              int farmerCount = data
                  .where(
                    (p) =>
                        p['product_name'] ==
                        productName,
                  )
                  .length;

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(productName),

                  subtitle: Text(
                    "$farmerCount Farmers Available",
                  ),

                  trailing: ElevatedButton(
                    child:
                        const Text("View Options"),

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AvailableFarmersScreen(
                            productName:
                                productName,
                          ),
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