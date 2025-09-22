import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';
import '../../pages/auth/verification_page.dart';
import 'login_header.dart';
import 'main_title.dart';
import 'privacy_policy.dart';
import 'segmented_control.dart';
import 'phone_input.dart';
import 'get_code_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _selectedIndex = 0; // 0 for Автовладелец, 1 for Мастер
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneFilled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      final phoneDigits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      final isFilled = phoneDigits.length == 11;
      
   
      if (_isPhoneFilled != isFilled) {
        setState(() {
          _isPhoneFilled = isFilled;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
        
        // Phone number input
        PhoneInput(
          controller: _phoneController,
          hintText: '+7 (777) 777-77-77',
        ),
        
        const SizedBox(height: 24),
        
        // Get code button
        GetCodeButton(
          onPressed: _isPhoneFilled ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationPage(
                  phoneNumber: _phoneController.text,
                ),
              ),
            );
          } : null,
          isActive: _isPhoneFilled,
        ),
        
        const SizedBox(height: 20),
        
        // Privacy policy text
        const PrivacyPolicy(),
      ],
    );
  }

}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to 11 digits
    final limitedDigits = digitsOnly.length > 11 
        ? digitsOnly.substring(0, 11) 
        : digitsOnly;
    
    // Format the phone number
    String formatted = '';
    if (limitedDigits.isNotEmpty) {
      if (limitedDigits.length >= 1) {
        formatted = '+7';
      }
      if (limitedDigits.length >= 2) {
        formatted = '+7 (${limitedDigits.substring(1, limitedDigits.length > 4 ? 4 : limitedDigits.length)}';
      }
      if (limitedDigits.length >= 5) {
        formatted = '+7 (${limitedDigits.substring(1, 4)}) ${limitedDigits.substring(4, limitedDigits.length > 7 ? 7 : limitedDigits.length)}';
      }
      if (limitedDigits.length >= 8) {
        formatted = '+7 (${limitedDigits.substring(1, 4)}) ${limitedDigits.substring(4, 7)}-${limitedDigits.substring(7, limitedDigits.length > 9 ? 9 : limitedDigits.length)}';
      }
      if (limitedDigits.length >= 10) {
        formatted = '+7 (${limitedDigits.substring(1, 4)}) ${limitedDigits.substring(4, 7)}-${limitedDigits.substring(7, 9)}-${limitedDigits.substring(9, limitedDigits.length > 11 ? 11 : limitedDigits.length)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
