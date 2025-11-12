import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class ServicesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> services;

  const ServicesGrid({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Сервисы',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16 ,top:20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];

              return GestureDetector(
                onTap: () {
                  // Handle service tap
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF252F37),
                    borderRadius: BorderRadius.circular(8),
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
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: SvgPicture.asset(
                          'assets/icons/${service['icon']}.svg',
                          width: 36,
                          height: 36,
                          colorFilter: service['icon'] == 'help'
                              ? const ColorFilter.mode(
                                  Color(0xFFF74242),
                                  BlendMode.srcIn,
                                )
                              : const ColorFilter.mode(
                                  Color(0xFFFF771C),
                                  BlendMode.srcIn,
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            service['name'],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFF4F4F4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

