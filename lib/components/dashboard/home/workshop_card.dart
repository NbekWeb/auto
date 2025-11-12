import 'package:flutter/material.dart';
import '../../../colors.dart';
import '../../../pages/dashboard/workshop_detail_page.dart';

class WorkshopCard extends StatelessWidget {
  final String workshopName;
  final String address;
  final String workingHours;
  final List<Map<String, String>> services;

  const WorkshopCard({
    super.key,
    required this.workshopName,
    required this.address,
    required this.workingHours,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(top: 8, right: 8, bottom: 12, left: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E272F) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF252F37) : const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0AFFFFFF), // #FFFFFF0A
            offset: const Offset(-6, -6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/serv.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Workshop info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshopName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF818B93)
                            : AppColors.lightTextSecondary,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workingHours,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFFD1D3D5)
                            : AppColors.lightTextSecondary,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Services list with orange bullet points
          ...services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Orange bullet point
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 6, right: 10, left: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF771C),
                      shape: BoxShape.circle,
                    ),
                  ),
                    // Service text
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
                                    ? const Color(0xFFD1D3D5)
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
                                    ? const Color(0xFFD1D3D5)
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
                                    ? const Color(0xFF818B93)
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
            ),
          ),
          const SizedBox(height: 8),
          // Show all services link
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkshopDetailPage(
                    workshopName: workshopName,
                    address: address,
                    workingHours: workingHours,
                    phone: '+9 999 999 99 99',
                    services: services,
                  ),
                ),
              );
            },
            child: Text(
              'Показать все услуги',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFF771C),
                fontFamily: 'Manrope',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
