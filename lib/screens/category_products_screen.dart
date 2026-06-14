import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/supabase_service.dart';
import '../services/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/image_constants.dart';
import '../widgets/lottie_animations.dart';
import 'product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  bool isGrid = true;
  String sortBy = "name";
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => isGrid = !isGrid),
          ),
        ],
      ),
      body: FutureBuilder(
        future: SupabaseService.supabase
            .from('products')
            .select()
            .eq('category', widget.category),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildShimmerLoading();
          }
          final data = snapshot.data as List;
          if (data.isEmpty) {
            final localProducts = AppData.products.where((p) => p.category == widget.category).toList();
            if (localProducts.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildLocalContent(context, localProducts);
          }

          final uniqueProducts = data.map((e) => e['product_name']).toSet().toList();

          return Column(
            children: [
              _buildSearchBar(context),
              _buildFilterBar(context, uniqueProducts.length),
              Expanded(
                child: isGrid ? _buildGrid(data, uniqueProducts) : _buildList(data, uniqueProducts),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLocalContent(BuildContext context, List products) {
    final uniqueNames = products.map((p) => p.productName).toSet().toList();
    return Column(
      children: [
        _buildSearchBar(context),
        _buildFilterBar(context, uniqueNames.length),
        Expanded(
          child: isGrid ? _buildLocalGrid(products, uniqueNames) : _buildLocalList(products, uniqueNames),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: "Search in ${widget.category}...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      )
                    : null,
                border: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Text("$count products", style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortBy,
                icon: const Icon(Icons.sort, size: 20),
                dropdownColor: Theme.of(context).colorScheme.surface,
                items: const [
                  DropdownMenuItem(value: "name", child: Text("Name", style: TextStyle(fontWeight: FontWeight.w500))),
                  DropdownMenuItem(value: "price_low", child: Text("Price: Low-High", style: TextStyle(fontWeight: FontWeight.w500))),
                  DropdownMenuItem(value: "price_high", child: Text("Price: High-Low", style: TextStyle(fontWeight: FontWeight.w500))),
                ],
                onChanged: (v) => setState(() => sortBy = v!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List data, List uniqueProducts) {
    var filtered = uniqueProducts.where((n) {
      if (_searchQuery.isEmpty) return true;
      return (n as String).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final productName = filtered[index] as String;
        final farmerCount = data.where((p) => p['product_name'] == productName).length;
        final firstProduct = data.firstWhere((p) => p['product_name'] == productName);
        final price = firstProduct['price'];
        final imageUrl = AppImages.forProduct(productName);

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productName: productName))),
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
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            width: 72, height: 72,
                            color: AppTheme.forestGreen.withValues(alpha: 0.08),
                            child: const Icon(Icons.image, color: AppTheme.forestGreen, size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text("$farmerCount farmers", style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.forestGreen.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "₹$price/kg",
                                    style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
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
          ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: 0.1),
        );
      },
    );
  }

  List _sortData(List data, List uniqueProducts) {
    final sorted = List.from(uniqueProducts);
    switch (sortBy) {
      case "price_low":
        sorted.sort((a, b) {
          final pa = (data.firstWhere((p) => p['product_name'] == a)['price'] as num).toDouble();
          final pb = (data.firstWhere((p) => p['product_name'] == b)['price'] as num).toDouble();
          return pa.compareTo(pb);
        });
      case "price_high":
        sorted.sort((a, b) {
          final pa = (data.firstWhere((p) => p['product_name'] == a)['price'] as num).toDouble();
          final pb = (data.firstWhere((p) => p['product_name'] == b)['price'] as num).toDouble();
          return pb.compareTo(pa);
        });
    }
    return sorted;
  }

  Widget _buildGrid(List data, List uniqueProducts) {
    var sorted = _sortData(data, uniqueProducts);
    var filtered = sorted.where((n) {
      if (_searchQuery.isEmpty) return true;
      return (n as String).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final productName = filtered[index] as String;
        final firstProduct = data.firstWhere((p) => p['product_name'] == productName);
        final price = firstProduct['price'];
        final farmerCount = data.where((p) => p['product_name'] == productName).length;
        final imageUrl = AppImages.forProduct(productName);

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productName: productName))),
          child: Container(
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
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              color: AppTheme.forestGreen.withValues(alpha: 0.08),
                              child: const Icon(Icons.image, color: AppTheme.forestGreen, size: 32),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text("$farmerCount farmers", style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹$price",
                            style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Text("/kg", style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.forestGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (index * 60).ms).scale(begin: const Offset(0.9, 0.9)),
        );
      },
    );
  }

  Widget _buildLocalList(List products, List uniqueNames) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: uniqueNames.length,
      itemBuilder: (context, index) {
        final productName = uniqueNames[index];
        final matching = products.where((p) => p.productName == productName).toList();
        final price = matching.first.price;
        final imageUrl = AppImages.forProduct(productName);

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productName: productName))),
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
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 72, height: 72,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            width: 72, height: 72,
                            color: AppTheme.forestGreen.withValues(alpha: 0.08),
                            child: const Icon(Icons.image, color: AppTheme.forestGreen, size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text("${matching.length} farmers", style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.forestGreen.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "₹$price/kg",
                                    style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
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
          ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: 0.1),
        );
      },
    );
  }

  Widget _buildLocalGrid(List products, List uniqueNames) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: uniqueNames.length,
      itemBuilder: (context, index) {
        final productName = uniqueNames[index];
        final matching = products.where((p) => p.productName == productName).toList();
        final price = matching.first.price;
        final imageUrl = AppImages.forProduct(productName);

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productName: productName))),
          child: Container(
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
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              color: AppTheme.forestGreen.withValues(alpha: 0.08),
                              child: const Icon(Icons.image, color: AppTheme.forestGreen, size: 32),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text("${matching.length} farmers", style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₹$price", style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                          const Text("/kg", style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.forestGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (index * 60).ms).scale(begin: const Offset(0.9, 0.9)),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
        itemBuilder: (ctx, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
                        stops: const [0, 0.5, 1],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 4),
                Container(height: 10, width: 60, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LottieAnimation(url: AppAnimations.emptyBox, size: 150),
          const SizedBox(height: 16),
          const Text("No products yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Products in ${widget.category} will appear here", style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Browse other categories"),
          ),
        ],
      ),
    );
  }
}
