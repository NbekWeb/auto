import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class VehicleTypeButton extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleTypeButton({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orangeSelected
              : AppColors.borderDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.orangeSelected
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: const Offset(6, 6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.04),
              offset: const Offset(-6, -6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (vehicle['isSvg'] == true)
                ? SizedBox(
                    width: 36,
                    height: 36,
                    child: SvgPicture.asset(
                      'assets/icons/${vehicle['icon']}.svg',
                      width: 36,
                      height: 36,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? AppColors.textWhite
                            : AppColors.orange,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : Icon(
                    vehicle['icon'],
                    size: 32,
                    color: isSelected
                        ? AppColors.textWhite
                        : AppColors.orange,
                  ),
            const SizedBox(height: 8),
            Text(
              vehicle['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

