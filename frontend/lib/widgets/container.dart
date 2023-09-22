import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//* 그룹 메인 내용 출력
class ShowContentBox extends StatelessWidget {
  final String contentTitle, content;
  const ShowContentBox(
      {super.key, required this.contentTitle, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(content: contentTitle),
          const SizedBox(height: 20),
          CustomBoxContainer(
            width: 300,
            height: 100,
            borderColor: greyColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomText(content: content),
            ),
          )
        ],
      ),
    );
  }
}

//* 갤러리형 빙고 목록
class BingoGallery extends StatelessWidget {
  final MyBingoModel bingo;
  const BingoGallery({super.key, required this.bingo});

  @override
  Widget build(BuildContext context) {
    void toBingoDetail() {
      setStart(context, bingo.start);
      toOtherPage(context,
          page: InputPassword(
            isPublic: true,
            groupId: bingo.groupId,
            initialIndex: 0,
            bingoId: bingo.id,
            size: bingo.size,
          ))();
    }

    return GestureDetector(
      onTap: toBingoDetail,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomBoxContainer(
          color: greyColor.withOpacity(0.5),
          child: ColWithPadding(
            vertical: 8,
            horizontal: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomBoxContainer(
                  width: (getWidth(context) - 60) / 2,
                  height: (getWidth(context) - 60) / 2,
                  child: CachedNetworkImage(
                    imageUrl: '${dotenv.env['fileUrl']}/boards/${bingo.id}',
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => const CustomBoxContainer(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomText(
                  content: bingo.groupName,
                  cutText: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//* Box Container 기본 틀
class CustomBoxContainer extends StatelessWidget {
  final bool hasRoundEdge, center;
  final Color? borderColor;
  final Color color;
  final BoxShadowList? boxShadow;
  final double? width, height;
  final Widget? child;
  final DecorationImage? image;
  final ReturnVoid? onTap, onLongPress;
  final BorderRadiusGeometry? borderRadius;
  const CustomBoxContainer({
    super.key,
    this.hasRoundEdge = true,
    this.borderColor,
    this.color = whiteColor,
    this.boxShadow,
    this.width,
    this.height,
    this.image,
    this.child,
    this.onTap,
    this.onLongPress,
    this.center = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: center ? Alignment.center : null,
        decoration: BoxDecoration(
          borderRadius:
              borderRadius ?? (hasRoundEdge ? BorderRadius.circular(10) : null),
          color: color,
          boxShadow: boxShadow,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          image: image,
        ),
        child: child,
      ),
    );
  }
}

//* 원 모양 Container
class CircleContainer extends StatelessWidget {
  final double radius;
  final Widget child;
  final bool center, border;
  final List<BoxShadow>? boxShadow;
  final ReturnVoid? onTap;
  final Color? color;
  final Gradient? gradient;

  const CircleContainer({
    super.key,
    this.radius = 33,
    required this.child,
    this.center = true,
    this.boxShadow,
    this.onTap,
    this.color,
    this.border = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        alignment: center ? Alignment.center : null,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border ? Border.all(color: greyColor) : null,
          boxShadow: boxShadow,
          gradient: gradient,
        ),
        child: child,
      ),
    );
  }
}

//* animated container with page view
class CustomAnimatedPage extends StatelessWidget {
  final Widget nextPage;
  final Widget? appBar;
  final bool needScroll;
  const CustomAnimatedPage({
    super.key,
    required this.nextPage,
    this.appBar,
    this.needScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return needScroll
        ? Stack(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: nextPage,
                  ),
                ),
              ),
              if (appBar != null)
                CustomBoxContainer(
                  color: transparentColor,
                  width: getWidth(context),
                  height: 100,
                  child: appBar!,
                ),
            ],
          )
        : Stack(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: nextPage,
                ),
              ),
              if (appBar != null)
                CustomBoxContainer(
                  color: transparentColor,
                  width: getWidth(context),
                  height: 100,
                  child: appBar!,
                ),
            ],
          );
  }
}
