import 'dart:io';

import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/date_picker.dart';
import 'package:bin_got/widgets/my_page_widgets.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//* 빙고
class BingoModal extends StatelessWidget {
  const BingoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Text('bingo!'),
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
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(),
              image: selectImage != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(selectImage!.path)))
                  : null),
          width: 100,
          height: 100,
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
      title: CustomText(content: title, fontSize: FontSize.textSize),
      content: CustomText(content: content, fontSize: FontSize.textSize),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                          child: CustomText(
                              content: '배지명', fontSize: FontSize.textSize),
                        )
                      ],
                    ),
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
  const CustomModal(
      {super.key,
      this.title,
      this.hasConfirm = true,
      required this.children,
      this.onPressed,
      this.buttonText = '적용'});

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
        hasConfirm
            ? CustomButton(onPressed: onPressed ?? () {}, content: buttonText)
            : const SizedBox(),
        const ExitButton(isIconType: false, buttonText: '취소'),
      ],
    );
  }
}

class NotificationModal extends StatelessWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomModal(title: '알림 설정', children: []);
  }
}
