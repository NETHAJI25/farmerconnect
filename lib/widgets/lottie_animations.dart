import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';

class AppAnimations {
  static const String _base = 'https://assets5.lottiefiles.com/packages/lf20_';
  static const String loading = '${_base}rqji0lki.json';
  static const String emptyCart = '${_base}2znxqjyt.json';
  static const String success = 'https://assets4.lottiefiles.com/private_files/lf30_tfbywraa.json';
  static const String agriculture = 'https://assets9.lottiefiles.com/packages/lf20_kgykklxw.json';
  static const String emptyBox = 'https://assets2.lottiefiles.com/packages/lf20_qpnqxbeq.json';
  static const String farmFresh = 'https://assets10.lottiefiles.com/packages/lf20_p8bfn5to.json';
}

class LottieAnimation extends StatelessWidget {
  final String url;
  final double size;
  final bool repeat;

  const LottieAnimation({
    super.key,
    required this.url,
    this.size = 180,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      url,
      width: size,
      height: size,
      repeat: repeat,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.forestGreen.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.animation, color: AppTheme.forestGreen, size: 48),
        );
      },
    );
  }
}
