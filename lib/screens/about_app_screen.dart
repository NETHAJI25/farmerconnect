import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About FarmConnect")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.agriculture, size: 56, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 20),
            const Text(
              "FarmConnect",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Version 1.0.0",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Our Mission",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "FarmConnect is a direct farmer-to-consumer marketplace that enables buyers to purchase fruits, vegetables, grains, and other farm produce directly from farmers without any intermediaries.",
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Key Features",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _FeatureItem(Icons.connect_without_contact, "Direct farmer connection"),
                    _FeatureItem(Icons.remove_shopping_cart, "No middlemen"),
                    _FeatureItem(Icons.compare_arrows, "Product comparison"),
                    _FeatureItem(Icons.phone_in_talk, "Farmer contact support"),
                    _FeatureItem(Icons.monetization_on, "Fair pricing"),
                    _FeatureItem(Icons.web, "Web & Mobile support"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              "Developed by Sathish Kumar",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
