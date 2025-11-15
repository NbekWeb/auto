import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/dashboard/profile/profile_header.dart';
import '../../components/dashboard/profile/profile_section.dart';
import '../../components/dashboard/profile/theme_selector.dart';
import '../../components/dashboard/profile/legal_links.dart';
import '../../components/dashboard/profile/custom_switch.dart';
import '../../components/dashboard/profile/fill_data_button.dart';
import '../../components/dashboard/profile/profile_content_wrapper.dart';
import '../../components/dashboard/profile/logout_confirmation_dialog.dart';
import '../../components/dashboard/profile/profile_loading_indicator.dart';
import '../../services/user_service.dart';
import '../../services/cars_service.dart';
import '../../services/auth_service.dart';
import '../../constants/navigator_key.dart';
import '../../components/toast_service.dart';
import 'faq_page.dart';
import 'profile_edit_page.dart';
import 'my_garage_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _isDarkMode = true;
  bool _isLoading = true;
  
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadCars();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    final result = await UserService.getUserProfile();
    
    if (result['success'] == true && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      // API response structure: {success: true, user: {...}}
      final userData = data['user'] ?? data;
      
      setState(() {
        _userData = userData as Map<String, dynamic>?;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCars() async {
    final result = await CarsService.getCarsAll();
    
    if (result['success'] == true) {
      setState(() {
        // Cars are already stored in CarsService.cars
      });
    } else {
      print('🔴 Error loading cars: ${result['message']}');
      print('🔴 Error data: ${result['error']}');
    }
  }

  String _getFullName() {
    if (_userData == null) return '';
    final firstName = _userData!['first_name']?.toString() ?? '';
    final lastName = _userData!['last_name']?.toString() ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }
    return 'Ваше имя';
  }

  String _getCity() {
    if (_userData == null) return 'Ваш город';
    return _userData!['address']?.toString() ?? 'Ваш город';
  }

  String _getUserId() {
    if (_userData == null) return '';
    return _userData!['id']?.toString() ?? '';
  }

  String? _getAvatarUrl() {
    if (_userData == null) return null;
    return _userData!['avatar']?.toString();
  }

  bool _shouldShowFillDataButton() {
    if (_userData == null) return true;
    final firstName = _userData!['first_name']?.toString() ?? '';
    final lastName = _userData!['last_name']?.toString() ?? '';
    return firstName.isEmpty && lastName.isEmpty;
  }

  bool _shouldShowEditIcon() {
    if (_userData == null) return false;
    final firstName = _userData!['first_name']?.toString() ?? '';
    final lastName = _userData!['last_name']?.toString() ?? '';
    return firstName.isNotEmpty || lastName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const ProfileLoadingIndicator();
    }

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
              name: _getFullName(),
              city: _getCity(),
              userId: _getUserId(),
              avatarUrl: _getAvatarUrl(),
              showEditIcon: _shouldShowEditIcon(),
              onEdit: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileEditPage(),
                  ),
                );
                if (result == true) {
                  _loadUserProfile();
                  _loadCars();
                }
              },
            ),
            // Fill Data Button - only show if both first_name and last_name are empty
            if (_shouldShowFillDataButton()) ...[
              FillDataButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditPage(),
                    ),
                  );
                  if (result == true) {
                    _loadUserProfile();
                    _loadCars();
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
            // Wrapper for all sections from "Мой гараж" to "Политика конфиденциальности"
            ProfileContentWrapper(
              children: [
                    // Settings Section
                    ProfileSection(
                      title: 'Настройки',
                      items: [
                        ProfileSectionItem(
                          title: 'Мой гараж',
                          iconPath: 'assets/icons/garaj.svg',
                          subtitle: '${CarsService.cars.length} ТС',
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyGaragePage(),
                              ),
                            );
                            if (result == true) {
                              _loadCars();
                            }
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
                            _handleLogout();
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
          ],
        ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => const LogoutConfirmationDialog(),
    );

    if (shouldLogout == true) {
      final result = await AuthService.logout();

      if (result['success'] == true) {
        // Clear cars data
        CarsService.clearCars();

        // Navigate to login page
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        } else {
          // Fallback: use context navigator
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        }
      } else {
        if (mounted) {
          ToastService.showError(
            context,
            message: result['message'] ?? 'Ошибка выхода из аккаунта',
          );
        }
      }
    }
  }
}


