import 'package:flutter/material.dart';
import '../../colors.dart';

class SegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF343F47),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Автовладелец button
          Expanded(
            child: _buildButton(
              text: 'Автовладелец',
              isSelected: selectedIndex == 0,
              isLeft: true,
              isDark: isDark,
              onTap: () => onChanged(0),
            ),
          ),
          
          // Мастер button
          Expanded(
            child: _buildButton(
              text: 'Мастер',
              isSelected: selectedIndex == 1,
              isLeft: false,
              isDark: isDark,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isSelected,
    required bool isLeft,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: isLeft
              ? const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
        ),
        child: isSelected
            ? Stack(
                children: [
                  // Inner shadow effect using multiple gradient overlays
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: isLeft
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.center,
                        colors: [
                          Color(0x661A0900),
                          Color(0x331A0900),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.2, 0.5],
                      ),
                    ),
                  ),
                  // Additional inner shadow from top
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: isLeft
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x4D1A0900),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.3],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
      ),
    );
  }
}
