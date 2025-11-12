import 'package:flutter/material.dart';
import '../../../colors.dart';
import 'workshop_card.dart';

class WorkshopsSection extends StatelessWidget {
  const WorkshopsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sample workshop data - will be repeated 3 times
    final workshopData = {
      'workshopName': 'Мастерская №1',
      'address': 'Ул. Ольшевского, 20/4',
      'workingHours': 'Ежедневно 09:00-19:00',
      'services': [
        {'name': 'Смена шин от', 'price': '2100 Р'},
        {'name': 'Смена шин для микроавтобусов от', 'price': '4000 Р'},
        {'name': 'Сезонное хранение 4-х шин', 'price': '3500 Р'},
        {'name': 'Балансировка (цена за 1 колесо) от', 'price': '200 Р'},
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Лучшие мастерские',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(
              3,
              (index) => WorkshopCard(
                workshopName: workshopData['workshopName'] as String,
                address: workshopData['address'] as String,
                workingHours: workshopData['workingHours'] as String,
                services: (workshopData['services'] as List)
                    .map((item) => Map<String, String>.from(item as Map))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

