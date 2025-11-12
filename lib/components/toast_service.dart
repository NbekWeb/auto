import 'package:flutter/material.dart';

class ToastService {
  static void showTopToast(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: const Offset(0, 0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: textColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  // Success toast
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showTopToast(
      context,
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  // Error toast
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showTopToast(
      context,
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  // Warning toast
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showTopToast(
      context,
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  // Info toast
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showTopToast(
      context,
      message: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      icon: Icons.info_outline,
      duration: duration,
    );
  }
}
