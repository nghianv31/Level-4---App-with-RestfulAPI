import 'package:flutter/material.dart';
import '../../../../core/theme/AppTheme.dart';

class CustomStateWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool useIconBackground;
  final String message;
  final double messageFontSize;
  final Widget? actionButton;

  const CustomStateWidget({
    super.key,
    required this.icon,
    this.iconColor = AppTheme.primaryColor,
    this.useIconBackground = false,
    required this.message,
    this.messageFontSize = 16.0,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final btn = actionButton;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useIconBackground)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: iconColor),
              )
            else
              Icon(icon, size: 64, color: iconColor),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: messageFontSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (btn != null) ...[
              const SizedBox(height: 16),
              btn,
            ],
          ],
        ),
      ),
    );
  }
}
