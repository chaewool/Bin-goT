import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

//* network image
class CustomCachedNetworkImage extends StatelessWidget {
  final String path;
  final double width, height;
  final BoxFit fit;
  final Widget? placeholder;
  const CustomCachedNetworkImage({
    super.key,
    required this.path,
    this.width = 33,
    this.height = 33,
    this.fit = BoxFit.fitWidth,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        placeholder: (context, url) =>
            placeholder ?? SizedBox(width: width, height: height),
        imageUrl: '${dotenv.env['fileUrl']}$path',
        imageBuilder: (context, imageProvider) => CustomBoxContainer(
          width: width,
          height: height,
          color: transparentColor,
          hasRoundEdge: false,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
        errorWidget: (context, url, error) => CustomBoxContainer(
          width: width,
          height: height,
          child: const CustomIcon(icon: errorIcon),
        ),
      );
    } catch (_) {
      return CustomBoxContainer(
        width: width,
        height: height,
        child: const CustomIcon(icon: errorIcon),
      );
    }
  }
}
