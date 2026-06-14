import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/app_data.dart';
import '../models/product.dart';
import '../utils/image_constants.dart';
import '../widgets/lottie_animations.dart';
import 'product_detail_screen.dart';

class BuyProductsScreen extends StatefulWidget {
  const BuyProductsScreen({super.key});

  @override
  State<BuyProductsScreen> createState() => _BuyProductsScreenState();
}

class _BuyProductsScreenState extends State<BuyProductsScreen> {
  final searchController = TextEditingController();
  final _focusNode = FocusNode();
  String searchQuery = "";
  bool _showSuggestions = false;

  final _trendingSearches = [
    "Fresh Mangoes", "Organic Tomatoes", "Basmati Rice", "Fresh Milk", "Strawberries", "Green Chillies",
  ];

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return AppData.products;
    return AppData.products.where((p) =>
      p.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
      p.farmerName.toLowerCase().contains(searchQuery.toLowerCase()) ||
      p.category.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  List<String> get _suggestions {
    if (searchQuery.isEmpty) return _trendingSearches;
    return _trendingSearches.where((s) => s.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _showSuggestions = _focusNode.hasFocus && searchQuery.isEmpty);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Products"),
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          if (_showSuggestions && searchQuery.isEmpty) _buildSuggestions(context),
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _ProductSearchTile(product: product, index: index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
              border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.06)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField(
              controller: searchController,
              focusNode: _focusNode,
              onChanged: (v) {
                setState(() {
                  searchQuery = v;
                  _showSuggestions = v.isEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by product, farmer, or category...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = "";
                            _showSuggestions = true;
                          });
                        },
                      ),
                    Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.forestGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.mic, color: AppTheme.forestGreen, size: 18),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                border: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildSuggestions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.softShadow(blur: 30, y: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text("Trending Searches", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          ..._trendingSearches.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                searchController.text = s;
                setState(() {
                  searchQuery = s;
                  _showSuggestions = false;
                });
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: AppImages.forProduct(s),
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(s, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  Icon(Icons.arrow_upward, size: 14, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                ],
              ),
            ),
          )),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.05);
  }

  Widget _buildEmptyState() {
    if (searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LottieAnimation(url: AppAnimations.agriculture, size: 140),
            const SizedBox(height: 16),
            const Text("Start searching", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text("Find fresh farm products", style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No results found", style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Text("Try a different search term", style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ProductSearchTile extends StatelessWidget {
  final Product product;
  final int index;

  const _ProductSearchTile({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageUrl = AppImages.forProduct(product.productName);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productName: product.productName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppTheme.softShadow()],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        width: 64, height: 64,
                        color: AppTheme.forestGreen.withValues(alpha: 0.08),
                        child: const Icon(Icons.eco, color: AppTheme.forestGreen, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 13, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Text(product.farmerName, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.forestGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(product.category, style: const TextStyle(fontSize: 10, color: AppTheme.forestGreen, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("₹${product.price}/kg", style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chevron_right, color: AppTheme.forestGreen, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: 0.1);
  }
}
