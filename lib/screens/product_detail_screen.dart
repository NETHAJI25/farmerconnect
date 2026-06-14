import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/image_constants.dart';
import 'available_farmers_screen.dart';
import 'basket_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productName;

  const ProductDetailScreen({super.key, required this.productName});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedQty = 1;
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  List<Product> get _sellers =>
      AppData.products.where((p) => p.productName == widget.productName).toList();

  Product? get _cheapest => _sellers.isEmpty ? null : _sellers.reduce((a, b) => a.price < b.price ? a : b);

  @override
  Widget build(BuildContext context) {
    final imageUrl = AppImages.forProduct(widget.productName);
    final product = _cheapest;

    return Scaffold(
      body: product == null
          ? _buildNotFound(context, imageUrl)
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildImageSliver(context, imageUrl, product),
                SliverToBoxAdapter(child: _buildProductInfo(context, product)),
                SliverToBoxAdapter(child: _buildFarmerCard(context, product)),
                SliverToBoxAdapter(child: _buildPricingSection(context, product)),
                SliverToBoxAdapter(child: _buildSellersRow(context)),
                SliverToBoxAdapter(child: _buildFreshnessSection(context)),
                SliverToBoxAdapter(child: _buildReviewsSection(context)),
                SliverToBoxAdapter(child: _buildNutritionSection(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      bottomNavigationBar: product == null ? null : _buildStickyBar(context, product),
    );
  }

  Widget _buildNotFound(BuildContext context, String imageUrl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(imageUrl: imageUrl, width: 140, height: 140, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          const Text('Product Not Available', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('${widget.productName} is currently out of stock', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSliver(BuildContext context, String imageUrl, Product product) {
    final galleryImages = [
      imageUrl,
      AppImages.farmer1,
      AppImages.vegetables,
    ];
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView(
              onPageChanged: (i) => setState(() => _currentImageIndex = i),
              children: galleryImages.map((url) => CachedNetworkImage(
                imageUrl: url,
                width: double.infinity,
                height: 380,
                fit: BoxFit.cover,
              )).toList(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(galleryImages.length, (i) {
                    return Container(
                      width: _currentImageIndex == i ? 24 : 8,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: _currentImageIndex == i ? Colors.white : Colors.white.withValues(alpha: 0.4),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.offerRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('20% OFF', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(product.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.forestGreen)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.harvestAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco, size: 12, color: AppTheme.harvestAmber),
                    SizedBox(width: 4),
                    Text('Organic', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.harvestAmber)),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppTheme.harvestAmber),
                  const SizedBox(width: 4),
                  Text('4.8', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(' (124)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.productName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.1)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('₹${product.price}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.forestGreen)),
              const SizedBox(width: 4),
              const Text('/kg', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(width: 10),
              Text('₹${(product.price * 1.25).toInt()}', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, decoration: TextDecoration.lineThrough)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('20% off', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.successGreen)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
              children: [
                const TextSpan(text: 'Freshly harvested '),
                TextSpan(text: widget.productName.toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const TextSpan(text: ' sourced directly from local farms. Picked at peak ripeness for maximum flavor and nutrition.'),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildFarmerCard(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(AppImages.farmer1),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(product.farmerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, size: 16, color: AppTheme.forestGreen),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 13, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(child: Text(product.address, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.forestGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 13, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Verified', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildPricingSection(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.forestGreen.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _selectedQty = (_selectedQty > 1 ? _selectedQty - 1 : 1)),
                                  child: Container(padding: const EdgeInsets.all(10), child: Icon(Icons.remove, size: 18, color: _selectedQty > 1 ? AppTheme.forestGreen : Colors.grey.shade300)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('$_selectedQty kg', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedQty = _selectedQty + 1),
                                  child: Container(padding: const EdgeInsets.all(10), child: const Icon(Icons.add, size: 18, color: AppTheme.forestGreen)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.forestGreen.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text('₹${(product.price * _selectedQty).toInt()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.forestGreen)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildSellersRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.harvestAmber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.store, color: AppTheme.harvestAmber, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_sellers.length} sellers available', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text('Compare prices and choose the best deal', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AvailableFarmersScreen(productName: widget.productName))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                      ],
                    ),
                  ).animate().shakeX().then(delay: 500.ms),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildFreshnessSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Freshness & Quality', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 14),
                _FreshnessRow('Harvested', '2 days ago', AppImages.farmer1, 0.9),
                const SizedBox(height: 10),
                _FreshnessRow('Farm to Table', '24 hrs', AppImages.farmer2, 0.8),
                const SizedBox(height: 10),
                _FreshnessRow('Shelf Life', '5-7 days', AppImages.farmer3, 0.7),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Customer Reviews', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const Spacer(),
                    const Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppTheme.harvestAmber),
                        SizedBox(width: 4),
                        Text('4.8', style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _ReviewTile(
                  'Priya S.', 'Amazing quality! Fresh and crisp. Will order again.', AppImages.farmer3, 5.0,
                ),
                const SizedBox(height: 12),
                _ReviewTile(
                  'Rahul K.', 'Best price in the market. Farmer was very responsive.', AppImages.farmer2, 5.0,
                ),
                const SizedBox(height: 12),
                _ReviewTile(
                  'Anita M.', 'Freshly harvested and delivered on time. Highly recommend!', AppImages.farmer1, 4.0,
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildStickyBar(BuildContext context, Product product) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, -6))],
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      AppData.cart.add({'product': product, 'qty': _selectedQty});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to cart!'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.forestGreen,
                      side: const BorderSide(color: AppTheme.forestGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      AppData.cart.add({'product': product, 'qty': _selectedQty});
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BasketScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Buy Now • ₹${(product.price * _selectedQty).toInt()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3);
  }

  Widget _buildNutritionSection(BuildContext context) {
    final nutrition = [
      {"label": "Vitamin C", "value": "28mg", "score": 0.9, "color": AppTheme.harvestAmber},
      {"label": "Fiber", "value": "3.5g", "score": 0.85, "color": AppTheme.forestGreen},
      {"label": "Antioxidants", "value": "High", "score": 0.95, "color": AppTheme.successGreen},
      {"label": "Minerals", "value": "Rich", "score": 0.8, "color": AppTheme.limeAccent},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassEffect(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.monitor_heart, size: 18, color: AppTheme.forestGreen),
                    SizedBox(width: 8),
                    Text('Nutritional Value', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 14),
                ...nutrition.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 90, child: Text(n["label"] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: n["score"] as double,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(n["color"] as Color),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: Text(n["value"] as String, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }
}

class _FreshnessRow extends StatelessWidget {
  final String label;
  final String value;
  final String imageUrl;
  final double score;

  const _FreshnessRow(this.label, this.value, this.imageUrl, this.score);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(imageUrl: imageUrl, width: 36, height: 36, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: score,
                strokeWidth: 3,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  score > 0.8 ? AppTheme.successGreen : score > 0.5 ? AppTheme.harvestAmber : AppTheme.offerRed,
                ),
              ),
              Text('${(score * 100).toInt()}%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String name;
  final String review;
  final String imageUrl;
  final double rating;

  const _ReviewTile(this.name, this.review, this.imageUrl, this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 18, backgroundImage: CachedNetworkImageProvider(imageUrl)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(width: 6),
                  Row(
                    children: List.generate(5, (i) => Icon(i < rating.toInt() ? Icons.star : Icons.star_border, size: 12, color: AppTheme.harvestAmber)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(review, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}
