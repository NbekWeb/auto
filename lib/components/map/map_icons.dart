import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapIcons {
  // Create a simple location marker icon
  static Widget createLocationIcon({double size = 24, Color color = Colors.red}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FaIcon(
        FontAwesomeIcons.locationDot,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  // Create a service marker icon
  static Widget createServiceIcon({
    double size = 24,
    Color color = Colors.blue,
    IconData icon = FontAwesomeIcons.wrench,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FaIcon(
        icon,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  // Convert widget to bytes for Yandex Maps
  static Future<Uint8List> widgetToBytes(Widget widget) async {
    // Use RepaintBoundary widget instead of RenderRepaintBoundary
    final repaintBoundary = RepaintBoundary(
      child: Container(
        width: 48,
        height: 48,
        child: widget,
      ),
    );

    // Create a simple approach - for now return empty bytes
    // This method can be implemented later when needed
    return Uint8List(0);
  }
}
