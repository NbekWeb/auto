import 'package:flutter/material.dart';
import '../../../colors.dart';

class FillLaterButton extends StatelessWidget {
  final VoidCallback onTap;

  const FillLaterButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Заполнить данные позже',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textGreySecondary,
          fontWeight: FontWeight.w600,
          fontFamily: 'Manrope',
          height: 1.3,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

