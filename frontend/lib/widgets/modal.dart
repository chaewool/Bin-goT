import 'dart:io';

import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/date_picker.dart';
import 'package:bin_got/widgets/badge.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//* 빙고
class BingoModal extends StatelessWidget {
  final bool isDetail;
  final int index, cnt;
  const BingoModal(
      {super.key,
      required this.index,
      required this.cnt,
      required this.isDetail});

  @override
  Widget build(BuildContext context) {
    ReturnVoid moveBingo(bool toRight) {
      if (toRight) {
        if (index < cnt - 1) {
          return () {
            toBack(context: context)();
            showModal(
                context: context,
                page: BingoModal(
                  isDetail: isDetail,
                  index: index + 1,
                  cnt: cnt,
                ))();
          };
        }
      } else if (0 < index) {
        return () {
          toBack(context: context)();
          showModal(
              context: context,
              page: BingoModal(
                isDetail: isDetail,
                index: index - 1,
                cnt: cnt,
              ))();
        };
      }
      return () {};
    }

    return CustomModal(
      buttonText: '저장',
      additionalButton: isDetail
          ? null
          : CustomButton(
              content: '저장 후 닫기',
              onPressed: toBack(context: context),
            ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomIconButton(onPressed: moveBingo(false), icon: leftIcon),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(content: '${index + 1}/$cnt'),
                CustomInput(
                  explain: '이루고 싶은 목표를 설정해주세요',
                  needMore: true,
                  width: 200,
                  height: 200,
                  enabled: !isDetail,
                ),
              ],
            ),
            CustomIconButton(onPressed: moveBingo(true), icon: rightIcon)
          ],
        )
      ],
    );
  }
}

//* 날짜
class DateModal extends StatelessWidget {
  const DateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(child: DatePicker());
  }
}

//* 이미지
class ImageModal extends StatelessWidget {
  const ImageModal({super.key});

  @override
  Widget build(BuildContext context) {
    XFile? selectImage;
    void imagePicker() async {
      final ImagePicker picker = ImagePicker();
      selectImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 100,
        maxWidth: 100,
        imageQuality: 50,
      );
    }

    return CustomModal(title: '그룹 이미지 선택', hasConfirm: false, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CustomBoxContainer(
          width: 100,
          height: 100,
          borderColor: blackColor,
          image: selectImage != null
              ? DecorationImage(
                  fit: BoxFit.cover, image: FileImage(File(selectImage!.path)))
              : null,
          child: selectImage == null
              ? CustomIconButton(
                  icon: addIcon,
                  onPressed: imagePicker,
                )
              : null,
        ),
      ),
    ]);
  }
}

//* alert 기본
class CustomAlert extends StatelessWidget {
  final String title, content;
  final ReturnVoid? onPressed;
  final bool hasCancel;
  const CustomAlert({
    super.key,
    required this.title,
    required this.content,
    this.hasCancel = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(content: title),
      content: CustomText(content: content),
      actions: [
        CustomButton(
            onPressed: onPressed ?? toBack(context: context), content: '확인'),
        hasCancel
            ? const ExitButton(isIconType: false, buttonText: '취소')
            : const SizedBox(),
      ],
    );
  }
}

//* 배지 선택
class SelectBadgeModal extends StatefulWidget {
  final int presentBadge;
  const SelectBadgeModal({super.key, this.presentBadge = 0});

  @override
  State<SelectBadgeModal> createState() => _SelectBadgeModalState();
}

class _SelectBadgeModalState extends State<SelectBadgeModal> {
  late int badgeIdx;
  void selectBadge(int idx) {
    if (idx != badgeIdx) {
      setState(() {
        badgeIdx = idx;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    badgeIdx = widget.presentBadge;
  }

  @override
  Widget build(BuildContext context) {
    return CustomModal(
        title: '배지 선택',
        onPressed: toBack(context: context),
        children: [
          for (int i = 0; i < 4; i += 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 0; j < 3; j += 1)
                  ColWithPadding(
                    vertical: 8,
                    horizontal: 8,
                    children: [
                      CustomBadge(
                        onTap: () => selectBadge(3 * i + j),
                        boxShadow: 3 * i + j == badgeIdx
                            ? [
                                const BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    color: blueColor)
                              ]
                            : null,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(content: '배지명'),
                      )
                    ],
                  ),
              ],
            ),
        ]);
  }
}

//* 모달 기본
class CustomModal extends StatelessWidget {
  final String? title;
  final bool hasConfirm;
  final WidgetList children;
  final ReturnVoid? onPressed;
  final String buttonText;
  final Widget? additionalButton;
  const CustomModal({
    super.key,
    this.title,
    this.hasConfirm = true,
    required this.children,
    this.onPressed,
    this.buttonText = '적용',
    this.additionalButton,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: title != null
          ? Center(
              child: CustomText(
                content: title!,
                fontSize: FontSize.largeSize,
              ),
            )
          : const SizedBox(),
      children: [
        ...children,
        RowWithPadding(
          horizontal: additionalButton != null ? 30 : 50,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: additionalButton != null
              ? [
                  additionalButton!,
                  hasConfirm
                      ? CustomButton(
                          onPressed: onPressed ?? toBack(context: context),
                          content: buttonText,
                        )
                      : const SizedBox(),
                  const ExitButton(isIconType: false, buttonText: '취소'),
                ]
              : [
                  hasConfirm
                      ? CustomButton(
                          onPressed: onPressed ?? toBack(context: context),
                          content: buttonText,
                        )
                      : const SizedBox(),
                  const ExitButton(isIconType: false, buttonText: '취소'),
                ],
        )
      ],
    );
  }
}

//* 알림 설정
class NotificationModal extends StatefulWidget {
  const NotificationModal({super.key});

  @override
  State<NotificationModal> createState() => _NotificationModalState();
}

class _NotificationModalState extends State<NotificationModal> {
  StringList notificationList = [
    '진행률/랭킹 알림',
    '남은 기간 알림',
    '채팅 알림',
    '인증 완료 알림',
  ];
  List<StringList> notificationOptions = [
    ['ON', 'OFF'],
    ['세 달', '한 달', '일주일', '3일'],
    ['ON', 'OFF'],
    ['ON', 'OFF']
  ];
  IntList idxList = [0, 0, 0, 0];
  void changeIdx(int i) {
    if (i != 1) {
      setState(() {
        idxList[i] = 1 - idxList[i];
      });
    } else if (idxList[i] < 3) {
      setState(() {
        idxList[i] += 1;
      });
    } else {
      setState(() {
        idxList[i] = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      title: '알림 설정',
      children: [
        for (int i = 0; i < 4; i += 1)
          RowWithPadding(
            vertical: 10,
            horizontal: 25,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(content: notificationList[i]),
              CustomButton(
                content: notificationOptions[i][idxList[i]],
                onPressed: () => changeIdx(i),
              )
            ],
          )
      ],
    );
  }
}
