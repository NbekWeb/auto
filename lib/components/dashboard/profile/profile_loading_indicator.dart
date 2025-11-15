import 'package:flutter/material.dart';
import '../../../colors.dart';

class ProfileLoadingIndicator extends StatelessWidget {
  const ProfileLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.orange,
          ),
        ),
      ),
    );
  }
}

