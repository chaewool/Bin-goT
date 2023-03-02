import 'package:flutter/material.dart';

class ModifiedImage extends StatelessWidget {
  final String image;
  final double width, height;
  final BoxFit fit;
  const ModifiedImage({
    super.key,
    required this.image,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
