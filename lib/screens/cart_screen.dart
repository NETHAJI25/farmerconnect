import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/app_data.dart';
import '../theme/app_theme.dart';
import '../utils/image_constants.dart';
import '../widgets/lottie_animations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? couponCode;
  final couponController = TextEditingController();
  bool showCouponInput = false;

  double get subtotal {
    double total = 0;
    for (var item in AppData.cart) {
      total += (item['product'].price as int) * (item['qty'] as int);
    }
    return total;
  }

  double get deliveryFee => subtotal > 500 ? 0 : 40;
  double get total => subtotal + deliveryFee;
  double get freeDeliveryRemaining => subtotal >= 500 ? 0 : 500 - subtotal;

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppData.cart.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                _buildHeader(context),
                _buildDeliveryProgress(context),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    itemCount: AppData.cart.length,
                    itemBuilder: (context, index) {
                      final item = AppData.cart[index];
                      final product = item['product'];
                      return _buildCartItem(context, index, item, product);
                    },
                  ),
                ),
                _buildCheckoutSection(context),
              ],
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final itemCount = AppData.cart.fold<int>(0, (sum, item) => sum + (item['qty'] as int));
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Cart', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('$itemCount item${itemCount > 1 ? 's' : ''} • ₹${subtotal.toStringAsFixed(0)}',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.offerRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Clear Cart'),
                    content: const Text('Remove all items from cart?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          setState(() => AppData.cart.clear());
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.delete_sweep, color: AppTheme.offerRed, size: 22),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildDeliveryProgress(BuildContext context) {
    if (freeDeliveryRemaining <= 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 18),
                  const SizedBox(width: 8),
                  const Text('Free delivery unlocked!',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.successGreen)),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2);
    }

    final progress = (subtotal / 500).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.harvestAmber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.harvestAmber.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fire_truck, color: AppTheme.harvestAmber, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Add ₹${freeDeliveryRemaining.toStringAsFixed(0)} more for free delivery',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.harvestAmber),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.harvestAmber),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2);
  }

  Widget _buildCartItem(BuildContext context, int index, Map<String, dynamic> item, dynamic product) {
    final imageUrl = AppImages.forProduct(product.productName as String);
    final itemTotal = (product.price as int) * (item['qty'] as int);

    return Dismissible(
      key: ValueKey('cart_${product.productName}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.offerRed,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('Remove', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        setState(() => AppData.cart.removeAt(index));
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.glassEffect(),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        width: 72,
                        height: 72,
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
                        Text(product.productName as String,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text('₹${product.price}/kg',
                            style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 10),
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
                                    onTap: () {
                                      if ((item['qty'] as int) > 1) {
                                        setState(() => item['qty'] = (item['qty'] as int) - 1);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(Icons.remove, size: 16,
                                          color: (item['qty'] as int) > 1 ? AppTheme.forestGreen : Colors.grey.shade300),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('${item['qty']}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => item['qty'] = (item['qty'] as int) + 1),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(Icons.add, size: 16, color: AppTheme.forestGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text('₹$itemTotal',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.forestGreen)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: (index * 80).ms + 200.ms).slideX(begin: 0.2),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LottieAnimation(url: AppAnimations.emptyCart, size: 160),
            const SizedBox(height: 8),
            const Text('Your cart is empty',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Add products from farmers to get started',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.forestGreen,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: AppTheme.forestGreen.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.explore, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Explore Products',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
            ),
          ],
        ).animate().fadeIn().slideY(begin: 0.2),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, -6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!showCouponInput)
                GestureDetector(
                  onTap: () => setState(() => showCouponInput = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, size: 16, color: AppTheme.forestGreen),
                        const SizedBox(width: 8),
                        const Text('Have a coupon?',
                            style: TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                        const Spacer(),
                        const Icon(Icons.add, size: 16, color: AppTheme.forestGreen),
                      ],
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          couponCode = couponController.text;
                          showCouponInput = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              const SizedBox(height: 6),
              _PriceRow('Subtotal', subtotal),
              const SizedBox(height: 4),
              _PriceRow('Delivery', deliveryFee == 0 ? 'Free' : '₹$deliveryFee'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Divider(),
              ),
              _PriceRow('Total', total, isTotal: true),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Proceed to Checkout'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3);
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool isTotal;

  const _PriceRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary)),
        Text(
          value is double ? '₹${value.toStringAsFixed(0)}' : '$value',
          style: TextStyle(fontSize: isTotal ? 17 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? AppTheme.forestGreen : AppTheme.textPrimary),
        ),
      ],
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _deliverySlots = ['Today', 'Tomorrow', 'Day After'];
  int _selectedSlot = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryAddress(context),
            const SizedBox(height: 14),
            _buildDeliverySlot(context),
            const SizedBox(height: 14),
            _buildOrderSummary(context),
            const SizedBox(height: 14),
            _buildPaymentSection(context),
            const SizedBox(height: 14),
            _buildTrustBadges(context),
            const SizedBox(height: 20),
            _buildPlaceOrderButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress(BuildContext context) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on, color: AppTheme.forestGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Delivery Address', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 13, color: AppTheme.forestGreen),
                        SizedBox(width: 4),
                        Text('Change', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.forestGreen)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.04),
                  border: Border.all(color: AppTheme.forestGreen.withValues(alpha: 0.12)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.home_rounded, color: AppTheme.forestGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Home', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('123, Main Street, Coimbatore - 641001',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildDeliverySlot(BuildContext context) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.harvestAmber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.schedule, color: AppTheme.harvestAmber, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Delivery Slot', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: List.generate(_deliverySlots.length, (i) {
                  final isSelected = _selectedSlot == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSlot = i),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.only(right: i < _deliverySlots.length - 1 ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.forestGreen : AppTheme.forestGreen.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppTheme.forestGreen : AppTheme.forestGreen.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              i == 0 ? Icons.sunny_snowing : Icons.cloud,
                              size: 18,
                              color: isSelected ? Colors.white : AppTheme.forestGreen,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _deliverySlots[i],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1);
  }

  Widget _buildOrderSummary(BuildContext context) {
    final cartTotal = AppData.cart.fold<double>(0, (sum, item) => sum + (item['product'].price as int) * (item['qty'] as int));
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.receipt, color: AppTheme.forestGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Order Summary', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${AppData.cart.length} item${AppData.cart.length > 1 ? 's' : ''}',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 14),
              ...AppData.cart.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: AppImages.forProduct(item['product'].productName as String),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(item['product'].productName as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        Text('x${item['qty']}', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        const SizedBox(width: 16),
                        Text('₹${(item['product'].price as int) * (item['qty'] as int)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  )),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text('₹${cartTotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.forestGreen)),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildPaymentSection(BuildContext context) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.cartOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.payment, color: AppTheme.cartOrange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Payment', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, size: 11, color: AppTheme.successGreen),
                        SizedBox(width: 4),
                        Text('Secured', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.successGreen)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: 'cod',
                onChanged: (_) {},
                child: Column(
                  children: [
                    RadioListTile(
                      value: 'cod',
                      title: const Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Pay when you receive', style: TextStyle(fontSize: 12)),
                      activeColor: AppTheme.forestGreen,
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    RadioListTile(
                      value: 'online',
                      title: const Text('Online Payment', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Pay via UPI / Card / Net Banking', style: TextStyle(fontSize: 12)),
                      activeColor: AppTheme.forestGreen,
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1);
  }

  Widget _buildTrustBadges(BuildContext context) {
    final badges = [
      {'icon': Icons.lock, 'label': 'Secure Payment', 'color': AppTheme.forestGreen},
      {'icon': Icons.fire_truck, 'label': 'Free Delivery', 'color': AppTheme.harvestAmber},
      {'icon': Icons.eco, 'label': '100% Fresh', 'color': AppTheme.limeAccent},
      {'icon': Icons.assignment_return, 'label': 'Easy Returns', 'color': AppTheme.cartOrange},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(badges.length, (i) {
        final b = badges[i];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (b['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(b['icon'] as IconData, color: b['color'] as Color, size: 18),
            ),
            const SizedBox(height: 4),
            Text(b['label'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
          ],
        ).animate().fadeIn(delay: (i * 80).ms + 300.ms).slideY(begin: 0.2);
      }),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    final cartTotal = AppData.cart.fold<double>(0, (sum, item) => sum + (item['product'].price as int) * (item['qty'] as int));
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          AppData.cart.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
          );
        },
        icon: const Icon(Icons.check_circle),
        label: Text('Place Order • ₹${cartTotal.toStringAsFixed(0)}'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.3);
  }
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.forestGreen, AppTheme.forestGreen.withValues(alpha: 0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LottieAnimation(url: AppAnimations.success, size: 150),
                    const SizedBox(height: 12),
                    const Text('Order Placed!',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'Your order has been placed successfully.\nYou will receive a confirmation shortly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.receipt_long, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text('ORD-2026-06-13-001',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time, color: Colors.white, size: 14),
                                  const SizedBox(width: 6),
                                  Text('Expected delivery: Today',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.forestGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 0,
                        ),
                        child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      style: TextButton.styleFrom(foregroundColor: Colors.white.withValues(alpha: 0.7)),
                      child: Text('View Order Details',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w500, fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}