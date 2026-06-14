import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import '../services/app_data.dart';
import '../utils/image_constants.dart';
import '../widgets/shimmer_loading.dart';
import 'category_products_screen.dart';
import 'buy_products_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  int _heroIndex = 0;
  final _pageController = PageController();
  final _categoryScrollController = ScrollController();
  Timer? _dealTimer;
  int _dealHours = 8;
  int _dealMinutes = 45;
  int _dealSeconds = 30;

  final _heroSlides = [
    {"image": AppImages.banner1, "title": "Fresh Vegetables", "subtitle": "Straight from farm to table", "tag": "Organic 100%"},
    {"image": AppImages.banner2, "title": "Seasonal Fruits", "subtitle": "Nature's sweetest harvest", "tag": "Fresh Picked"},
    {"image": AppImages.banner3, "title": "Farm Fresh Dairy", "subtitle": "Pure & unprocessed", "tag": "Farm Direct"},
  ];

  final _quickChips = ["Organic", "Fresh Today", "Nearby Farms", "Offers", "Fast Delivery", "Seasonal"];

  final _categories = [
    {"name": "Fruits", "img": AppImages.fruits, "count": "24+", "eta": "30 min", "color": const Color(0xFFFF6B35)},
    {"name": "Vegetables", "img": AppImages.vegetables, "count": "36+", "eta": "25 min", "color": const Color(0xFF2E7D32)},
    {"name": "Grains", "img": AppImages.grains, "count": "18+", "eta": "35 min", "color": const Color(0xFF8D6E63)},
    {"name": "Dairy", "img": AppImages.dairy, "count": "12+", "eta": "20 min", "color": const Color(0xFF42A5F5)},
    {"name": "Herbs", "img": AppImages.herbs, "count": "8+", "eta": "25 min", "color": const Color(0xFF66BB6A)},
    {"name": "Poultry", "img": AppImages.poultry, "count": "15+", "eta": "30 min", "color": const Color(0xFFFFA726)},
  ];

  final _dealProducts = [
    {"name": "Organic Tomatoes", "price": "₹28", "original": "₹45", "discount": "-38%", "image": AppImages.vegetables, "stock": 67},
    {"name": "Fresh Mangoes", "price": "₹59", "original": "₹99", "discount": "-40%", "image": AppImages.fruits, "stock": 34},
    {"name": "Basmati Rice", "price": "₹79", "original": "₹110", "discount": "-28%", "image": AppImages.grains, "stock": 82},
  ];

  final _farmers = [
    {"name": "Ramesh's Farm", "location": "Coimbatore", "rating": 4.8, "products": 12, "img": AppImages.farmer1, "tag": "Premium"},
    {"name": "Green Valley", "location": "Ooty", "rating": 4.6, "products": 8, "img": AppImages.farmer2, "tag": "Certified"},
    {"name": "Priya's Produce", "location": "Erode", "rating": 4.9, "products": 15, "img": AppImages.farmer3, "tag": "Top Rated"},
    {"name": "Kumar's Grains", "location": "Thanjavur", "rating": 4.5, "products": 6, "img": AppImages.farmer4, "tag": "Organic"},
  ];

  @override
  void initState() {
    super.initState();
    _startHeroAutoPlay();
    _startDealTimer();
  }

  void _startDealTimer() {
    _dealTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_dealSeconds > 0) {
          _dealSeconds--;
        } else {
          _dealSeconds = 59;
          if (_dealMinutes > 0) {
            _dealMinutes--;
          } else {
            _dealMinutes = 59;
            if (_dealHours > 0) {
              _dealHours--;
            }
          }
        }
      });
    });
  }

  void _startHeroAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _heroIndex = (_heroIndex + 1) % _heroSlides.length);
        _pageController.animateToPage(_heroIndex, duration: 800.ms, curve: Curves.easeInOutCubic);
        _startHeroAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _dealTimer?.cancel();
    _pageController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const ShimmerGrid()
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 1));
                setState(() => _isLoading = false);
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeroSliver(context),
                  SliverToBoxAdapter(child: _buildSearchBar(context)),
                  SliverToBoxAdapter(child: _buildLocationChip(context)),
                  SliverToBoxAdapter(child: _buildQuickChips(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: _buildSectionHeader("Categories", "View All →"),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildCategoryGrid(context)),
                  SliverToBoxAdapter(child: _buildDealsHeader(context)),
                  SliverToBoxAdapter(child: _buildDealsSection(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: _buildSectionHeader("Featured Farmers", "View All →"),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildFarmersRow(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: _buildSectionHeader("Recommended for You", "View All →"),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildProductsCarousel(context)),
                  SliverToBoxAdapter(child: _buildAiRecommendations(context)),
                  SliverToBoxAdapter(child: _buildWhyFarmConnect(context)),
                  SliverToBoxAdapter(child: _buildTestimonials(context)),
                  SliverToBoxAdapter(child: _buildFarmStories(context)),
                  SliverToBoxAdapter(child: _buildDeliveryCoverage(context)),
                  SliverToBoxAdapter(child: _buildMobileAppPromo(context)),
                  SliverToBoxAdapter(child: _buildFooter(context)),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
    );
  }

  Widget _buildHeroSliver(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 460,
      pinned: false,
      floating: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            AnimatedSwitcher(
              duration: 800.ms,
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              child: CachedNetworkImage(
                key: ValueKey(_heroIndex),
                imageUrl: _heroSlides[_heroIndex]["image"] as String,
                width: double.infinity,
                height: 460,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.harvestAmber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _heroSlides[_heroIndex]["tag"] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                    ),
                  ).animate().fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 12),
                  Text(
                    _heroSlides[_heroIndex]["title"] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700, height: 1.1),
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  Text(
                    _heroSlides[_heroIndex]["subtitle"] as String,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 16),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Text("Shop Now", style: TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w700, fontSize: 15)),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, color: AppTheme.forestGreen, size: 18),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                      ).animate().fadeIn(delay: 350.ms).slideX(begin: -0.2),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _heroSlides.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 4,
                      expansionFactor: 3,
                      dotColor: Colors.white.withValues(alpha: 0.3),
                      activeDotColor: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
            Positioned(
              top: 60,
              right: 20,
              child: Column(
                children: [
                  _buildHeroTrustBadge(Icons.local_shipping, "25 min", "Delivery"),
                  const SizedBox(height: 8),
                  _buildHeroTrustBadge(Icons.eco, "100%", "Fresh"),
                  const SizedBox(height: 8),
                  _buildHeroTrustBadge(Icons.verified, "10k+", "Happy"),
                ],
              ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.3),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    const Text("Coimbatore", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud, color: Colors.white, size: 10),
                          SizedBox(width: 2),
                          Text("28°C", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Hero(
        tag: "searchBar",
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.08), blurRadius: 30, offset: const Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                  border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.06)),
                ),
                child: TextField(
                  readOnly: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuyProductsScreen())),
                  decoration: InputDecoration(
                    hintText: "Search fresh farm products...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mic, color: Colors.grey.shade400, size: 20),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.forestGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(Icons.tune, color: Colors.white, size: 18),
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
        ),
      ),
    );
  }

  Widget _buildLocationChip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 13, color: AppTheme.forestGreen),
                SizedBox(width: 4),
                Text("Deliver to: Coimbatore - 641001", style: TextStyle(fontSize: 11, color: AppTheme.forestGreen, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 12, color: AppTheme.successGreen),
                SizedBox(width: 4),
                Text("25 min delivery", style: TextStyle(fontSize: 11, color: AppTheme.successGreen, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChips(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickChips.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final icons = [
              Icons.eco, Icons.wb_sunny, Icons.location_on, Icons.local_offer, Icons.flash_on, Icons.calendar_today,
            ];
            final isSelected = i == 0;
            return AnimatedContainer(
              duration: 200.ms,
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.forestGreen : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? AppTheme.forestGreen : AppTheme.forestGreen.withValues(alpha: 0.15),
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons[i], size: 14, color: isSelected ? Colors.white : AppTheme.forestGreen),
                  const SizedBox(width: 6),
                  Text(
                    _quickChips[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (i * 50).ms).slideX(begin: 0.2);
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(foregroundColor: AppTheme.forestGreen),
          child: Text(action, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: cat["name"] as String))),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 6)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: cat["img"] as String,
                      width: 140,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat["name"] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text("${cat["count"]} items", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                                child: Text("${cat["eta"]}", style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: 0.3),
          );
        },
      ),
    );
  }

  Widget _buildDealsSection(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _dealProducts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final deal = _dealProducts[i];
          return Container(
            width: 180,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [AppTheme.softShadow()],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Stack(
                    children: [
                      CachedNetworkImage(imageUrl: deal["image"] as String, width: 180, height: 110, fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.offerRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(deal["discount"] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deal["name"] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(deal["price"] as String, style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w700, fontSize: 18)),
                          const SizedBox(width: 6),
                          Text(deal["original"] as String, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (deal["stock"] as int) / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.harvestAmber,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text("${deal["stock"]}%", style: TextStyle(fontSize: 9, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.3);
        },
      ),
    );
  }

  Widget _buildFarmersRow(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _farmers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final f = _farmers[i];
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [AppTheme.softShadow()],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Stack(
                      children: [
                        CachedNetworkImage(imageUrl: f["img"] as String, width: 200, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.forestGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified, color: Colors.white, size: 10),
                                const SizedBox(width: 3),
                                Text(f["tag"] as String, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f["name"] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 11, color: AppTheme.harvestAmber),
                                const SizedBox(width: 2),
                                Text("${f["rating"]}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                                const SizedBox(width: 6),
                                Icon(Icons.location_on, size: 10, color: AppTheme.textSecondary),
                                const SizedBox(width: 2),
                                Expanded(child: Text(f["location"] as String, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.forestGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_forward, color: AppTheme.forestGreen, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.3);
        },
      ),
    );
  }

  Widget _buildProductsCarousel(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppData.products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final product = AppData.products[index];
          final imageUrl = AppImages.forProduct(product.productName);
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productName: product.productName))),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [AppTheme.softShadow()],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Hero(
                      tag: "product_${product.productName}",
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 160,
                        height: 140,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(color: AppTheme.forestGreen.withValues(alpha: 0.05), height: 140),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppTheme.forestGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                              child: Text(product.category, style: const TextStyle(fontSize: 9, color: AppTheme.forestGreen, fontWeight: FontWeight.w600)),
                            ),
                            const Spacer(),
                            Text("₹${product.price}", style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                            const Text("/kg", style: TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.forestGreen,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_checkout, size: 14),
                                SizedBox(width: 4),
                                Text("Add", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.3);
        },
      ),
    );
  }

  Widget _buildDealsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Today's Farm Deals", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.offerRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 12, color: AppTheme.offerRed),
                          SizedBox(width: 2),
                          Text("LIVE", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.offerRed)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text("Limited time offers", style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.offerRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 13, color: AppTheme.offerRed),
                const SizedBox(width: 4),
                Text(
                  '${_dealHours.toString().padLeft(2, "0")}:${_dealMinutes.toString().padLeft(2, "0")}:${_dealSeconds.toString().padLeft(2, "0")}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.offerRed, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppTheme.forestGreen, padding: EdgeInsets.zero),
            child: const Text("View All →", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyFarmConnect(BuildContext context) {
    final features = [
      {"icon": Icons.eco, "label": "100% Fresh", "desc": "Straight from farm", "color": AppTheme.successGreen},
      {"icon": Icons.agriculture, "label": "Direct from Farmers", "desc": "No middlemen", "color": AppTheme.forestGreen},
      {"icon": Icons.local_shipping, "label": "Free Delivery", "desc": "On orders above ₹199", "color": AppTheme.harvestAmber},
      {"icon": Icons.verified, "label": "Secure Payment", "desc": "100% protected", "color": AppTheme.earthBrown},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        children: [
          Text("Why FarmConnect", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text("Freshness you can trust", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 20),
          Row(
            children: features.map((f) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (f["color"] as Color).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: (f["color"] as Color).withValues(alpha: 0.12)),
                        ),
                        child: Icon(f["icon"] as IconData, color: f["color"] as Color, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(f["label"] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11), textAlign: TextAlign.center),
                      const SizedBox(height: 2),
                      Text(f["desc"] as String, style: TextStyle(fontSize: 9, color: AppTheme.textSecondary), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildTestimonials(BuildContext context) {
    final testimonials = [
      {"name": "Priya S.", "location": "Coimbatore", "text": "The freshest vegetables I've ever bought online. Direct from farm makes all the difference!", "rating": 5, "img": AppImages.farmer3},
      {"name": "Rahul K.", "location": "Erode", "text": "FarmConnect helped me find local farmers selling organic produce at amazing prices.", "rating": 5, "img": AppImages.farmer2},
      {"name": "Anita M.", "location": "Ooty", "text": "Delivery is incredibly fast. The mangoes tasted like they were just picked from the tree!", "rating": 4, "img": AppImages.farmer1},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What Our Customers Say", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text("Trusted by thousands", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: testimonials.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final t = testimonials[i];
                return Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [AppTheme.softShadow()],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 18, backgroundImage: CachedNetworkImageProvider(t["img"] as String)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(t["name"] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      Text(t["location"] as String, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (j) => Icon(j < (t["rating"] as int) ? Icons.star : Icons.star_border, size: 12, color: AppTheme.harvestAmber)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                t["text"] as String,
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.2);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAppPromo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.harvestAmber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.phone_android, color: AppTheme.harvestAmber, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Download Our App", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text("FarmFresh, anytime, anywhere", style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.forestGreen.withValues(alpha: 0.06),
                  AppTheme.forestGreen.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildPhoneMockup()),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: _buildAppDownloadInfo()),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildPhoneMockup() {
    return Container(
      width: 140,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.2), width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.forestGreen, Color(0xFF1B3A1B)],
        ),
        boxShadow: [AppTheme.softShadow(opacity: 0.15)],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 50,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 30),
                const SizedBox(height: 6),
                const Text("FarmConnect", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart, size: 10, color: Colors.white),
                      SizedBox(width: 4),
                      Text("Fresh App", style: TextStyle(color: Colors.white, fontSize: 8)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) => const Padding(
                    padding: EdgeInsets.only(right: 1),
                    child: Icon(Icons.star, size: 9, color: AppTheme.harvestAmber),
                  )),
                ),
                const SizedBox(height: 4),
                Text("4.8 ★", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 9)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.circle, size: 10, color: Colors.white24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDownloadInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.15)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download, size: 12, color: AppTheme.successGreen),
              SizedBox(width: 4),
              Text("50k+ Downloads", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.successGreen)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text("Get the full experience", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        Text("Order fresh produce, track deliveries, and connect with farmers on the go.",
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (i) => const Padding(
            padding: EdgeInsets.only(right: 2),
            child: Icon(Icons.star, size: 16, color: AppTheme.harvestAmber),
          )),
        ),
        const SizedBox(height: 2),
        Text("4.8 • 2,400+ reviews", style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF212121),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("GET IT ON", style: TextStyle(color: Colors.white70, fontSize: 7, fontWeight: FontWeight.w400)),
                        Text("Google Play", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_iphone, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Download on the", style: TextStyle(color: Colors.white70, fontSize: 7, fontWeight: FontWeight.w400)),
                        Text("App Store", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [AppTheme.softShadow(opacity: 0.08)],
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              ),
              child: CustomPaint(
                painter: _QRGridPainter(),
                size: const Size(44, 44),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Scan to download", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                SizedBox(height: 2),
                Text("Available on iOS & Android", style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.eco, color: AppTheme.forestGreen, size: 24),
              ),
              const SizedBox(width: 10),
              const Text("FarmConnect", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Fresh farm produce delivered directly from local farmers. No middlemen, just pure freshness.",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildFooterLink("Home", () {}),
              const SizedBox(width: 20),
              _buildFooterLink("Categories", () {}),
              const SizedBox(width: 20),
              _buildFooterLink("Farmers", () {}),
              const SizedBox(width: 20),
              _buildFooterLink("Sell", () {}),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildFooterLink("Privacy", () {}),
              const SizedBox(width: 20),
              _buildFooterLink("Terms", () {}),
              const SizedBox(width: 20),
              _buildFooterLink("Contact", () {}),
              const SizedBox(width: 20),
              _buildFooterLink("FAQ", () {}),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildSocialIcon(Icons.facebook),
              const SizedBox(width: 14),
              _buildSocialIcon(Icons.camera_alt_outlined),
              const SizedBox(width: 14),
              _buildSocialIcon(Icons.alternate_email),
              const SizedBox(width: 14),
              _buildSocialIcon(Icons.youtube_searched_for),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("© 2026 FarmConnect", style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
              Row(
                children: [
                  Icon(Icons.currency_rupee, size: 11, color: Colors.white.withValues(alpha: 0.4)),
                  const SizedBox(width: 4),
                  Text("Fresh from farm", style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 18),
    );
  }

  Widget _buildHeroTrustBadge(IconData icon, String value, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 9)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiRecommendations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Recommended for You", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.forestGreen, AppTheme.freshGreen]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 11, color: Colors.white),
                    SizedBox(width: 4),
                    Text("AI", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Personalized picks based on your preferences", style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: AppData.products.take(4).length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final p = AppData.products[i];
                final freshness = [0.95, 0.88, 0.92, 0.85][i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productName: p.productName))),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [AppTheme.softShadow()],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                          child: CachedNetworkImage(
                            imageUrl: AppImages.forProduct(p.productName),
                            width: 80,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(p.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text("₹${p.price}/kg", style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 28, height: 28,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: freshness,
                                            strokeWidth: 2,
                                            backgroundColor: Colors.grey.shade200,
                                            valueColor: AlwaysStoppedAnimation<Color>(freshness > 0.9 ? AppTheme.successGreen : AppTheme.harvestAmber),
                                          ),
                                          Text('${(freshness * 100).toInt()}', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text("Freshness", style: TextStyle(fontSize: 8, color: AppTheme.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: 0.2);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmStories(BuildContext context) {
    final stories = [
      {"name": "Ramesh's Organic Farm", "location": "Coimbatore", "story": "Third-generation farmer growing chemical-free vegetables", "img": AppImages.farmer1, "products": 12, "rating": 4.8},
      {"name": "Green Valley Farms", "location": "Ooty", "story": "Premium organic produce grown at high altitude", "img": AppImages.farmer2, "products": 8, "rating": 4.6},
      {"name": "Priya's Produce", "location": "Erode", "story": "Empowering women farmers with sustainable practices", "img": AppImages.farmer3, "products": 15, "rating": 4.9},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Farm Stories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.harvestAmber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Meet our farmers", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.harvestAmber)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Behind every harvest is a story", style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final s = stories[i];
                return Container(
                  width: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [AppTheme.softShadow()],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: Stack(
                            children: [
                              CachedNetworkImage(imageUrl: s["img"] as String, width: 240, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                                    colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10, left: 12,
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: AppTheme.harvestAmber),
                                    const SizedBox(width: 4),
                                    Text("${s["rating"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Icon(Icons.inventory, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                                    const SizedBox(width: 4),
                                    Text("${s["products"]} products", style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s["name"] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 10, color: AppTheme.textSecondary),
                                const SizedBox(width: 3),
                                Expanded(child: Text(s["location"] as String, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(s["story"] as String, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.2);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCoverage(BuildContext context) {
    final areas = [
      "Coimbatore", "Erode", "Ooty", "Salem", "Tirupur",
      "Madurai", "Chennai", "Bangalore", "Mysore", "Trichy",
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.map, color: AppTheme.forestGreen, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Delivery Coverage", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text("We deliver to 50+ cities", style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.15)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: AppTheme.successGreen),
                    SizedBox(width: 4),
                    Text("50+ Cities", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.successGreen)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.forestGreen.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.forestGreen, size: 16),
                    const SizedBox(width: 6),
                    Text("Tamil Nadu & Karnataka", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: areas.map((area) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.08)),
                      boxShadow: [AppTheme.softShadow(opacity: 0.03)],
                    ),
                    child: Text(area, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.forestGreen.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 14, color: AppTheme.forestGreen),
                      SizedBox(width: 6),
                      Text("Check delivery availability in your area", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.forestGreen)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QRGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / 8;
    final cellH = size.height / 8;

    final cells = [
      [0,0],[1,0],[2,0],[0,1],[0,2],
      [6,0],[7,0],[7,1],[7,2],[6,2],
      [0,6],[0,7],[1,7],[2,7],[2,6],
      [3,3],[5,4],[4,5],[6,6],[2,4],
      [5,2],[1,5],[4,3],[6,1],[3,6],
      [2,2],[5,5],[1,3],[6,4],[4,2],
    ];

    final fillPaint = Paint()
      ..color = AppTheme.forestGreen.withValues(alpha: 0.15);

    for (final c in cells) {
      canvas.drawRect(Rect.fromLTWH(c[0] * cellW + 1, c[1] * cellH + 1, cellW - 2, cellH - 2), fillPaint);
    }

    final borderPaint = Paint()
      ..color = AppTheme.forestGreen.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(const Rect.fromLTWH(1, 1, 19, 19), borderPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 20, 1, 19, 19), borderPaint);
    canvas.drawRect(Rect.fromLTWH(1, size.height - 20, 19, 19), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
