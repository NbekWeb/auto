import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Добро пожаловать в Check Auto',
      'subtitle':
          'Найди мастера для ремонта автомобиля в любое время и в любом месте',
      'image': 'assets/images/step1.png',
    },
    {
      'title': 'Выберите услугу и город',
      'subtitle':
          'И мы найдем мастеров, готовых помочь. Мастера работают со всеми типами ТС - легковые, грузовые, мотоциклы!',
      'image': 'assets/images/step2.png',
    },
    {
      'title': 'Для автовладельцев',
      'subtitle':
          'Укажите марку авто и услугу - получите отклики от мастеров с рейтингом',
      'image': 'assets/images/step3.png',
    },
    {
      'title': 'Для мастеров',
      'subtitle':
          'Зарегистрируйтесь, выберите услуги и начинайте получать заявки',
      'image': 'assets/images/step4.png',
    },
    {
      'title': 'Оценивайте выполнение услуг',
      'subtitle':
          'Оцените мастера по шкале от 1 до 10 после выполнения услуги, чтобы помочь другим пользователям с выбором специалиста',
      'image': 'assets/images/step5.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBackground, AppColors.darkSurface]
                : [AppColors.lightBackground, AppColors.lightSurface],
          ),
        ),
        child: Stack(
          children: [
            // Background Image for step 2 (covers entire screen including SafeArea)
            if (_currentIndex == 1)
              Positioned.fill(
                child: Image.asset(
                  _steps[1]['image'], // Use step1 image for step2
                  fit: BoxFit.cover,
                ),
              ),

            SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: const Color(0xFFFF8635),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Swiper content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // Content
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image for other steps
                                if (index != 1)
                                  SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Image.asset(
                                      _steps[index]['image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                 if (index == 1)
                                   SizedBox(
                                     height: 300,
                                     width: double.infinity,
                                     child: Opacity(
                                       opacity: 0.0,
                                       child: Image.asset(
                                         _steps[0]['image'],
                                         fit: BoxFit.contain,
                                       ),
                                     ),
                                   ),
                                const SizedBox(height: 64),

                                // Text wrapper
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Column(
                                    children: [
                                      // Title
                                      Text(
                                        _steps[index]['title'],
                                        style: TextStyle(
                                          fontSize: 32,
                                          letterSpacing: 0.5,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? AppColors.darkText
                                              : AppColors.lightText,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      const SizedBox(height: 10),

                                      // Subtitle
                                      Text(
                                        _steps[index]['subtitle'],
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Dots indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _steps.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? AppColors.stepDotActive
                                : AppColors.stepDotDefault,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 20,
                      top: 8,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-0.8, -1.0),
                          end: Alignment(0.8, 1.0),
                          colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                          stops: [-0.1034, 1.0747],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x33F68324),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            if (_currentIndex < _steps.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/login');
                            }
                          },
                          child: Center(
                            child: Text(
                              _currentIndex < _steps.length - 1
                                  ? 'Далее'
                                  : 'Начать регистрацию',
                              style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF4F4F4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
