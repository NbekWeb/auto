import 'package:flutter/material.dart';
import '../../../colors.dart';

class ThemeSelector extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Text(
            'Тема',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: 'Manrope',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E272F) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF252F37) : const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  label: 'Светлая',
                  isSelected: !isDarkMode,
                  onTap: () => onThemeChanged(false),
                ),
              ),
              Expanded(
                child: _ThemeOption(
                  label: 'Темная',
                  isSelected: isDarkMode,
                  onTap: () => onThemeChanged(true),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF771C)
              : (isDark ? const Color(0xFF1E272F) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkText : AppColors.lightText),
              fontFamily: 'Manrope',
            ),
          ),
        ),
      ),
    );
  }
}

