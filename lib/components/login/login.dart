import 'package:flutter/material.dart';
import '../../pages/auth/verification_page.dart';
import '../../components/toast_service.dart';
import '../../services/auth_service.dart';
import 'login_header.dart';
import 'main_title.dart';
import 'privacy_policy.dart';
import 'segmented_control.dart';
import 'email_input.dart';
import 'get_code_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _selectedIndex = 0; // 0 for Автовладелец, 1 for Мастер
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailFilled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      final email = _emailController.text.trim();
      final isFilled = _isValidEmail(email);

      if (_isEmailFilled != isFilled) {
        setState(() {
          _isEmailFilled = isFilled;
        });
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleGetCode() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final role = _selectedIndex == 1 ? 'Master' : 'Driver';

      final result = await AuthService.loginWithEmail(
        email,
        role: role,
      );

      if (result['success'] == true) {
        // Show success message
        ToastService.showSuccess(
          context,
          message: result['message']?.toString() ?? 'Код отправлен на email!',
        );

        // Navigate to verification page
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(
                email: email,
                userType: _selectedIndex, // Pass selected user type
              ),
            ),
          );
        }
      } else {
        // Show error message
        ToastService.showError(
          context,
          message: result['message']?.toString() ?? 'Попробуйте позже',
        );
      }
    } catch (e) {
      ToastService.showError(
        context,
        message: 'Ошибка сети. Попробуйте позже.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const LoginHeader(),

        // Segmented Control
        SegmentedControl(
          selectedIndex: _selectedIndex,
          onChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),

        const SizedBox(height: 40),

        // Main content
        const MainTitle(),

        const SizedBox(height: 32),

        // Email input
        EmailInput(
          controller: _emailController,
          hintText: 'example@gmail.com',
        ),

        const SizedBox(height: 24),

        // Get code button
        GetCodeButton(
          onPressed: _isEmailFilled && !_isLoading ? _handleGetCode : null,
          isActive: _isEmailFilled && !_isLoading,
          isLoading: _isLoading,
        ),

        const SizedBox(height: 20),

        // Privacy policy text
        const PrivacyPolicy(),
      ],
    );
  }
}

