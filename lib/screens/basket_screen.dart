import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/lottie_animations.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  Future<void> makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    if (AppData.basket.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Basket")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LottieAnimation(url: AppAnimations.emptyCart, size: 140),
              const SizedBox(height: 16),
              const Text("Basket is empty", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text("Add products from farmers to get started", style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
      );
    }

    final item = AppData.basket.first;
    final product = item["product"];

    return Scaffold(
      appBar: AppBar(title: const Text("Basket")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildProductCard(context, product),
                  const SizedBox(height: 16),
                  _buildSellerInfo(context, product),
                ],
              ),
            ),
            _buildCallButton(context, product),
            const SizedBox(height: 8),
            Text(
              "Contact the farmer to place your order",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.glassEffect(),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.eco, color: AppTheme.forestGreen, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Farmer: ${product.farmerName}", style: TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee, size: 14, color: AppTheme.forestGreen),
                        const SizedBox(width: 2),
                        Text("${product.price}/kg", style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildSellerInfo(BuildContext context, dynamic product) {
    return ClipRRect(
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
                  Icon(Icons.store, size: 18, color: AppTheme.forestGreen),
                  SizedBox(width: 8),
                  Text("Seller Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 14),
              _DetailRow(Icons.person, product.farmerName),
              const SizedBox(height: 10),
              _DetailRow(Icons.phone, product.phone),
              const SizedBox(height: 10),
              _DetailRow(Icons.location_on, product.address),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildCallButton(BuildContext context, dynamic product) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () => makeCall(product.phone),
        icon: const Icon(Icons.call),
        label: const Text("Call Farmer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2);
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.forestGreen.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppTheme.forestGreen),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14))),
      ],
    );
  }
}
