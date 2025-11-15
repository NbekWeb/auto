import 'package:flutter/material.dart';
import '../../colors.dart';

class VehicleSelectionHeader extends StatelessWidget {
  const VehicleSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 20),
        // Header title
        Center(
          child: Text(
            'Ваш авто',
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Main title
        Center(
          child: Text(
            'Укажите своё ТС',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Description
        Text(
          'Ваши заявки будут точнее, а мастера смогут быстрее откликаться, зная особенности вашего авто',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

