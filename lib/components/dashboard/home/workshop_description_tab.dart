import 'package:flutter/material.dart';
import '../../../colors.dart';

class WorkshopDescriptionTab extends StatelessWidget {
  const WorkshopDescriptionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '«Мастерская № 1» была основана в 2010 году и с тех пор зарекомендовала себя как надёжный партнёр для автовладельцев. Мы предлагаем широкий спектр услуг, включая диагностику и ремонт автомобилей, замену масла, шиномонтаж и кузовные работы.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: 'Manrope',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Наша команда состоит из опытных механиков, которые используют только качественные запчасти и современное оборудование, чтобы обеспечить высокое качество обслуживания.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: 'Manrope',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Мы гордимся индивидуальным подходом к каждому клиенту и стремимся сделать ваш автомобиль безопасным и надёжным.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: 'Manrope',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // Benefits list
          ...['Профессиональный сервис', 'Быстрое выполнение работ', 'Гарантию на все услуги', 'Доступные цены']
              .map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 6, right: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF66727A)
                                : AppColors.lightTextSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            benefit,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              fontFamily: 'Manrope',
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}

