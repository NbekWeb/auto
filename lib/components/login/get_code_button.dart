import 'package:flutter/material.dart';
import '../../colors.dart';

class GetCodeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isActive;
  final bool isLoading;

  const GetCodeButton({
    super.key,
    this.onPressed,
    this.text = 'Получить код',
    this.isActive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: isActive 
            ? const LinearGradient(
                begin: Alignment(-0.8, -0.6),
                end: Alignment(0.8, 0.6),
                colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                stops: [0.0, 1.0],
              )
            : null,
        color: isActive ? null : (isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isActive 
            ? [
                BoxShadow(
                  color: const Color(0xFFF68324).withValues(alpha: 0.2),
                  offset: const Offset(0, 0),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF6F6F6F).withValues(alpha: 0.24),
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
          onTap: onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isActive ? Colors.white : (isDark ? const Color(0xFF818B93) : AppColors.lightText),
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive 
                          ? Colors.white 
                          : (isDark ? const Color(0xFF818B93) : AppColors.lightText),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
