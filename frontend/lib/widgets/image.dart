import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:flutter/material.dart';

//? 이미지

class ModifiedImage extends StatelessWidget {
  final String image;
  final double width, height;
  final BoxFit fit;
  final BoxShadowList? boxShadow;
  const ModifiedImage({
    super.key,
    required this.image,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      hasRoundEdge: false,
      boxShadow: boxShadow,
      child: Image.asset(
        image,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
