import 'package:flutter/material.dart';
import '../../../colors.dart';

class WorkshopServicesTab extends StatelessWidget {
  final List<Map<String, String>> services;

  const WorkshopServicesTab({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {
        'name': 'Сервис и ТО',
        'services': services,
      },
      {
        'name': 'Диагностика электроники',
        'services': services,
      },
      {
        'name': 'Шиномонтаж',
        'services': services,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category['name'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 12),
              ...(category['services'] as List<Map<String, String>>)
                  .map((service) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.only(
                                top: 6,
                                right: 10,
                                left: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${service['name']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: isDark
                                            ? AppColors.iconGrey
                                            : AppColors.lightTextSecondary,
                                        fontFamily: 'Manrope',
                                        height: 1.3,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' · ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: isDark
                                            ? AppColors.iconGrey
                                            : AppColors.lightTextSecondary,
                                        fontFamily: 'Manrope',
                                        height: 1.3,
                                      ),
                                    ),
                                    TextSpan(
                                      text: service['price'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: isDark
                                            ? AppColors.textGrey
                                            : AppColors.lightTextSecondary,
                                        fontFamily: 'Manrope',
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
            ],
          ),
        );
      },
    );
  }
}

