import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const PhoneInput({
    super.key,
    required this.controller,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Номер телефона',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.2,
            color: isDark ? AppColors.darkGrey : AppColors.lightTextSecondary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF4F5B63),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
              PhoneNumberFormatter(),
            ],
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? '+7 (777) 777-77-77',
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkGrey500 : AppColors.lightTextSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
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
