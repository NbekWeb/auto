import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/dashboard/profile/profile_header.dart';
import '../../components/dashboard/profile/profile_section.dart';
import '../../components/dashboard/profile/theme_selector.dart';
import '../../components/dashboard/profile/legal_links.dart';
import '../../components/dashboard/profile/custom_switch.dart';
import 'faq_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeader(
              name: 'Ваше имя',
              city: 'Ваш город',
              userId: '511245',
              onFillData: () {
                // Handle fill data
              },
            ),
            // Fill Data Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle fill data
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF771C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Заполнить данные',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Wrapper for all sections from "Мой гараж" to "Политика конфиденциальности"
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E272F) : const Color(0xFFF5F5F5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: isDark ? const Color(0xFF252F37) : const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings Section
                    ProfileSection(
                      title: 'Настройки',
                      items: [
                        ProfileSectionItem(
                          title: 'Мой гараж',
                          iconPath: 'assets/icons/garaj.svg',
                          subtitle: '1 ТС',
                          onTap: () {
                            // Handle my garage
                          },
                        ),
                        ProfileSectionItem(
                          title: 'История заявок',
                          iconPath: 'assets/icons/history.svg',
                          onTap: () {
                            // Handle request history
                          },
                        ),
                        ProfileSectionItem(
                          title: 'Уведомления',
                          iconPath: 'assets/icons/ring.svg',
                          trailing: CustomSwitch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    // Help Section
                    ProfileSection(
                      title: 'Помощь',
                      items: [
                        ProfileSectionItem(
                          title: 'FAQ',
                          iconPath: 'assets/icons/faq.svg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FAQPage(),
                              ),
                            );
                          },
                        ),
                        ProfileSectionItem(
                          title: 'Поддержка',
                          iconPath: 'assets/icons/poderjka.svg',
                          onTap: () {
                            // Handle support
                          },
                        ),
                      ],
                    ),
                    // Theme Selector
                    ThemeSelector(
                      isDarkMode: _isDarkMode,
                      onThemeChanged: (isDark) {
                        setState(() {
                          _isDarkMode = isDark;
                        });
                        // Handle theme change
                      },
                    ),
                    // Account Actions
                    ProfileSection(
                      title: '',
                      items: [
                        ProfileSectionItem(
                          title: 'Выйти из аккаунта',
                          iconPath: 'assets/icons/logout.svg',
                          onTap: () {
                            // Handle logout
                          },
                        ),
                        ProfileSectionItem(
                          title: 'Удалить аккаунт',
                          iconPath: 'assets/icons/delete.svg',
                          titleColor: Colors.red,
                          onTap: () {
                            // Handle delete account
                          },
                        ),
                      ],
                    ),
                    // Legal Links
                    const LegalLinks(),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}


