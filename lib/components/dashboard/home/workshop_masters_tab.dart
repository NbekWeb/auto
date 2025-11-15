import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class WorkshopMastersTab extends StatelessWidget {
  const WorkshopMastersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final masters = [
      {'name': 'Константин', 'rating': 4.9, 'reviews': 5},
      {'name': 'Иннокентий', 'rating': 4.8, 'reviews': 20},
      {'name': 'Олег', 'rating': 4.6, 'reviews': 8},
      {'name': 'Станислав', 'rating': 4.5, 'reviews': 6},
      {'name': 'Олег', 'rating': 4.8, 'reviews': 5},
    ];

    return Padding(
      padding: const EdgeInsets.all( 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: masters.length,
        itemBuilder: (context, index) {
          final master = masters[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputDark : AppColors.inputLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textGreyLight,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  master['name'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/star.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${master['rating']} (${master['reviews']})',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

