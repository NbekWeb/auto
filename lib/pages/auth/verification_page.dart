import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/toast_service.dart';
import '../../components/auth/verification_header.dart';
import '../../components/auth/email_display.dart';
import '../../components/auth/code_input_fields.dart';
import '../../components/auth/resend_code_button.dart';
import '../../layouts/dashboard_layout.dart';
import '../../services/auth_service.dart';
import 'master_setup_page.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final int userType; // 0 for Автовладелец, 1 for Мастер

  const VerificationPage({super.key, required this.email, this.userType = 0});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  int _currentIndex = 0;
  int _countdown = 59;
  bool _canResend = false;
  bool _showError = false;
  double _errorOpacity = 0.0;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _countdown--;
          if (_countdown <= 0) {
            _canResend = true;
            print("Button is now active! Countdown finished.");
          } else {
            _startCountdown();
          }
        });
      }
    });
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      _checkCode();
    } else {
      // When digit is deleted
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      // Always clear error when deleting digits
      setState(() {
        _showError = false;
        _errorOpacity = 0.0;
      });
    }
  }

  void _handleFieldTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _checkCode() async {
    String enteredCode = _controllers
        .map((controller) => controller.text)
        .join();
    if (enteredCode.length == 4 && !_isVerifying) {
      setState(() {
        _isVerifying = true;
      });

      try {
        final role = widget.userType == 1 ? 'Master' : 'Driver';
        final result = await AuthService.verifyCode(
          widget.email,
          enteredCode,
          role: role,
        );
        
        if (result['success'] == true) {
          // Code is correct, proceed to next step
          ToastService.showSuccess(
            context,
            message: result['message']?.toString() ?? 'Код подтвержден успешно!',
          );
          _handleCorrectCode();
        } else {
          // Show error message
          ToastService.showError(
            context,
            message: result['message']?.toString() ?? 'Неверный код',
          );
          setState(() {
            _showError = true;
            _errorOpacity = 1.0;
          });
        }
      } catch (e) {
        // Show error on network issues
        ToastService.showError(context, message: 'Ошибка сети. Попробуйте позже.');
        setState(() {
          _showError = true;
          _errorOpacity = 1.0;
        });
      } finally {
        setState(() {
          _isVerifying = false;
        });
      }
    } else if (enteredCode.length < 4) {
      // Hide error when less than 4 digits
      setState(() {
        _showError = false;
        _errorOpacity = 0.0;
      });
    }
  }

  void _handleCorrectCode() {
    // Navigate based on user type
    if (widget.userType == 1) {
      // Master - go to master setup page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MasterSetupPage(),
        ),
      );
    } else {
      // Автовладелец - go to dashboard with map page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardLayout(),
        ),
      );
    }
  }

  void _sendCode() async {
    if (_isVerifying) return;
    
    setState(() {
      _isVerifying = true;
    });

    try {
      final role = widget.userType == 1 ? 'Master' : 'Driver';
      final result = await AuthService.loginWithEmail(
        widget.email,
        role: role,
      );
      
      if (result['success'] == true) {
        // Reset countdown
        setState(() {
          _countdown = 59;
          _canResend = false;
          _showError = false;
          _errorOpacity = 0.0;
        });
        
        // Clear all input fields
        for (var controller in _controllers) {
          controller.clear();
        }
        
        // Show success message
        ToastService.showSuccess(
          context,
          message: result['message']?.toString() ?? 'Код отправлен повторно на email!',
        );
        
        // Start countdown
        _startCountdown();
      } else {
        // Show error message
        ToastService.showError(
          context,
          message: result['message']?.toString() ?? 'Попробуйте позже',
        );
      }
    } catch (e) {
      ToastService.showError(context, message: 'Ошибка сети. Попробуйте позже.');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Подтверждение кода',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const VerificationHeader(),
                const SizedBox(height: 8),
                EmailDisplay(
                  email: widget.email,
                  onEdit: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 40),
                CodeInputFields(
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                  currentIndex: _currentIndex,
                  showError: _showError,
                  errorOpacity: _errorOpacity,
                  onDigitChanged: (value, index) {
                    setState(() {
                      _currentIndex = index;
                      // Clear error when user starts typing
                      if (value.isNotEmpty && _showError) {
                        _showError = false;
                        _errorOpacity = 0.0;
                      }
                    });
                    _onDigitChanged(value, index);
                  },
                  onFieldTap: _handleFieldTap,
                ),
                const SizedBox(height: 40),
                ResendCodeButton(
                  canResend: _canResend,
                  countdown: _countdown,
                  isVerifying: _isVerifying,
                  onPressed: _sendCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
