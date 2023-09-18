import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bin_got/main.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class BingoForm extends StatefulWidget {
  final int bingoSize;
  final bool needAuth, beforeJoin;
  // final bool beforeJoin;
  final DynamicMap? beforeData;
  final XFile? groupImg;
  const BingoForm({
    super.key,
    required this.bingoSize,
    required this.needAuth,
    this.beforeJoin = false,
    this.beforeData,
    this.groupImg,
  });

  @override
  State<BingoForm> createState() => _BingoFormState();
}

class _BingoFormState extends State<BingoForm> {
  GlobalKey globalKey = GlobalKey();
  Uint8List? thumbnail;
  bool changed = true;
  String toastString = '';
  late final size;

  @override
  void initState() {
    super.initState();
    print('before data => ${widget.beforeData}');
    size = widget.bingoSize;
    if (getBingoId(context) == null || getBingoId(context) == 0) {
      initBingoData(context);
    }
    // ?? getBingoSize(context);
    // if (getGroupId(context) != null) {
    //   setOption(context, 'group_id', getGroupId(context));
    // }
    if (getItems(context).isEmpty) {
      context.read<GlobalBingoProvider>().initItems(size * size);
    }
  }

  void createOrEditBingo() async {
    if (changed) {
      final data = context.read<GlobalBingoProvider>().data;
      if (data['title'] == null) {
        return showAlert(
          context,
          title: '필수 항목 누락',
          content: '빙고명을 입력해주세요',
          hasCancel: false,
        )();
      }
      int cnt = 0;
      bool correctGoal = true;
      for (var element in (data['items'] as List)) {
        final title = element['title'].trim();
        // print('check => ${element['check']}');
        if (title != null && title != '') {
          cnt += 1;
        }
        if (element['check']) {
          try {
            var checkGoal = element['check_goal'];
            if (checkGoal is String) {
              element['check_goal'] = int.parse(checkGoal);
            }
            if (element['check_goal'] < 2) {
              correctGoal = false;
            }
          } catch (error) {
            print(error);
            correctGoal = false;
          }
        }
      }

      if (cnt != size * size) {
        return showAlert(
          context,
          title: '필수 항목 누락',
          content: '빙고칸 내부를 채워주세요',
          hasCancel: false,
        )();
      }
      if (!correctGoal) {
        return showAlert(
          context,
          title: '유효하지 않은 값',
          content: '목표 달성 횟수를 2 이상의 숫자로 입력해주세요.',
          hasCancel: false,
        )();
      }
      print('bingo data => $data');

      bingoToThumb().then((_) {
        final bingoId = getBingoId(context);
        print(bingoId);
        if (bingoId == null || bingoId == 0) {
          widget.beforeJoin ? joinGroup(data) : createGroup(data);
        } else {
          //* 빙고 수정
          final bingoData = FormData.fromMap({
            'data': jsonEncode(data),
            'thumbnail': MultipartFile.fromBytes(
              thumbnail!,
              filename: 'thumbnail.png',
              contentType: MediaType('image', 'png'),
            ),
          });
          showSpinner(context, true);
          print(bingoData);

          BingoProvider()
              .editOwnBingo(groupId!, bingoId, bingoData)
              .then((value) {
            print(4444);
            showSpinner(context, false);
            print(5555);
            toBack(context);

            // toOtherPage(
            //   context,
            //   page: const BingoDetail(),
            // )();
          }).catchError((_) {
            print(1);
            showSpinner(context, false);
            showErrorModal(context);
          });
        }
      }).catchError((_) {
        print(2);
        showSpinner(context, false);
        showErrorModal(context);
      });
    } else {
      return showAlert(
        context,
        title: '필수 항목 누락',
        content: '변경사항이 없습니다.',
      )();
    }
  }

  FutureBool bingoToThumb() async {
    var renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      final image = await renderObject.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      setState(() {
        thumbnail = byteData?.buffer.asUint8List();
      });
    }
    return true;
  }

  void createGroup(DynamicMap bingoData) {
    print('data => ${widget.beforeData}, ㅠㅐㅁ');
    final formData = FormData.fromMap({
      'data': jsonEncode(widget.beforeData),
      'board_data': jsonEncode(bingoData),
      'thumbnail': MultipartFile.fromBytes(
        thumbnail!,
        filename: 'thumbnail.png',
        contentType: MediaType('image', 'png'),
      ),
      'img': widget.groupImg != null
          ? MultipartFile.fromFileSync(
              widget.groupImg!.path,
              contentType: MediaType('image', 'png'),
            )
          : null,
    });
    showSpinner(context, true);
    GroupProvider().createOwnGroup(formData).then((groupId) {
      showSpinner(context, false);
      // initBingoData(context);
      toastString = '그룹 생성이 완료되었습니다.';
      changeGroupIndex(context, 1);
      showToast(context);
      changePrev(context, true);
      afterFewSec(
        1000,
        jumpToOtherPage(
          context,
          page: InputPassword(
            isPublic: true,
            groupId: groupId,
          ),
        ),
      );
      // toOtherPage(
      //   context,
      //   page: GroupCreateCompleted(
      //     groupId: groupId,
      //     password: widget.beforeData?['password'] ?? '',
      //   ),
      // )();
    }).catchError((error) {
      showSpinner(context, false);
      showAlert(
        context,
        title: '그룹 생성 오류',
        content: '오류가 발생해 그룹이 생성되지 않았습니다.',
        hasCancel: false,
      )();
    });
  }

  void joinGroup(DynamicMap bingoData) async {
    try {
      final groupId = getGroupId(context)!;
      print('data => $bingoData');
      final formData = FormData.fromMap({
        'board_data': jsonEncode(bingoData),
        'thumbnail': MultipartFile.fromBytes(
          thumbnail!,
          filename: 'thumbnail.png',
          contentType: MediaType('image', 'png'),
        ),
      });
      showSpinner(context, true);
      GroupProvider().joinGroup(groupId, formData).then((data) {
        showSpinner(context, false);
        print('그룹 가입 성공 => $data');
        print('form data : $bingoData');
        print('빙고 생성 성공');
        // initBingoData(context);
        if (getNeedAuth(context) == true) {
          toastString = '가입 신청되었습니다.\n그룹장의 승인 후 가입됩니다.';
          showToast(context);
          afterFewSec(
            1000,
            () => toOtherPageWithoutPath(
              context,
              page: const Main(),
            ),
          );
        } else {
          toastString = '성공적으로 가입되었습니다.';
          changeGroupIndex(context, 1);
          showToast(context);
          afterFewSec(
            1000,
            jumpToOtherPage(
              context,
              page: InputPassword(isPublic: true, groupId: groupId),
            ),
          );

          // showAlert(
          //   context,
          //   title: '가입 완료',
          //   content: '성공적으로 가입되었습니다.',
          //   hasCancel: false,
          //   onPressed: jumpToOtherPage(
          //     context,
          //     page: InputPassword(isPublic: true, groupId: groupId),
          //   ),
          // )();
        }
      }).catchError((e) {
        print('catch error : $e');
        showSpinner(context, false);
        showAlert(
          context,
          title: '가입 오류',
          content: '오류가 발생해 가입이 되지 않았습니다.',
          hasCancel: false,
        )();
      });
    } catch (error) {
      print('error : $error');
      showSpinner(context, false);
      showAlert(
        context,
        title: '가입 오류',
        content: '오류가 발생해 가입이 되지 않았습니다.',
        hasCancel: false,
      )();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomBoxContainer(
            width: getWidth(context),
            height: getHeight(context),
            color: whiteColor,
            image: watchBackground(context) != null
                ? DecorationImage(
                    image:
                        AssetImage(backgroundList[watchBackground(context)!]),
                    fit: BoxFit.fill,
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.only(top: 75),
              child: ColWithPadding(
                horizontal: 10,
                vertical: 5,
                children: [
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              CustomText(content: '빙고명'),
                              SizedBox(width: 5),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      content: '(필수)',
                                      fontSize: FontSize.tinySize,
                                      color: greyColor,
                                    ),
                                    CustomText(
                                      content: '시작일 전 수정 가능',
                                      fontSize: FontSize.tinySize,
                                      color: greyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomInput(
                            filled: true,
                            explain: '빙고명을 입력해주세요',
                            setValue: (value) =>
                                setOption(context, 'title', value),
                            initialValue: watchTitle(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              CustomText(content: '빙고판'),
                              SizedBox(width: 5),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      content: '(필수)',
                                      fontSize: FontSize.tinySize,
                                      color: greyColor,
                                    ),
                                    CustomText(
                                      content: '시작일 전 수정 가능',
                                      fontSize: FontSize.tinySize,
                                      color: greyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: RepaintBoundary(
                              key: globalKey,
                              child: BingoBoard(
                                isDetail: false,
                                bingoSize: size,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Flexible(flex: 9, child: BingoTabBar()),
                  Flexible(
                    flex: 2,
                    child: Row(children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: createOrEditBingo,
                          content: widget.beforeJoin ? '가입 신청' : '완료',
                          fontSize: FontSize.textSize,
                          textColor: whiteColor,
                          color: paleRedColor,
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          const CustomBoxContainer(
            color: Colors.transparent,
            height: 70,
            child: AppBarWithBack(transparent: true),
          ),
          if (watchSpinner(context))
            CustomBoxContainer(
              color: blackColor.withOpacity(0.4),
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CustomCirCularIndicator()],
              ),
            ),
          if (watchAfterWork(context)) CustomToast(content: toastString)
        ],
      ),
    );
  }
}
