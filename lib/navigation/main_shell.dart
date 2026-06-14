import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_animate/flutter_animate.dart';
import '../services/app_data.dart';
import '../theme/app_theme.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  final List<Widget> screens;

  const MainShell({
    super.key,
    this.initialIndex = 0,
    required this.screens,
  });

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late int _currentIndex;

  int get cartCount => AppData.cart.fold(0, (sum, item) => sum + (item["qty"] as int));

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchToCart() {
    setState(() => _currentIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF1C1C1E) : Colors.white).withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.white).withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppTheme.forestGreen.withValues(alpha: 0.04),
                    blurRadius: 60,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (i) {
                  final isSelected = _currentIndex == i;
                  final icons = [
                    Icons.home_outlined,
                    Icons.grid_view_outlined,
                    Icons.shopping_cart_outlined,
                    Icons.store_outlined,
                    Icons.person_outline,
                  ];
                  final activeIcons = [
                    Icons.home_rounded,
                    Icons.grid_view_rounded,
                    Icons.shopping_cart_rounded,
                    Icons.store_rounded,
                    Icons.person_rounded,
                  ];
                  final labels = ["Home", "Shop", "Cart", "Sell", "Profile"];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentIndex = i),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: isSelected ? 16 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.forestGreen.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: 200.ms,
                              transitionBuilder: (child, anim) => ScaleTransition(
                                scale: anim,
                                child: child,
                              ),
                              child: i == 2
                                  ? badges.Badge(
                                      key: ValueKey("cart_$cartCount"),
                                      showBadge: cartCount > 0,
                                      badgeStyle: badges.BadgeStyle(
                                        badgeColor: AppTheme.cartOrange,
                                        padding: const EdgeInsets.all(4),
                                        shape: badges.BadgeShape.circle,
                                      ),
                                      badgeContent: Text(
                                        "$cartCount",
                                        style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700),
                                      ),
                                      child: Icon(
                                        isSelected ? activeIcons[i] : icons[i],
                                        size: 24,
                                        color: isSelected ? AppTheme.forestGreen : AppTheme.textSecondary,
                                      ),
                                    )
                                  : Icon(
                                      isSelected ? activeIcons[i] : icons[i],
                                      size: 24,
                                      color: isSelected ? AppTheme.forestGreen : AppTheme.textSecondary,
                                    ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              Text(
                                labels[i],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.forestGreen,
                                ),
                              ).animate().fadeIn(duration: 200.ms),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
