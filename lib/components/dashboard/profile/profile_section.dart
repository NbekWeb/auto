import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<ProfileSectionItem> items;

  const ProfileSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontFamily: 'Manrope',
              ),
            ),
          ),
        Column(
          children: items.map((item) {
            final isLast = items.last == item;
            return _ProfileSectionItemWidget(
              item: item,
              isLast: isLast,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ProfileSectionItem {
  final String title;
  final IconData? icon;
  final String? iconPath;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  ProfileSectionItem({
    required this.title,
    this.icon,
    this.iconPath,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  }) : assert(icon != null || iconPath != null, 'Either icon or iconPath must be provided');
}

class _ProfileSectionItemWidget extends StatelessWidget {
  final ProfileSectionItem item;
  final bool isLast;

  const _ProfileSectionItemWidget({
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            item.iconPath != null
                ? SvgPicture.asset(
                    item.iconPath!,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      isDark ? AppColors.textGrey : AppColors.lightText,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    item.icon,
                    size: 24,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: item.subtitle != null && item.trailing == null
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: item.titleColor ??
                                  (isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText),
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ),
                        Text(
                          item.subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: item.titleColor ??
                                (isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText),
                            fontFamily: 'Manrope',
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
            if (item.trailing != null) item.trailing!,
            if (item.trailing == null)
              Icon(
                Icons.chevron_right,
                size: 24,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

