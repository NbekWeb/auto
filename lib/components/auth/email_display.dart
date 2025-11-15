import 'package:flutter/material.dart';
import '../../colors.dart';

class EmailDisplay extends StatelessWidget {
  final String email;
  final VoidCallback onEdit;

  const EmailDisplay({
    super.key,
    required this.email,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            email,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onEdit,
          child: Text(
            'Изменить',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.orangeSelected,
            ),
          ),
        ),
      ],
    );
  }
}

