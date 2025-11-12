import 'package:flutter/material.dart';
import '../../../colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String city;
  final String userId;
  final VoidCallback? onFillData;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.city,
    required this.userId,
    this.onFillData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/images/user.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $userId',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontFamily: 'Manrope',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

