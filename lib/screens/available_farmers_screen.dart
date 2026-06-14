import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/supabase_service.dart';
import '../services/app_data.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../utils/image_constants.dart';

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
    final productImage = AppImages.forProduct(productName);

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: FutureBuilder(
        future: getFarmers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildShimmerLoading();
          }

          final farmers = snapshot.data as List;

          if (farmers.isEmpty) {
            final localFarmers = AppData.products.where((p) => p.productName == productName).toList();
            if (localFarmers.isEmpty) {
              return _buildEmptyState(context, productImage);
            }
            return _buildLocalContent(context, localFarmers, productImage);
          }

          double lowestPrice = farmers
              .map((e) => (e['price'] as num).toDouble())
              .reduce((a, b) => a < b ? a : b);

          return Column(
            children: [
              _buildHeader(context, farmers, productImage, lowestPrice),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: farmers.length,
                  itemBuilder: (context, index) {
                    final farmer = farmers[index];
                    final isLowest = (farmer['price'] as num).toDouble() == lowestPrice;
                    final farmerImg = AppImages.farmerImages[index % AppImages.farmerImages.length];
                    return _FarmerCard(farmer: farmer, isLowest: isLowest, farmerImg: farmerImg, index: index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLocalContent(BuildContext context, List<Product> localFarmers, String productImage) {
    double lowestPrice = localFarmers.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    return Column(
      children: [
        _buildHeaderLocal(context, localFarmers, productImage, lowestPrice),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: localFarmers.length,
            itemBuilder: (context, index) {
              final farmer = localFarmers[index];
              final isLowest = farmer.price == lowestPrice;
              final farmerImg = AppImages.farmerImages[index % AppImages.farmerImages.length];
              return _LocalFarmerCard(farmer: farmer, isLowest: isLowest, farmerImg: farmerImg, index: index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, List farmers, String productImage, double lowestPrice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.forestGreen.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: productImage,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text("${farmers.length} farmers available", style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Text(
              "₹${lowestPrice.toInt()}/kg",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLocal(BuildContext context, List<Product> farmers, String productImage, double lowestPrice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.forestGreen.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: productImage,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text("${farmers.length} farmers available", style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Text(
              "₹${lowestPrice.toInt()}/kg",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.grey.shade200),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 120, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 80, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String productImage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: productImage,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          const Text("No Farmers Available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Currently no farmers selling $productName", style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Go back"),
          ),
        ],
      ),
    );
  }
}

class _FarmerCard extends StatelessWidget {
  final dynamic farmer;
  final bool isLowest;
  final String farmerImg;
  final int index;

  const _FarmerCard({required this.farmer, required this.isLowest, required this.farmerImg, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [AppTheme.softShadow()],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(farmerImg),
                      onBackgroundImageError: (_, _) {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.forestGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppTheme.forestGreen),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(farmer['farmer_name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(width: 6),
                              if (isLowest)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.harvestAmber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, size: 11, color: AppTheme.harvestAmber),
                                      SizedBox(width: 2),
                                      Text("Best Price", style: TextStyle(fontSize: 9, color: AppTheme.harvestAmber, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _InfoBadge(Icons.currency_rupee, "${farmer['price']}/kg", AppTheme.forestGreen),
                              const SizedBox(width: 6),
                              _InfoBadge(Icons.inventory, "${farmer['quantity']} kg", AppTheme.textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.forestGreen,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                            onPressed: () {
                              AppData.basket.clear();
                              AppData.basket.add({
                                "product": Product(
                                  farmerName: farmer['farmer_name'],
                                  phone: farmer['phone'],
                                  address: farmer['address'],
                                  category: farmer['category'],
                                  productName: farmer['product_name'],
                                  price: (farmer['price'] as num).toDouble(),
                                  quantity: farmer['quantity'],
                                ),
                                "qty": 1,
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const BasketScreen()));
                            },
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text("Add", style: TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text(farmer['phone'], style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(farmer['address'], style: TextStyle(fontSize: 12, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1);
  }
}

class _LocalFarmerCard extends StatelessWidget {
  final Product farmer;
  final bool isLowest;
  final String farmerImg;
  final int index;

  const _LocalFarmerCard({required this.farmer, required this.isLowest, required this.farmerImg, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [AppTheme.softShadow()],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(farmerImg),
                      onBackgroundImageError: (_, _) {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.forestGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppTheme.forestGreen),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(farmer.farmerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(width: 6),
                              if (isLowest)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.harvestAmber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, size: 11, color: AppTheme.harvestAmber),
                                      SizedBox(width: 2),
                                      Text("Best Price", style: TextStyle(fontSize: 9, color: AppTheme.harvestAmber, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _InfoBadge(Icons.currency_rupee, "${farmer.price}/kg", AppTheme.forestGreen),
                              const SizedBox(width: 6),
                              _InfoBadge(Icons.inventory, "${farmer.quantity} kg", AppTheme.textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.forestGreen,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                            onPressed: () {
                              AppData.basket.clear();
                              AppData.basket.add({
                                "product": farmer,
                                "qty": 1,
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const BasketScreen()));
                            },
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text("Add", style: TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text(farmer.phone, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(farmer.address, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1);
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
