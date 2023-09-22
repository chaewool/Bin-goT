import 'dart:io';

import 'package:bin_got/oss_licenses.dart';
import 'package:bin_got/pages/license_detail_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
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
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

//* 빙고 칸 내용 입력
class BingoFormModal extends StatefulWidget {
  final int index, cnt;
  const BingoFormModal({
    super.key,
    required this.index,
    required this.cnt,
  });

  @override
  State<BingoFormModal> createState() => _BingoFormModalState();
}

class _BingoFormModalState extends State<BingoFormModal> {
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
      item['check_goal'] = 2;
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

    void Function(bool) changeCheckState(bool state) {
      return (bool state) => setState(() {
            item['check'] = state;
          });
    }

    void applyItem() {
      setItem(context, newIdx, item);
      print(readItem(context, newIdx));
      toBack(context);
    }

    return CustomModal(
      cancelText: '초기화',
      buttonText: '적용',
      onCancelPressed: initialize,
      onPressed: applyItem,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(content: '${newIdx + 1}/${widget.cnt}'),
            Row(
              children: [
                CustomIconButton(
                  onPressed: () => moveBingo(false),
                  icon: leftIcon,
                  size: 40,
                  color: newIdx > 0 ? palePinkColor : greyColor,
                ),
                Expanded(
                  child: ColWithPadding(
                    vertical: 10,
                    horizontal: 5,
                    children: [
                      const RowWithPadding(
                        vertical: 12,
                        children: [
                          CustomText(
                            content: '빙고칸 제목',
                            fontSize: FontSize.smallSize,
                          ),
                          SizedBox(width: 5),
                          CustomText(
                            content: '(필수)',
                            fontSize: FontSize.tinySize,
                            color: greyColor,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInput(
                              // width: 170,
                              height: 50,
                              explain: '제목을 입력하세요',
                              setValue: (value) => item['title'] = value,
                              initialValue: item['title'],
                            ),
                          ),
                        ],
                      ),
                      const RowWithPadding(
                        vertical: 12,
                        children: [
                          CustomText(
                            content: '빙고칸 내용',
                            fontSize: FontSize.smallSize,
                          ),
                          SizedBox(width: 5),
                          CustomText(
                            content: '(선택)',
                            fontSize: FontSize.tinySize,
                            color: greyColor,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInput(
                              explain: '이루고 싶은 목표를\n설정해주세요',
                              needMore: true,
                              fontSize: FontSize.textSize,
                              initialValue: item['content'],
                              setValue: (value) => item['content'] = value,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            content: '횟수 체크',
                            fontSize: FontSize.smallSize,
                          ),
                          CustomSwitch(
                            value: item['check'] ?? false,
                            onChanged: changeCheckState(false),
                          ),
                          if (item['check'])
                            Row(
                              children: [
                                CustomInput(
                                  width: 45,
                                  height: 40,
                                  onlyNum: true,
                                  explain: '2 이상의 숫자',
                                  setValue: (value) =>
                                      item['check_goal'] = value,
                                  initialValue: item['check_goal'].toString(),
                                ),
                                const SizedBox(width: 5),
                                const CustomText(
                                  content: '회',
                                  fontSize: FontSize.smallSize,
                                )
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                CustomIconButton(
                  onPressed:
                      newIdx < widget.cnt - 1 ? () => moveBingo(true) : () {},
                  icon: rightIcon,
                  size: 40,
                  color: newIdx < widget.cnt - 1 ? palePinkColor : greyColor,
                )
              ],
            ),
            CustomText(
              content:
                  item['check'] ? '목표 달성 횟수를 설정합니다.' : '목표 달성 횟수를 설정하지 않습니다.',
              fontSize: FontSize.smallSize,
              color: greyColor,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CustomText(
                content: '* 시작일 전에 변경 가능합니다.',
                fontSize: FontSize.tinySize,
                color: greyColor,
              ),
            )
          ],
        )
      ],
    );
  }
}

//* 빙고 칸 내용 출력
class BingoDetailModal extends StatefulWidget {
  final int index, cnt;
  const BingoDetailModal({
    super.key,
    required this.index,
    required this.cnt,
  });

  @override
  State<BingoDetailModal> createState() => _BingoDetailModalState();
}

class _BingoDetailModalState extends State<BingoDetailModal> {
  late DynamicMap item;
  late int newIdx;

  @override
  void initState() {
    super.initState();
    newIdx = widget.index;
    item = {...readItem(context, newIdx)};
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

    return CustomModal(
      buttonText: '인증하기',
      cancelText: '닫기',
      onPressed: showModal(
        context,
        page: RequestBingoModal(
          itemId: newIdx,
          checkGoal: item['check_goal'],
          afterClose: () => toBack(context),
        ),
      ),
      hasConfirm: alreadyStarted(context) == true &&
          myBingoId(context) == getBingoId(context),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(content: '${newIdx + 1}/${widget.cnt}'),
            Row(
              children: [
                CustomIconButton(
                  onPressed: () => moveBingo(false),
                  icon: leftIcon,
                  size: 40,
                  color: newIdx > 0 ? palePinkColor : greyColor,
                ),
                Expanded(
                  child: ColWithPadding(
                    vertical: 20,
                    horizontal: 10,
                    children: [
                      Center(
                        child: Expanded(
                          child: CustomText(
                            content: item['title'],
                            fontSize: FontSize.largeSize,
                          ),
                        ),
                      ),
                      const CustomDivider(),
                      Center(
                        child: CustomText(
                          content: item['content'],
                        ),
                      ),
                      if (item['check'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: CustomText(
                              content:
                                  '목표 횟수 ${item['check_goal']}회 중 ${item['check_cnt']}회 달성',
                              fontSize: FontSize.smallSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                CustomIconButton(
                  onPressed:
                      newIdx < widget.cnt - 1 ? () => moveBingo(true) : () {},
                  icon: rightIcon,
                  size: 40,
                  color: newIdx < widget.cnt - 1 ? palePinkColor : greyColor,
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}

//* 빙고 인증 모달
class RequestBingoModal extends StatefulWidget {
  final int itemId, checkGoal;
  final ReturnVoid afterClose;
  const RequestBingoModal({
    super.key,
    required this.itemId,
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

  void requestImagePicker() {
    return imagePicker(context, thenFunc: (localImage) {
      if (localImage != null) {
        setState(() {
          selectedImage = localImage;
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
      showToast(context);
      setToastString(context, '인증 채팅이 생성되었습니다');
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
    return SingleChildScrollView(
      child: CustomModal(
        backgroundColor: palePinkColor.withOpacity(0.65),
        buttonText: '인증',
        onPressed: sendCompleteMessage,
        hasConfirm: true,
        children: [
          const CustomText(
            content: '인증하기',
            fontSize: FontSize.largeSize,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomText(
              content: '총 달성 횟수 : ${widget.checkGoal}',
              fontSize: FontSize.tinySize,
              color: greyColor,
            ),
          ),
          ColWithPadding(
            vertical: 10,
            horizontal: 30,
            children: [
              const RowWithPadding(
                vertical: 12,
                children: [
                  CustomText(
                    content: '인증 내용',
                    fontSize: FontSize.smallSize,
                  ),
                  SizedBox(width: 5),
                  CustomText(
                    content: '(필수)',
                    fontSize: FontSize.tinySize,
                    color: greyColor,
                  ),
                ],
              ),
              CustomInput(
                explain: '내용을 입력해주세요',
                filled: true,
                needMore: true,
                height: 100,
                fontSize: FontSize.textSize,
                initialValue: data['content'],
                setValue: (value) => data['content'] = value,
              ),
              const SizedBox(height: 10),
              const RowWithPadding(
                vertical: 12,
                children: [
                  CustomText(
                    content: '인증 사진',
                    fontSize: FontSize.smallSize,
                  ),
                  SizedBox(width: 5),
                  CustomText(
                    content: '(선택)',
                    fontSize: FontSize.tinySize,
                    color: greyColor,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: selectedImage == null
                    ? CustomBoxContainer(
                        onTap: requestImagePicker,
                        borderColor: greyColor,
                        hasRoundEdge: false,
                        width: 270,
                        height: 150,
                        child: CustomIconButton(
                          icon: addIcon,
                          onPressed: requestImagePicker,
                          color: greyColor,
                        ),
                      )
                    : CustomBoxContainer(
                        onTap: requestImagePicker,
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
          ),
        ],
      ),
    );
  }
}

//* 닉네임
class ChangeNameModal extends StatelessWidget {
  final String? username;
  final void Function(String)? afterWork;
  const ChangeNameModal({
    super.key,
    this.username,
    this.afterWork,
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
          if (afterWork != null) {
            afterWork!(newVal);
          }
          toBack(context);
          showAlert(
            context,
            title: '닉네임 변경 완료',
            content: '닉네임이 변경되었습니다.',
            hasCancel: false,
          )();
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
      content: CustomText(
        content: content,
        height: 1.4,
      ),
      actions: [
        CustomButton(
          color: palePinkColor,
          onPressed: onPressed ?? () => toBack(context),
          content: '확인',
          textColor: whiteColor,
        ),
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
    return CustomModal(
      title: '배지 선택',
      onPressed: changeBadge,
      children: [
        FutureBuilder(
          future: UserInfoProvider().getBadges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return SingleChildScrollView(
                child: CustomBoxContainer(
                  height: getHeight(context) * 0.6,
                  color: whiteColor,
                  hasRoundEdge: false,
                  child: ListView.separated(
                    itemCount: data!.length ~/ 2,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return RowWithPadding(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        vertical: 8,
                        horizontal: 8,
                        children: [
                          for (int di = 0; di < 2; di += 1)
                            Expanded(
                              child: Column(
                                children: [
                                  CircleContainer(
                                    onTap: () =>
                                        selectBadge(data[2 * index + di].id),
                                    boxShadow:
                                        data[2 * index + di].id == badgeId
                                            ? [
                                                const BoxShadow(
                                                  blurRadius: 3,
                                                  spreadRadius: 3,
                                                  color: palePinkColor,
                                                )
                                              ]
                                            : null,
                                    child: Opacity(
                                      opacity: data[2 * index + di].hasBadge
                                          ? 1
                                          : 0.2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${dotenv.env['fileUrl']}/badges/${data[2 * index + di].id}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomText(
                                    content: data[2 * index + di].name,
                                    fontSize: FontSize.tinySize,
                                  )
                                ],
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
              );
            }
            return const CustomCirCularIndicator();
          },
        ),
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
      ],
    );
  }
}

//* 개인 정보 처리 방침
class PolicyModal extends StatelessWidget {
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://sites.google.com/view/bingot-privacy/홈'));
  PolicyModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      cancelText: '닫기',
      hasConfirm: false,
      children: [
        Expanded(
          child: WebViewWidget(controller: controller),
        )
      ],
    );
  }
}

//* 라이선스
class LicenseModal extends StatelessWidget {
  const LicenseModal({super.key});

  static StringList fontList = [];

  static Future<List<Package>> loadLicenses() async {
    // merging non-dart dependency list using LicenseRegistry.
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        final lp = lm.putIfAbsent(p, () => []);
        lp.addAll(l.paragraphs.map((p) => p.text));
      }
    }
    final licenseList = ossLicenses.toList();
    for (var key in lm.keys) {
      licenseList.add(Package(
        name: key,
        description: '',
        authors: [],
        version: '',
        license: lm[key]!.join('\n\n'),
        isMarkdown: false,
        isSdk: false,
        isDirectDependency: false,
      ));
    }
    return licenseList..sort((a, b) => a.name.compareTo(b.name));
  }

  static final licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      title: '라이선스',
      cancelText: '닫기',
      hasConfirm: false,
      children: [
        const CustomText(
          content: '글꼴',
          fontSize: FontSize.largeSize,
        ),
        const CustomText(
          content: '이미지',
          fontSize: FontSize.largeSize,
        ),
        const CustomText(
          content: '오픈 소스',
          fontSize: FontSize.largeSize,
        ),
        Expanded(
          child: FutureBuilder<List<Package>>(
              future: licenses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final package = snapshot.data![index];
                        return ListTile(
                          title: CustomText(
                            content: '${package.name} ${package.version}',
                          ),
                          subtitle: package.description.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CustomText(
                                    content: package.description,
                                    color: greyColor,
                                    fontSize: FontSize.smallSize,
                                    height: 1.1,
                                  ),
                                )
                              : null,
                          trailing: const Icon(rightIcon),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  LicenseDetailPage(package: package),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const CustomDivider());
                }
                return const CustomCirCularIndicator();
              }),
        ),
      ],
    );
  }
}

//* 모달 기본
class CustomModal extends StatelessWidget {
  final String? title;
  final bool hasConfirm;
  final WidgetList children;
  final ReturnVoid? onPressed, onCancelPressed;
  final String buttonText, cancelText;
  final Color backgroundColor, buttonColor, cancelColor;
  const CustomModal({
    super.key,
    this.title,
    this.hasConfirm = true,
    required this.children,
    this.onPressed,
    this.buttonText = '적용',
    this.cancelText = '취소',
    this.onCancelPressed,
    this.backgroundColor = whiteColor,
    this.buttonColor = paleRedColor,
    this.cancelColor = whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      child: SingleChildScrollView(
        child: CustomBoxContainer(
          color: backgroundColor,
          width: getWidth(context) * 0.85,
          child: ColWithPadding(
            vertical: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: CustomText(
                      content: title!,
                      fontSize: FontSize.largeSize,
                    ),
                  ),
                ),
              ...children,
              RowWithPadding(
                horizontal: 50,
                mainAxisAlignment: hasConfirm
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  onCancelPressed == null
                      ? ExitButton(isIconType: false, buttonText: cancelText)
                      : CustomButton(
                          onPressed: onCancelPressed!,
                          content: cancelText,
                          color: cancelColor,
                          textColor: cancelColor != whiteColor
                              ? whiteColor
                              : blackColor,
                        ),
                  if (hasConfirm)
                    CustomButton(
                      color: buttonColor,
                      textColor:
                          buttonColor != whiteColor ? whiteColor : blackColor,
                      onPressed: onPressed ?? () => toBack(context),
                      content: buttonText,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//* 알림 설정
// class NotificationModal extends StatefulWidget {
//   const NotificationModal({super.key});

//   @override
//   State<NotificationModal> createState() => _NotificationModalState();
// }

// class _NotificationModalState extends State<NotificationModal> {
//   StringList notificationList = [
//     '진행률/랭킹 알림',
//     '남은 기간 알림',
//     '채팅 알림',
//     '인증 완료 알림',
//   ];
//   List<StringList> notificationOptions = [
//     ['ON', 'OFF'],
//     ['세 달', '한 달', '일주일', '3일'],
//     ['ON', 'OFF'],
//     ['ON', 'OFF']
//   ];
//   IntList idxList = [0, 0, 0, 0];
//   void changeIdx(int i) {
//     if (i != 1) {
//       setState(() {
//         idxList[i] = 1 - idxList[i];
//       });
//     } else if (idxList[i] < 3) {
//       setState(() {
//         idxList[i] += 1;
//       });
//     } else {
//       setState(() {
//         idxList[i] = 0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomModal(
//       title: '알림 설정',
//       children: [
//         for (int i = 0; i < 4; i += 1)
//           RowWithPadding(
//             vertical: 10,
//             horizontal: 25,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(content: notificationList[i]),
//               CustomButton(
//                 content: notificationOptions[i][idxList[i]],
//                 onPressed: () => changeIdx(i),
//               )
//             ],
//           )
//       ],
//     );
//   }
// }

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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: CustomInput(
            explain: '$type을 입력해주세요',
            maxLength: 20,
            setValue: setValue,
          ),
        ),
      ],
    );
  }
}
