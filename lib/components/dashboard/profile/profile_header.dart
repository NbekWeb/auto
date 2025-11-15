import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String city;
  final String userId;
  final String? avatarUrl;
  final bool showEditIcon;
  final VoidCallback? onEdit;
  final VoidCallback? onFillData;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.city,
    required this.userId,
    this.avatarUrl,
    this.showEditIcon = false,
    this.onEdit,
    this.onFillData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with loading indicator
              _buildAvatar(isDark),
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
        ),
        // Edit Icon - positioned at top right
        if (showEditIcon && onEdit != null)
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: onEdit,
              child: SvgPicture.asset(
                'assets/icons/edit.svg',
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  isDark ? AppColors.darkText : AppColors.lightText,
                  BlendMode.srcIn,
                ),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isDark) {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/user.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(
          avatarUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.orange),
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/user.png'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

