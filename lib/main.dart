import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'colors.dart';
import 'pages/splash_page.dart';
import 'pages/auth/step.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.lightPrimary,
        scaffoldBackgroundColor: AppColors.lightBackground,
        fontFamily: 'Manrope',
      ),
      home: const SplashPage(),
      routes: {
        '/home': (context) => const MyHomePage(title: 'My App'),
        '/steps': (context) => const StepPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Bosh Sahifa',
      'icon': 'assets/icons/home.svg',
      'content': 'SVG va Manrope font bilan yaratilgan Flutter ilovasi',
    },
    {
      'title': 'Profil',
      'icon': 'assets/icons/user.svg',
      'content': 'Foydalanuvchi profili sahifasi',
    },
    {
      'title': 'Sozlamalar',
      'icon': 'assets/icons/settings.svg',
      'content': 'Ilova sozlamalari',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.darkBackground, AppColors.darkSurface],
          ),
        ),
        child: Column(
          children: [
            // Logo SVG
            Container(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 100,
                height: 100,
              ),
            ),
            
            // Title with Manrope font
            Text(
              'Xush kelibsiz',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 20),
            
            // Description with different font weights
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Ilovamizga xush kelibsiz',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Current page content
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Page icon
                        SvgPicture.asset(
                          _pages[_selectedIndex]['icon'],
                          width: 48,
                          height: 48,
                          colorFilter: const ColorFilter.mode(
                            AppColors.darkPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // Page title
                        Text(
                          _pages[_selectedIndex]['title'],
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Page content
                        Text(
                          _pages[_selectedIndex]['content'],
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Font weight examples
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manrope Font Variants:',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Regular (400) - Oddiy matn',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        Text(
                          'Medium (500) - O\'rta qalinlik',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        Text(
                          'SemiBold (600) - Yarim qalin',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        Text(
                          'Bold (700) - Qalin',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTextSecondary,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? AppColors.darkPrimary : AppColors.darkTextSecondary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Bosh Sahifa',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/user.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1 ? AppColors.darkPrimary : AppColors.darkTextSecondary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2 ? AppColors.darkPrimary : AppColors.darkTextSecondary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Sozlamalar',
          ),
        ],
      ),
    );
  }
}