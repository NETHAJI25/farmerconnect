import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/app_data.dart';
import '../services/current_user.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../utils/image_constants.dart';

class SellProductsScreen extends StatefulWidget {
  const SellProductsScreen({super.key});

  @override
  State<SellProductsScreen> createState() => _SellProductsScreenState();
}

class _SellProductsScreenState extends State<SellProductsScreen> {
  String category = 'Fruits';
  bool useMyProfile = true;

  final otherFarmerController = TextEditingController();
  final otherPhoneController = TextEditingController();
  final otherAddressController = TextEditingController();
  final productController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  String get loggedInName => CurrentUser.name;
  String get loggedInPhone => CurrentUser.phone;
  String get loggedInAddress => CurrentUser.address;

  @override
  void dispose() {
    otherFarmerController.dispose();
    otherPhoneController.dispose();
    otherAddressController.dispose();
    productController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> publishProduct() async {
    if (productController.text.isEmpty || priceController.text.isEmpty || quantityController.text.isEmpty) {
      _showToast(context, 'Please fill all product details', isError: true);
      return;
    }

    setState(() => isLoading = true);

    String farmerName, phone, address;

    if (useMyProfile) {
      farmerName = loggedInName;
      phone = loggedInPhone;
      address = loggedInAddress;
      if (farmerName.isEmpty) {
        _showToast(context, 'Please login first', isError: true);
        setState(() => isLoading = false);
        return;
      }
    } else {
      if (otherFarmerController.text.isEmpty || otherPhoneController.text.isEmpty || otherAddressController.text.isEmpty) {
        _showToast(context, 'Please fill farmer details', isError: true);
        setState(() => isLoading = false);
        return;
      }
      farmerName = otherFarmerController.text.trim();
      phone = otherPhoneController.text.trim();
      address = otherAddressController.text.trim();
    }

    try {
      await SupabaseService.supabase.from('products').insert({
        'farmer_name': farmerName,
        'phone': phone,
        'address': address,
        'category': category,
        'product_name': productController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'quantity': int.parse(quantityController.text.trim()),
        'description': descriptionController.text.trim(),
        'uploaded_by': loggedInName,
      });

      AppData.products.add(Product(
        farmerName: farmerName,
        phone: phone,
        address: address,
        category: category,
        productName: productController.text.trim(),
        price: double.parse(priceController.text.trim()),
        quantity: int.parse(quantityController.text.trim()),
      ));

      if (!mounted) return;
      _showToast(context, 'Product Published Successfully');

      productController.clear();
      priceController.clear();
      quantityController.clear();
      descriptionController.clear();
      otherFarmerController.clear();
      otherPhoneController.clear();
      otherAddressController.clear();
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      _showToast(context, 'Error: $e', isError: true);
    }

    setState(() => isLoading = false);
  }

  void _showToast(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: isError ? AppTheme.offerRed : AppTheme.forestGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myProducts = AppData.products.where((p) => p.farmerName == loggedInName).toList();
    final isLoggedIn = loggedInName.isNotEmpty;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context, isLoggedIn, myProducts),
            if (isLoggedIn) _buildAnalyticsRow(context, myProducts),
            if (isLoggedIn) _buildAddProductSection(context),
            if (isLoggedIn && myProducts.isNotEmpty) _buildMyProducts(context, myProducts),
            if (!isLoggedIn) _buildLoginPrompt(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLoggedIn, List<Product> myProducts) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.forestGreen.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isLoggedIn ? 'Hello, ${loggedInName.split(' ')[0]}!' : 'Seller Dashboard',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(isLoggedIn ? '${myProducts.length} products listed' : 'Login to start selling',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.store_rounded, color: AppTheme.forestGreen, size: 28),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.store_outlined, size: 64, color: AppTheme.forestGreen),
          ),
          const SizedBox(height: 20),
          const Text('Start Selling Your Produce',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Reach thousands of customers directly',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Login to Start Selling'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsRow(BuildContext context, List<Product> myProducts) {
    final analytics = [
      {'value': '${myProducts.length}', 'label': 'Products', 'icon': Icons.inventory_2, 'color': AppTheme.forestGreen},
      {'value': '₹${myProducts.fold<int>(0, (s, p) => s + (p.price * p.quantity).toInt())}', 'label': 'Revenue', 'icon': Icons.trending_up, 'color': AppTheme.successGreen},
      {'value': '${myProducts.where((p) => p.quantity > 0).length}', 'label': 'Active', 'icon': Icons.check_circle, 'color': AppTheme.harvestAmber},
      {'value': '${myProducts.fold<int>(0, (s, p) => s + p.quantity)}kg', 'label': 'Stock', 'icon': Icons.inventory, 'color': AppTheme.cartOrange},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(analytics.length, (i) {
                final a = analytics[i];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (a['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(a['value'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    Text(a['label'] as String, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ).animate().fadeIn(delay: (i * 80).ms).slideY(begin: 0.2);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddProductSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Text('Add New Product', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.forestGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.forestGreen)),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassEffect(),
                child: Column(
                  children: [
                    RadioGroup<bool>(
                      groupValue: useMyProfile,
                      onChanged: (v) => setState(() => useMyProfile = v ?? false),
                      child: Column(
                        children: [
                          RadioListTile<bool>(
                            value: true,
                            title: const Text('Use My Farm Profile', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Text(loggedInName.isNotEmpty ? 'Selling as $loggedInName' : 'Not logged in', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            activeColor: AppTheme.forestGreen,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Divider(height: 1),
                          RadioListTile<bool>(
                            value: false,
                            title: const Text('Sell for Another Farmer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: const Text('Enter their details below', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            activeColor: AppTheme.forestGreen,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    if (!useMyProfile) ...[
                      const SizedBox(height: 16),
                      TextField(controller: otherFarmerController, decoration: const InputDecoration(labelText: 'Farmer Name', prefixIcon: Icon(Icons.person), hintText: 'Enter farmer name')),
                      const SizedBox(height: 12),
                      TextField(controller: otherPhoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone), hintText: '10-digit mobile number')),
                      const SizedBox(height: 12),
                      TextField(controller: otherAddressController, decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on), hintText: 'Farm address')),
                    ],
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                      items: 'Fruits,Vegetables,Grains,Dairy,Herbs,Poultry'.split(',').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => category = v!),
                    ),
                    const SizedBox(height: 14),
                    TextField(controller: productController, decoration: const InputDecoration(labelText: 'Product Name', prefixIcon: Icon(Icons.eco), hintText: 'e.g. Organic Tomatoes')),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price per Kg', prefixIcon: Icon(Icons.currency_rupee)))),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qty (Kg)', prefixIcon: Icon(Icons.inventory)))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(controller: descriptionController, maxLines: 3, decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.description), alignLabelWithHint: true)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : publishProduct,
                        icon: isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.publish),
                        label: Text(isLoading ? 'Publishing...' : 'Publish Product'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildMyProducts(BuildContext context, List<Product> myProducts) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text('My Products (${myProducts.length})', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ),
          ...myProducts.map((product) {
            final imageUrl = AppImages.forProduct(product.productName);
            final isLowStock = product.quantity < 20;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: AppTheme.glassEffect(),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(imageUrl: imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('₹${product.price}/kg', style: TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                                  const SizedBox(width: 8),
                                  Text('${product.quantity} kg', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLowStock ? AppTheme.offerRed.withValues(alpha: 0.1) : AppTheme.successGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isLowStock ? 'Low Stock' : 'Live',
                                style: TextStyle(
                                  color: isLowStock ? AppTheme.offerRed : AppTheme.successGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(product.category, style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: (myProducts.indexOf(product) * 80).ms + 300.ms).slideX(begin: 0.2);
          }),
        ],
      ),
    );
  }
}
