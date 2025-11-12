import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/toast_service.dart';
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
              const SizedBox(height: 40),

              // Main title
              Center(
                child: Text(
                  'Введите код из email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Мы отправили его на email',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),

              const SizedBox(height: 8),

              // Email with change option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Изменить',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFFFF8635),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: _showError
                              ? const Color(0xFFF64242)
                              : _currentIndex == index
                              ? const Color(0xFFFF8635)
                              : const Color(0xFF4F5B63),
                          width: 1,
                        ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
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
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              // Error message
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _errorOpacity,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'Неверный код',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFF64242),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Resend button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: _canResend
                      ? const LinearGradient(
                          begin: Alignment(-0.8, -0.6),
                          end: Alignment(0.8, 0.6),
                          colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                          stops: [0.0, 1.0],
                        )
                      : null,
                  color: _canResend
                      ? null
                      : (isDark
                          ? const Color(0xFF343F47)
                          : const Color(0xFFF5F5F5)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _canResend
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF68324).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _canResend ? _sendCode : null,
                    child: Center(
                      child: _isVerifying
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _canResend ? Colors.white : (isDark
                                      ? const Color(0xFF818B93)
                                      : AppColors.lightTextSecondary),
                                ),
                              ),
                            )
                          : Text(
                              _canResend
                                  ? 'Отправить код повторно'
                                  : 'Отправить код повторно через $_countdown',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _canResend
                                    ? Colors.white
                                    : (isDark
                                        ? const Color(0xFF818B93)
                                        : AppColors.lightTextSecondary),
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
    );
  }
}
