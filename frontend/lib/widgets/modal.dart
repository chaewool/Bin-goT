import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 빙고
class BingoModal extends StatefulWidget {
  final bool isDetail;
  final int index, cnt;
  const BingoModal({
    super.key,
    required this.index,
    required this.cnt,
    required this.isDetail,
  });

  @override
  State<BingoModal> createState() => _BingoModalState();
}

class _BingoModalState extends State<BingoModal> {
  late DynamicMap item;
  late int newIdx;

  @override
  void initState() {
    super.initState();
    newIdx = widget.index;
    item = {...readItem(context, newIdx)};
  }

  void initialize() {
    setState(() {
      item['title'] = null;
      item['content'] = null;
      item['check'] = false;
      item['check_goal'] = '0';
    });
    setItem(context, newIdx, item);
  }

  @override
  Widget build(BuildContext context) {
    void moveBingo(bool toRight) {
      setItem(context, newIdx, item);
      if (toRight) {
        if (newIdx < widget.cnt - 1) {
          setState(() {
            newIdx += 1;
            item = {...readItem(context, newIdx)};
          });
        }
      } else if (newIdx > 0) {
        setState(() {
          newIdx -= 1;
          item = {...readItem(context, newIdx)};
        });
      }
    }

    void Function(bool?) changeCheckState(bool? state) {
      return (bool? state) => setState(() {
            item['check'] = state;
          });
    }

    void applyItem() {
      setItem(context, newIdx, item);
      print(readItem(context, newIdx));
      toBack(context);
    }

    return CustomModal(
      buttonText: '초기화',
      cancelText: widget.isDetail ? '확인' : '적용',
      onPressed: widget.isDetail ? null : initialize,
      onCancelPressed: widget.isDetail ? null : applyItem,
      hasConfirm: !widget.isDetail,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(content: '${newIdx + 1}/${widget.cnt}'),
            CustomInput(
              width: 170,
              height: 50,
              explain: '제목',
              setValue: (value) => item['title'] = value,
              initialValue: item['title'],
              enabled: !widget.isDetail,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomIconButton(
                  onPressed: () => moveBingo(false),
                  icon: leftIcon,
                  size: 40,
                ),
                CustomInput(
                  explain: '이루고 싶은 목표를 설정해주세요',
                  needMore: true,
                  width: 150,
                  height: 200,
                  enabled: !widget.isDetail,
                  fontSize: FontSize.textSize,
                  initialValue: item['content'],
                  setValue: (value) => item['content'] = value,
                ),
                CustomIconButton(
                  onPressed: () => moveBingo(true),
                  icon: rightIcon,
                  size: 40,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !widget.isDetail || item['check']
                    ? CustomCheckBox(
                        label: widget.isDetail ? '달성/목표' : '횟수 체크',
                        onChange:
                            widget.isDetail ? null : changeCheckState(false),
                        value: item['check'] ?? false,
                      )
                    : const SizedBox(),
                item['check']
                    ? CustomInput(
                        enabled: !widget.isDetail,
                        width: 60,
                        height: 30,
                        onlyNum: true,
                        setValue: (value) => item['check_goal'] = value,
                        initialValue: widget.isDetail
                            ? '${item['check_cnt'] ?? 0}/${item['check_goal']}'
                            : item['check_goal'].toString(),
                      )
                    : const SizedBox(),
                item['check']
                    ? const CustomText(
                        content: '회',
                        fontSize: FontSize.smallSize,
                      )
                    : const SizedBox()
              ],
            ),
          ],
        )
      ],
    );
  }
}

//* 날짜
// class DateModal extends StatelessWidget {
//   const DateModal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Dialog(child: DatePicker());
//   }
// }

//* 이미지
// class ImageModal extends StatefulWidget {
//   final XFile? image;
//   final ReturnVoid imagePicker, deleteImage;
//   const ImageModal({
//     super.key,
//     required this.image,
//     required this.imagePicker,
//     required this.deleteImage,
//   });

//   @override
//   State<ImageModal> createState() => _ImageModalState();
// }

// class _ImageModalState extends State<ImageModal> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomModal(title: '그룹 이미지 선택', hasConfirm: false, children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: CustomBoxContainer(
//           width: 100,
//           height: 100,
//           borderColor: blackColor,
//           image: widget.image != null
//               ? DecorationImage(
//                   fit: BoxFit.cover,
//                   image: FileImage(File(widget.image!.path)),
//                 )
//               : null,
//           child: widget.image == null
//               ? CustomIconButton(
//                   icon: addIcon,
//                   onPressed: widget.imagePicker,
//                 )
//               : CustomIconButton(
//                   onPressed: widget.deleteImage,
//                   icon: closeIcon,
//                 ),
//         ),
//       ),
//     ]);
//   }
// }

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
            onPressed: onPressed ?? () => toBack(context), content: '확인'),
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
        onPressed: () => toBack(context),
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
                      CircleContainer(
                        onTap: () => selectBadge(3 * i + j),
                        boxShadow: 3 * i + j == badgeIdx
                            ? [
                                const BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    color: blueColor)
                              ]
                            : null,
                        child: halfLogo,
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
  final ReturnVoid? onPressed, onCancelPressed;
  final String buttonText, cancelText;
  const CustomModal({
    super.key,
    this.title,
    this.hasConfirm = true,
    required this.children,
    this.onPressed,
    this.buttonText = '적용',
    this.cancelText = '취소',
    this.onCancelPressed,
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
            horizontal: 50,
            mainAxisAlignment: hasConfirm
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              hasConfirm
                  ? CustomButton(
                      onPressed: onPressed ?? () => toBack(context),
                      content: buttonText,
                    )
                  : const SizedBox(),
              onCancelPressed == null
                  ? ExitButton(isIconType: false, buttonText: cancelText)
                  : CustomButton(
                      onPressed: onCancelPressed!,
                      content: cancelText,
                    ),
            ])
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

//* 입력창이 있는 모달
class InputModal extends StatelessWidget {
  final String title;
  const InputModal({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomModal(title: title, children: [
      CustomInput(
        explain: '닉네임을 입력해주세요',
        maxLength: 20,
        setValue: (p0) {},
      ),
    ]);
  }
}
