import 'package:flutter/material.dart';
import '../../../colors.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Выйти из аккаунта',
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
          fontFamily: 'Manrope',
        ),
      ),
      content: Text(
        'Вы действительно хотите выйти из аккаунта?',
        style: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          fontFamily: 'Manrope',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Отмена',
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: 'Manrope',
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Выйти',
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'Manrope',
            ),
          ),
        ),
      ],
    );
  }
}

