import 'package:flutter/material.dart';
import '../../../colors.dart';

class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Handle privacy policy
            },
            child: Text(
              'Политика конфиденциальности',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontFamily: 'Manrope',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              // Handle terms of use
            },
            child: Text(
              'Условия использования',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontFamily: 'Manrope',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

