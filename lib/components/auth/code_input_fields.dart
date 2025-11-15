import 'package:flutter/material.dart';
import '../../colors.dart';

class CodeInputFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int currentIndex;
  final bool showError;
  final double errorOpacity;
  final Function(String, int) onDigitChanged;
  final Function(int) onFieldTap;

  const CodeInputFields({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.currentIndex,
    required this.showError,
    required this.errorOpacity,
    required this.onDigitChanged,
    required this.onFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Code input fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: showError
                      ? AppColors.error
                      : currentIndex == index
                          ? AppColors.orangeSelected
                          : AppColors.inputBorder,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) {
                  onDigitChanged(value, index);
                },
                onTap: () {
                  onFieldTap(index);
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty && index < 3) {
                    focusNodes[index + 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),
        // Error message
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: errorOpacity,
          duration: const Duration(milliseconds: 300),
          child: const Text(
            'Неверный код',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

