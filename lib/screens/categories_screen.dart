import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../utils/image_constants.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {"name": "Fruits", "icon": Icons.apple, "color": Color(0xFFFFF8E1), "count": "24+ Items"},
    {"name": "Vegetables", "icon": Icons.eco, "color": Color(0xFFE8F5E9), "count": "36+ Items"},
    {"name": "Grains", "icon": Icons.agriculture, "color": Color(0xFFE3F2FD), "count": "18+ Items"},
    {"name": "Dairy", "icon": Icons.water_drop, "color": Color(0xFFFCE4EC), "count": "12+ Items"},
    {"name": "Herbs", "icon": Icons.local_florist, "color": Color(0xFFF3E5F5), "count": "8+ Items"},
    {"name": "Poultry", "icon": Icons.egg, "color": Color(0xFFFFF3E0), "count": "15+ Items"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Browse by Category",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Find fresh farm products by category", style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + index * 80),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: _CategoryCard(
                      name: cat["name"],
                      icon: cat["icon"],
                      color: cat["color"],
                      count: cat["count"],
                      imageUrl: AppImages.forCategory(cat["name"]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(category: cat["name"]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String count;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  color: color.withValues(alpha: 0.3),
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 28, color: AppTheme.primaryGreen),
                  ),
                  const Spacer(),
                  Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
                  const SizedBox(height: 4),
                  Text(count, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
