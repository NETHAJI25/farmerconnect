import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ToastType { success, error, info }

class AppToast {
  static void show(BuildContext context, String message, {ToastType type = ToastType.info}) {
    final colors = {
      ToastType.success: AppTheme.primaryGreen,
      ToastType.error: AppTheme.errorRed,
      ToastType.info: AppTheme.textSecondary,
    };

    final icons = {
      ToastType.success: Icons.check_circle,
      ToastType.error: Icons.error_outline,
      ToastType.info: Icons.info_outline,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icons[type], color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colors[type],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
