import 'package:flutter/material.dart';
import '../services/app_data.dart';
import 'farmer_details_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double getTotalPrice() {

    double total = 0;

    for (var item in AppData.cart) {

      total += item["product"].price * item["qty"];
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.green,
      ),

      body: AppData.cart.isEmpty
          ? const Center(
              child: Text("Cart is Empty"),
            )
          : Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: AppData.cart.length,

                    itemBuilder: (context, index) {

                      final item = AppData.cart[index];
                      final product = item["product"];

                      return Card(
                        margin: const EdgeInsets.all(10),

                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),

                          title: Text(product.productName),

                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                  "Price: ₹${product.price}/kg"),

                              Row(
                                children: [

                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove),
                                    onPressed: () {

                                      if (item["qty"] > 1) {

                                        setState(() {
                                          item["qty"]--;
                                        });
                                      }
                                    },
                                  ),

                                  Text(
                                      "${item["qty"]}"),

                                  IconButton(
                                    icon:
                                        const Icon(Icons.add),
                                    onPressed: () {

                                      setState(() {
                                        item["qty"]++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {

                              setState(() {
                                AppData.cart.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    children: [

                      Text(
                        "Total Price : ₹${getTotalPrice()}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const FarmerDetailsScreen(),
                            ),
                          );
                        },
                        child:
                            const Text("Check Available"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}