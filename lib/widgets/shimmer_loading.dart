import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ShimmerGrid extends StatelessWidget {
  final int itemCount;

  const ShimmerGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => _ShimmerCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 12, width: 100, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 4),
            Container(height: 10, width: 70, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4))),
          ],
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;

  const ShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: _ShimmerCard(
            child: Row(
              children: [
                Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(14))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 150, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 100, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  final Widget child;
  const _ShimmerCard({required this.child});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = TweenSequence<Alignment>([
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: _animation.value,
              end: _animation.value == Alignment.topLeft || _animation.value == Alignment.bottomLeft
                  ? Alignment.bottomRight
                  : Alignment.topLeft,
              colors: [
                AppTheme.forestGreen.withValues(alpha: 0.04),
                AppTheme.forestGreen.withValues(alpha: 0.1),
                AppTheme.limeAccent.withValues(alpha: 0.06),
                AppTheme.forestGreen.withValues(alpha: 0.04),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.forestGreen.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}
