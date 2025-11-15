import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';
import '../pages/dashboard/home_page.dart';
import '../pages/dashboard/map_page.dart';
import '../pages/dashboard/chats_page.dart';
import '../pages/dashboard/profile_page.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _currentIndex = 0; // Start with home page (index 0)

  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
    const ChatsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 98,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.cardLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              _buildNavItem(
                iconPath: 'assets/icons/home.svg',
                label: 'Главная',
                index: 0,
                isDark: isDark,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/map.svg',
                label: 'Карта',
                index: 1,
                isDark: isDark,
              ),
              _buildSOSButton(isDark),
              _buildNavItem(
                iconPath: 'assets/icons/chat.svg',
                label: 'Чаты',
                index: 2,
                isDark: isDark,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/user.svg',
                label: 'Профиль',
                index: 3,
                isDark: isDark,
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isActive = _currentIndex == index;
    final iconColor = isActive 
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? AppColors.textGrey : AppColors.textGrey);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSOSButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        // Handle SOS button tap
        _showSOSDialog();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.8, -0.6),
            end: Alignment(0.8, 0.6),
            colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.orangeGradientShadow.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/sos.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SOS'),
        content: const Text('Вызов экстренных служб'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle emergency call
            },
            child: const Text('Вызвать'),
          ),
        ],
      ),
    );
  }
}
