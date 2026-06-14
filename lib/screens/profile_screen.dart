import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/current_user.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';
import 'change_password_screen.dart';
import 'about_app_screen.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = CurrentUser.name.isNotEmpty;
    return Scaffold(
      body: isLoggedIn ? _buildProfile(context) : _buildGuest(context),
    );
  }

  Widget _buildGuest(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.forestGreen.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.15), width: 2),
              ),
              child: const Icon(Icons.person_outline_rounded, size: 72, color: AppTheme.forestGreen),
            ).animate().fadeIn().scale(duration: 600.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            const Text('Welcome to FarmConnect',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Login to access your profile, orders, and track deliveries',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.4)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Login to Your Account'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Create an Account',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildProfileHeader(context, isDark),
          _buildStatsRow(context),
          _buildLoyaltyCard(context),
          _buildMenuSection(context, 'Account', [
            _MenuItemData(Icons.shopping_bag_outlined, 'My Orders', 'View order history & tracking', AppTheme.forestGreen, () {}),
            _MenuItemData(Icons.inventory_2_outlined, 'My Products', 'Products you have listed for sale', AppTheme.harvestAmber, () {}),
            _MenuItemData(Icons.location_on_outlined, 'Delivery Address', CurrentUser.address.isNotEmpty ? '${CurrentUser.address}, ${CurrentUser.district}' : 'Add your address', AppTheme.cartOrange, () {}),
          ]),
          _buildMenuSection(context, 'Settings', [
            _MenuItemData(Icons.dark_mode_outlined, 'Dark Mode', 'Toggle app theme', AppTheme.textPrimary, null, isSwitch: true),
            _MenuItemData(Icons.lock_outline, 'Change Password', 'Update your password', AppTheme.offerRed, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))),
            _MenuItemData(Icons.info_outline, 'About App', 'Version 1.0.0', Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppScreen()))),
            _MenuItemData(Icons.settings_outlined, 'Settings', 'App preferences', AppTheme.textSecondary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          ]),
          _buildLogoutButton(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDark) {
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
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 14, color: AppTheme.forestGreen),
                    SizedBox(width: 4),
                    Text('Edit Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.forestGreen)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.forestGreen, AppTheme.limeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Text(
                    CurrentUser.name.isNotEmpty ? CurrentUser.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: AppTheme.forestGreen),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
            ],
          ).animate().fadeIn().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(CurrentUser.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.harvestAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Gold', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.harvestAmber)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(CurrentUser.phone, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(width: 16),
              Icon(Icons.location_on, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(CurrentUser.district.isNotEmpty ? CurrentUser.district : 'Location not set', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildStatsRow(BuildContext context) {
    final stats = [
      {'value': '12', 'label': 'Orders', 'icon': Icons.shopping_bag, 'color': AppTheme.forestGreen},
      {'value': '5', 'label': 'Products', 'icon': Icons.inventory, 'color': AppTheme.harvestAmber},
      {'value': '₹2.4k', 'label': 'Saved', 'icon': Icons.savings, 'color': AppTheme.successGreen},
      {'value': '4.8', 'label': 'Rating', 'icon': Icons.star, 'color': AppTheme.cartOrange},
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
              children: List.generate(stats.length, (i) {
                final s = stats[i];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (s['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(s['value'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    Text(s['label'] as String, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ).animate().fadeIn(delay: (i * 80).ms).slideY(begin: 0.2);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.forestGreen, AppTheme.forestGreen.withValues(alpha: 0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    const Text('Loyalty Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Gold Tier', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('1,280', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('720 pts to reach Platinum', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.64,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.harvestAmber),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Silver', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                    Text('Gold', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    Text('Platinum', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildMenuSection(BuildContext context, String title, List<_MenuItemData> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.3)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: AppTheme.glassEffect(),
                child: Column(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    return Column(
                      children: [
                        if (i > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(height: 1, color: Colors.grey.withValues(alpha: 0.12)),
                          ),
                        _buildMenuItem(item),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 2),
                Text(item.subtitle, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (item.isSwitch)
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeThumbColor: AppTheme.forestGreen,
            )
          else if (item.onTap != null)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            CurrentUser.name = '';
            CurrentUser.phone = '';
            CurrentUser.address = '';
            CurrentUser.district = '';
            setState(() {});
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.offerRed,
            side: BorderSide(color: AppTheme.offerRed.withValues(alpha: 0.3)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final bool isSwitch;

  const _MenuItemData(this.icon, this.title, this.subtitle, this.color, this.onTap, {this.isSwitch = false});
}


