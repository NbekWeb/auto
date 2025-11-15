import 'package:flutter/material.dart';
import '../../colors.dart';

class ResendCodeButton extends StatelessWidget {
  final bool canResend;
  final int countdown;
  final bool isVerifying;
  final VoidCallback onPressed;

  const ResendCodeButton({
    super.key,
    required this.canResend,
    required this.countdown,
    required this.isVerifying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: canResend
            ? const LinearGradient(
                begin: Alignment(-0.8, -0.6),
                end: Alignment(0.8, 0.6),
                colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
                stops: [0.0, 1.0],
              )
            : null,
        color: canResend
            ? null
            : (isDark ? AppColors.inputDark : AppColors.inputLight),
        borderRadius: BorderRadius.circular(12),
        boxShadow: canResend
            ? [
                BoxShadow(
                  color: AppColors.orangeGradientShadow.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: canResend ? onPressed : null,
          child: Center(
            child: isVerifying
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        canResend
                            ? Colors.white
                            : (isDark
                                ? AppColors.textGrey
                                : AppColors.lightTextSecondary),
                      ),
                    ),
                  )
                : Text(
                    canResend
                        ? 'Отправить код повторно'
                        : 'Отправить код повторно через $countdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: canResend
                          ? Colors.white
                          : (isDark
                              ? AppColors.textGrey
                              : AppColors.lightTextSecondary),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

