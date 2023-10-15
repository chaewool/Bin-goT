import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//? 컨테이너 응용

//* 그룹 메인 내용 출력
class ShowContentBox extends StatelessWidget {
  final String contentTitle, content;
  final bool hasContent;
  const ShowContentBox({
    super.key,
    required this.contentTitle,
    required this.content,
    this.hasContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            content: contentTitle,
          ),
          const SizedBox(height: 20),
          CustomBoxContainer(
            width: 300,
            height: 100,
            borderColor: greyColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomText(
                content: content,
                color: hasContent ? blackColor : greyColor.withOpacity(0.7),
              ),
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
      setPeriod(context, bingo.start, bingo.end);
      toOtherPageWithAnimation(context,
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
                  child: CustomCachedNetworkImage(
                    path: '/boards/${bingo.id}',
                    placeholder: const CustomBoxContainer(
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
  final Gradient? gradient;
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
    this.gradient,
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
          gradient: gradient,
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
