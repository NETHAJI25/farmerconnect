import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/app_data.dart';
import '../services/current_user.dart';
import '../services/supabase_service.dart';

class SellProductsScreen extends StatefulWidget {
  const SellProductsScreen({super.key});

  @override
  State<SellProductsScreen> createState() =>
      _SellProductsScreenState();
}

class _SellProductsScreenState
    extends State<SellProductsScreen> {

  String category = "Fruits";

  bool useMyProfile = true;

  String get loggedInName =>
      CurrentUser.name;

  String get loggedInPhone =>
      CurrentUser.phone;

  String get loggedInAddress =>
      CurrentUser.address;

  final otherFarmerController =
      TextEditingController();

  final otherPhoneController =
      TextEditingController();

  final otherAddressController =
      TextEditingController();

  final productController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final quantityController =
      TextEditingController();

  Future<void> publishProduct() async {

  if (productController.text.isEmpty ||
      priceController.text.isEmpty ||
      quantityController.text.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Please fill all product details",
        ),
      ),
    );
    return;
  }

  String farmerName;
  String phone;
  String address;

  if (useMyProfile) {

    farmerName = loggedInName;
    phone = loggedInPhone;
    address = loggedInAddress;

    if (farmerName.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
        ),
      );

      return;
    }

  } else {

    if (otherFarmerController.text.isEmpty ||
        otherPhoneController.text.isEmpty ||
        otherAddressController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill farmer details",
          ),
        ),
      );

      return;
    }

    farmerName =
        otherFarmerController.text.trim();

    phone =
        otherPhoneController.text.trim();

    address =
        otherAddressController.text.trim();
  }

  try {

    await SupabaseService.supabase
        .from('products')
        .insert({
      'farmer_name': farmerName,
      'phone': phone,
      'address': address,
      'category': category,
      'product_name':
          productController.text.trim(),
      'price': double.parse(
        priceController.text.trim(),
      ),
      'quantity': int.parse(
        quantityController.text.trim(),
      ),
      'uploaded_by': loggedInName,
    });

    // Temporary local save also
    AppData.products.add(
      Product(
        farmerName: farmerName,
        phone: phone,
        address: address,
        category: category,
        productName:
            productController.text.trim(),
        price: double.parse(
          priceController.text.trim(),
        ),
        quantity: int.parse(
          quantityController.text.trim(),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Product Published Successfully",
        ),
      ),
    );

    productController.clear();
    priceController.clear();
    quantityController.clear();

    otherFarmerController.clear();
    otherPhoneController.clear();
    otherAddressController.clear();

    setState(() {});

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Error: $e",
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Products"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Seller Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            RadioListTile(
              title: const Text(
                "Use My Farm Profile",
              ),
              value: true,
              groupValue: useMyProfile,
              onChanged: (value) {
                setState(() {
                  useMyProfile = value!;
                });
              },
            ),

            RadioListTile(
              title: const Text(
                "Selling on Behalf of Another Farmer",
              ),
              value: false,
              groupValue: useMyProfile,
              onChanged: (value) {
                setState(() {
                  useMyProfile = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            if (useMyProfile)
              Card(
                elevation: 3,
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    loggedInName.isEmpty
                        ? "No User Logged In"
                        : loggedInName,
                  ),
                  subtitle: Text(
                    "$loggedInPhone\n$loggedInAddress",
                  ),
                ),
              ),

            if (!useMyProfile)
              Column(
                children: [

                  TextField(
                    controller:
                        otherFarmerController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Farmer Name",
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        otherPhoneController,
                    keyboardType:
                        TextInputType.phone,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Phone Number",
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        otherAddressController,
                    decoration:
                        const InputDecoration(
                      labelText: "Address",
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),

            DropdownButtonFormField<String>(
              value: category,
              decoration:
                  const InputDecoration(
                labelText: "Category",
                border:
                    OutlineInputBorder(),
              ),
              items: const [

                DropdownMenuItem(
                  value: "Fruits",
                  child: Text("Fruits"),
                ),

                DropdownMenuItem(
                  value: "Vegetables",
                  child: Text("Vegetables"),
                ),

                DropdownMenuItem(
                  value: "Grains",
                  child: Text("Grains"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: productController,
              decoration:
                  const InputDecoration(
                labelText: "Product Name",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText: "Price Per Kg",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  quantityController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Available Quantity (Kg)",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    publishProduct,
                child: const Text(
                    "Publish Product"),
              ),
            ),

            const SizedBox(height: 25),

            const Divider(),

            const Text(
              "Published Products",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...AppData.products.map((product) {

              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_basket,
                    color: Colors.green,
                  ),
                  title:
                      Text(product.productName),
                  subtitle: Text(
                    "Category: ${product.category}\n"
                    "Price: ₹${product.price}/kg\n"
                    "Quantity: ${product.quantity} kg\n"
                    "Farmer: ${product.farmerName}",
                  ),
                ),
              );

            }).toList(),
          ],
        ),
      ),
    );
  }
}