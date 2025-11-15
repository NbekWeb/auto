import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const EmailInput({
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
          'Email адрес',
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
              color: AppColors.inputBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              EmailInputFormatter(),
            ],
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? 'example@gmail.com',
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

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove commas, spaces, and other invalid characters
    final filteredText = text.replaceAll(RegExp(r'[, ]'), '');
    
    // Convert to lowercase for consistency
    final lowercaseText = filteredText.toLowerCase();
    
    return TextEditingValue(
      text: lowercaseText,
      selection: TextSelection.collapsed(offset: lowercaseText.length),
    );
  }
}
