import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class WorkshopInfoSection extends StatelessWidget {
  final String workshopName;
  final String address;
  final String workingHours;
  final String phone;

  const WorkshopInfoSection({
    super.key,
    required this.workshopName,
    required this.address,
    required this.workingHours,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workshopName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 16),
          // Address
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/loc.svg',
                width: 12,
                height: 12,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? const Color(0xFF66727A)
                      : AppColors.lightTextSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF66727A)
                      : AppColors.lightTextSecondary,
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Working Hours
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/time.svg',
                width: 12,
                height: 12,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? const Color(0xFF66727A)
                      : AppColors.lightTextSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                workingHours,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF66727A)
                      : AppColors.lightTextSecondary,
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Phone
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/tel.svg',
                width: 12,
                height: 12,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF771C),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF771C),
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

