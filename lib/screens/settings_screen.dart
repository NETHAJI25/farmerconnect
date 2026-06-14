import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/user_data.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import 'change_password_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildMenuSection(context, "Account", [
              _MenuItemData(Icons.person_outline, "Profile", () => Navigator.pop(context), AppTheme.forestGreen),
              _MenuItemData(Icons.lock_outline, "Change Password", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())), AppTheme.harvestAmber),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection(context, "Preferences", [
              _MenuItemData(Icons.dark_mode, "Dark Mode", null, AppTheme.forestGreen, isSwitch: true),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection(context, "Other", [
              _MenuItemData(Icons.info_outline, "About App", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppScreen())), Colors.blue),
            ]),
            const SizedBox(height: 32),
            const Column(
              children: [
                Text("FarmConnect", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Version 1.0", style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glassEffect(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.forestGreen.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 32, color: AppTheme.forestGreen),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserData.name.isEmpty ? "FarmConnect User" : UserData.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(UserData.phone, style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildMenuSection(BuildContext context, String title, List<_MenuItemData> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.04)),
                ),
                child: Column(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final isLast = i == items.length - 1;
                    return Column(
                      children: [
                        _buildMenuItem(item),
                        if (!isLast) Divider(height: 1, indent: 56, color: Theme.of(context).dividerTheme.color),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (50 * items.length).ms).slideY(begin: 0.05),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: item.isSwitch ? null : item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 20, color: item.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              if (item.isSwitch)
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: AppTheme.forestGreen,
                )
              else
                Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color color;
  final bool isSwitch;

  const _MenuItemData(this.icon, this.title, this.onTap, this.color, {this.isSwitch = false});
}
