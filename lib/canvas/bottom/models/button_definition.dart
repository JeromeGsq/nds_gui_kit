import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Button definition for hit testing and rendering
class ButtonDefinition {
  final Rect rect;
  final String id;
  final bool isLarge;
  final ui.Image image;
  final ui.Image? pressedImage;

  const ButtonDefinition({
    required this.rect,
    required this.id,
    required this.isLarge,
    required this.image,
    this.pressedImage,
  });

  /// Check if this button is a favorite button
  bool get isFavoriteButton => id.startsWith('favorite_');

  /// Get the favorite index if this is a favorite button
  int? get favoriteIndex {
    if (!isFavoriteButton) return null;
    return int.tryParse(id.split('_')[1]);
  }

  /// Check if a point is within this button's bounds
  bool containsPoint(Offset point) => rect.contains(point);
}

