import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../colors.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  @override
  State<CustomSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _hasText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Найти СТО, мойки и другое',
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 14,
          ),
          prefixIcon: _hasText
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: GestureDetector(
                    onTap: _clearSearch,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                )
              : null,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

