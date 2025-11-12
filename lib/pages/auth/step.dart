import 'package:flutter/material.dart';
import '../../colors.dart';

class _AutoScrollContainer extends StatefulWidget {
  final Widget child;
  final Function(double)? onImageSize;

  const _AutoScrollContainer({
    super.key,
    required this.child,
    this.onImageSize,
  });

  @override
  State<_AutoScrollContainer> createState() => _AutoScrollContainerState();
}

class _AutoScrollContainerState extends State<_AutoScrollContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  double _imageWidth = 0;
  double _containerWidth = 0;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      duration: const Duration(seconds: 100), // Animatsiyani sekinroq qildim
      vsync: this,
    );

    // Cheksiz loop animatsiya
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animatsiya tugagach, darhol boshidan boshlash
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  void restartAnimation() {
    _controller.reset();
    _scrollController.jumpTo(0);
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AutoScrollContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget o'zgargan bo'lsa, animatsiyani qayta boshlash
    if (oldWidget.child != widget.child) {
      restartAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Auto scroll animation with real dimensions
        if (_scrollController.hasClients &&
            _imageWidth > 0 &&
            _containerWidth > 0) {
          double totalWidth = (_imageWidth * 20) + (500 * 19); 
          double maxScroll = totalWidth - _containerWidth;
          if (maxScroll > 0) {
            // Smooth scroll animation
            _scrollController.animateTo(
              _controller.value * maxScroll,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          }
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            _containerWidth = constraints.maxWidth;

            // Get image width after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_imageKey.currentContext != null) {
                final RenderBox renderBox =
                    _imageKey.currentContext!.findRenderObject() as RenderBox;
                if (renderBox.size.width != _imageWidth) {
                  setState(() {
                    _imageWidth = renderBox.size.width;
                  });
                }
              }
            });

            return SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable manual scroll
              child: Row(
                children: List.generate(20, (index) => 
                  Row(
                    children: [
                      Container(
                        key: index == 0 ? _imageKey : null,
                        child: widget.child,
                      ),
                      // Rasmlar orasiga joy qo'shish
                      if (index < 9) const SizedBox(width: 500),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final GlobalKey<_AutoScrollContainerState> _autoScrollKey =
      GlobalKey<_AutoScrollContainerState>();

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Добро пожаловать в Check Auto',
      'subtitle':
          'Найди мастера для ремонта автомобиля в любое время и в любом месте',
      'image': 'assets/images/v2.png',
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
  void initState() {
    super.initState();
  }

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
              child: GestureDetector(
                onTap: () {
                  // Dismiss keyboard when tapping outside
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Skip button
                      Padding(
                        padding: const EdgeInsets.only(top: 15, right: 16),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/login');
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                            // Agar birinchi slide ga qaytsak, animatsiyani qayta boshlash
                            if (index == 0) {
                              _autoScrollKey.currentState?.restartAnimation();
                            }
                          },
                          itemCount: _steps.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                // Content
                                Column(
                                  children: [
                                     // Image for step1
                                     if (index == 0)
                                       Padding(
                                         padding: const EdgeInsets.only(top: 25),
                                         child: SizedBox(
                                           height:
                                               MediaQuery.of(context).size.height *
                                               0.25,
                                           child: _AutoScrollContainer(
                                             key: _autoScrollKey,
                                             onImageSize: (width) {
                                               setState(() {
                                                 // Update image width for scroll calculation
                                               });
                                             },
                                             child: Image.asset(
                                               _steps[index]['image'],
                                               fit: BoxFit.contain,
                                               height:
                                                   MediaQuery.of(
                                                     context,
                                                   ).size.height *
                                                   0.25,
                                             ),
                                           ),
                                         ),
                                       ),
                                    SizedBox(height: 50),
                                    // Image for step2 (with background)
                                    if (index == 1)
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.35,
                                        width: double.infinity,
                                        child: Opacity(
                                          opacity: 0.0,
                                          child: Image.asset(
                                            _steps[3]['image'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    // Image for other steps
                                    if (index > 1)
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.35,
                                        width: double.infinity,
                                        child: Image.asset(
                                          _steps[index]['image'],
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                    // Spacer to push text to bottom
                                    const Spacer(),

                                    // Text wrapper - moved to bottom
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      child: Column(
                                        children: [
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
                                                  : AppColors
                                                        .lightTextSecondary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
