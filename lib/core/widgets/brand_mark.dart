import 'package:flutter/material.dart';

/// The "20 Min Fitness" brand mark, on a transparent background so it blends
/// into whatever surface it's placed on in both the light and dark theme.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/brand_mark.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
