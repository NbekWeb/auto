import 'package:flutter/material.dart';
import '../../colors.dart';

class DoneButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const DoneButton({
    super.key,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                begin: Alignment(-0.8, -0.6),
                end: Alignment(0.8, 0.6),
                colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
                stops: [0.0, 1.0],
              )
            : null,
        color: isEnabled
            ? null
            : (isDark ? AppColors.inputDark : AppColors.inputLight),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.orangeGradientShadow.withOpacity(0.2),
                  offset: const Offset(0, 0),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadowGrey.withOpacity(0.24),
                  offset: const Offset(0, 0),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: Text(
              'Готово',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isEnabled
                    ? Colors.white
                    : (isDark ? AppColors.textGrey : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

