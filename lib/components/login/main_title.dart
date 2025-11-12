import 'package:flutter/material.dart';
import '../../colors.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Text(
        'Войдите через email',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
    );
  }
}
