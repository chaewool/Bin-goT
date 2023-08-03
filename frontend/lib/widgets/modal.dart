import 'dart:io';

import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
      item['item_id'] = newIdx;
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
      buttonText: widget.isDetail ? '인증하기' : '초기화',
      cancelText: widget.isDetail ? '닫기' : '적용',
      onPressed: widget.isDetail
          ? showModal(context,
              page: RequestBingoModal(
                itemId: newIdx,
                // check: item['check'],
                checkGoal: item['check_goal'],
                afterClose: () => toBack(context),
              ))
          : initialize,
      onCancelPressed: widget.isDetail ? null : applyItem,
      hasConfirm: true,
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

class RequestBingoModal extends StatefulWidget {
  final int itemId, checkGoal;
  final ReturnVoid afterClose;
  const RequestBingoModal({
    super.key,
    required this.itemId,
    // required this.check,
    required this.checkGoal,
    required this.afterClose,
  });

  @override
  State<RequestBingoModal> createState() => _RequestBingoModalState();
}

class _RequestBingoModalState extends State<RequestBingoModal> {
  XFile? selectedImage;
  late DynamicMap data;

  @override
  void initState() {
    super.initState();
    data = {
      'item_id': widget.itemId,
      'content': '',
    };
  }

  void imagePicker() async {
    Permission.storage.request().then((value) {
      if (value == PermissionStatus.denied ||
          value == PermissionStatus.permanentlyDenied) {
        showAlert(
          context,
          title: '미디어 접근 권한 거부',
          content: '미디어 접근 권한이 없습니다. 설정에서 접근 권한을 허용해주세요',
          hasCancel: false,
        )();
      } else {
        final ImagePicker picker = ImagePicker();
        picker
            .pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        )
            .then((localImage) {
          setState(() {
            selectedImage = localImage;
          });
        });
      }
    });
  }

  void sendCompleteMessage() {
    BingoProvider()
        .makeCompleteMessage(
      getGroupId(context)!,
      FormData.fromMap({
        ...data,
        'img': selectedImage != null
            ? MultipartFile.fromFileSync(
                selectedImage!.path,
                contentType: MediaType('image', 'png'),
              )
            : null,
      }),
    )
        .then((value) {
      // showToast(context);
      toBack(context);
      widget.afterClose();
    });
  }

  void deleteImage() {
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      buttonText: '인증',
      onPressed: sendCompleteMessage,
      hasConfirm: true,
      children: [
        Center(child: CustomText(content: '총 달성 횟수 : ${widget.checkGoal}')),
        CustomInput(
          explain: '내용을 입력해주세요',
          needMore: true,
          width: 150,
          height: 200,
          fontSize: FontSize.textSize,
          initialValue: data['content'],
          setValue: (value) => data['content'] = value,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: selectedImage == null
              ? CustomBoxContainer(
                  onTap: imagePicker,
                  borderColor: greyColor,
                  hasRoundEdge: false,
                  width: 270,
                  height: 150,
                  child: CustomIconButton(
                    icon: addIcon,
                    onPressed: imagePicker,
                    color: greyColor,
                  ),
                )
              : CustomBoxContainer(
                  onTap: imagePicker,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(File(selectedImage!.path)),
                  ),
                  child: CustomIconButton(
                    onPressed: deleteImage,
                    icon: closeIcon,
                  ),
                ),
        ),
      ],
    );
  }
}

//* 닉네임
class ChangeNameModal extends StatelessWidget {
  final String? username;
  const ChangeNameModal({
    super.key,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    final newName = {'value': username};

    void changeName() {
      final newVal = newName['value'];
      if (newVal == null || newVal.trim() == '') {
        showAlert(context, title: '닉네임 오류', content: '올바른 닉네임을 입력해주세요')();
      } else if (username != newVal) {
        UserInfoProvider().changeName(newVal).then((_) {
          toBack(context);
          showAlert(context, title: '닉네임 변경 완료', content: '닉네임이 변경되었습니다.')();
        });
      } else {
        showAlert(context, title: '닉네임 오류', content: '닉네임이 변경되지 않았습니다')();
      }
    }

    void setName(String newVal) {
      newName['value'] = newVal.trim();
    }

    return InputModal(
      title: '닉네임 설정',
      type: '닉네임',
      setValue: setName,
      onPressed: changeName,
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
  final void Function(int) onPressed;
  const SelectBadgeModal({
    super.key,
    required this.presentBadge,
    required this.onPressed,
  });

  @override
  State<SelectBadgeModal> createState() => _SelectBadgeModalState();
}

class _SelectBadgeModalState extends State<SelectBadgeModal> {
  late int badgeId;
  void selectBadge(int id) {
    if (id != badgeId) {
      setState(() {
        badgeId = id;
      });
    }
  }

  void changeBadge() {
    UserInfoProvider().changeBadge({'badge_id': badgeId}).then((data) {
      print('성공 => $data');
      toBack(context);
      widget.onPressed(badgeId);
    }).catchError((_) {
      showAlert(
        context,
        title: '배지 변경 오류',
        content: '오류가 발생해 배지가 변경되지 않았습니다.',
      )();
    });
  }

  @override
  void initState() {
    super.initState();
    badgeId = widget.presentBadge;
  }

  @override
  Widget build(BuildContext context) {
    return CustomModal(title: '배지 선택', onPressed: changeBadge, children: [
      FutureBuilder(
          future: UserInfoProvider().getBadges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return SingleChildScrollView(
                child: CustomBoxContainer(
                  height: getHeight(context) * 0.6,
                  color: greyColor,
                  hasRoundEdge: false,
                  child: ListView.separated(
                    itemCount: data!.length ~/ 2,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return RowWithPadding(
                        mainAxisAlignment: MainAxisAlignment.center,
                        vertical: 8,
                        horizontal: 8,
                        children: [
                          for (int di = 0; di < 2; di += 1)
                            Column(
                              children: [
                                CircleContainer(
                                  onTap: () =>
                                      selectBadge(data[2 * index + di].id),
                                  boxShadow: data[2 * index + di].id == badgeId
                                      ? [
                                          const BoxShadow(
                                            blurRadius: 3,
                                            spreadRadius: 3,
                                            color: blueColor,
                                          )
                                        ]
                                      : null,
                                  child: Opacity(
                                    opacity:
                                        data[2 * index + di].hasBadge ? 1 : 0.2,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${dotenv.env['fileUrl']}/badges/${data[2 * index + di].id}',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomText(
                                    content: data[2 * index + di].name,
                                    fontSize: FontSize.smallSize,
                                  ),
                                )
                              ],
                            )
                        ],
                      );
                    },
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      // for (int i = 0; i < 4; i += 1)
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       for (int j = 0; j < 3; j += 1)
      //         ColWithPadding(
      //           vertical: 8,
      //           horizontal: 8,
      //           children: [
      //             CircleContainer(
      //               onTap: () => selectBadge(3 * i + j),
      //               boxShadow: 3 * i + j == badgeIdx
      //                   ? [
      //                       const BoxShadow(
      //                           blurRadius: 3,
      //                           spreadRadius: 3,
      //                           color: blueColor)
      //                     ]
      //                   : null,
      //               child: Image.network(
      //                   '${dotenv.env['fileUrl']}/badges/${3 * i + j}'),
      //             ),
      //             const Padding(
      //               padding: EdgeInsets.all(8.0),
      //               child: CustomText(content: '배지명'),
      //             )
      //           ],
      //         ),
      //     ],
      //   ),
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
  final String title, type;
  final void Function(String value) setValue;
  final ReturnVoid onPressed;
  final ReturnVoid? onCancelPressed;
  const InputModal({
    super.key,
    required this.title,
    required this.type,
    required this.setValue,
    required this.onPressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      title: title,
      onPressed: onPressed,
      onCancelPressed: onCancelPressed,
      children: [
        CustomInput(
          explain: '$type을 입력해주세요',
          maxLength: 20,
          setValue: setValue,
        ),
      ],
    );
  }
}
