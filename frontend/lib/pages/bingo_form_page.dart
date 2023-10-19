import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
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

//? 빙고 생성/수정
class BingoForm extends StatefulWidget {
  final int bingoSize;
  final bool needAuth, beforeJoin;
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
  late final int size;

  @override
  void initState() {
    super.initState();
    size = widget.bingoSize;
    //* 생성, 수정 분기 처리
    if (getBingoId(context) != null && getBingoId(context) != 0) {
      initBingoFormData(context, true);
    } else if (widget.beforeJoin) {
      initBingoFormData(context, false);
    }
    //* items
    if (getItems(context, false).isEmpty) {
      context.read<GlobalBingoProvider>().initItems(size * size);
    }
  }

  //* 완료 후 작업
  void afterWork(String message, int nextIndex, ReturnVoid? afterFunc) {
    showSpinner(context, false);
    setToastString(context, message);
    changeGroupIndex(context, nextIndex);
    showToast(context);
    setIsCheckTheme(context, false);
    applyBingoData(context);
    if (afterFunc != null) {
      afterFunc();
    }
  }

  //* 빙고 생성/수정
  void createOrEditBingo() {
    try {
      //* 변경된 부분이 있는 경우
      if (changed) {
        print('변경됨!!!!!');
        final data = getBingoData(context, false);
        //* 제목
        if (data['title'] == null) {
          return showAlert(
            context,
            title: '필수 항목 누락',
            content: '빙고판 제목을 입력해주세요',
            hasCancel: false,
          )();
        }
        //* 빙고 칸 내부 & 목표 달성 횟수 확인
        int cnt = 0;
        bool correctGoal = true;
        for (var element in (data['items'] as List)) {
          final title = element['title'].trim();
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
              correctGoal = false;
            }
          }
        }
        //* 빙고칸 내부
        if (cnt != size * size) {
          return showAlert(
            context,
            title: '필수 항목 누락',
            content: '빙고칸 내부를 채워주세요',
            hasCancel: false,
          )();
        }
        //* 목표 달성 횟수
        if (!correctGoal) {
          return showAlert(
            context,
            title: '유효하지 않은 값',
            content: '목표 달성 횟수를 2 이상의 숫자로 입력해주세요.',
            hasCancel: false,
          )();
        }

        //* 썸네일 생성 후 작업 요청
        // setIsCheckTheme(context, false).then((_) {
        bingoToThumb().then((_) {
          final bingoId = getBingoId(context);
          //* 빙고 생성
          if (bingoId == null || bingoId == 0) {
            widget.beforeJoin ? joinGroup(data) : createGroup(data);
          } else {
            //* 빙고 수정
            print(data);
            final bingoData = FormData.fromMap({
              'data': jsonEncode(data),
              'thumbnail': MultipartFile.fromBytes(
                thumbnail!,
                filename: 'thumbnail.png',
                contentType: MediaType('image', 'png'),
              ),
            });
            showSpinner(context, true);

            BingoProvider()
                .editOwnBingo(getGroupId(context)!, bingoId, bingoData)
                .then((value) {
              afterWork('빙고 수정이 완료되었습니다.', 0, () {
                setBingoData(context, data);
                toBack(context);
              });
            }).catchError((_) {
              showSpinner(context, false);
              showErrorModal(context, '빙고 수정 오류', '빙고 수정에 실패했습니다.');
            });
          }
        }).catchError((_) {
          showSpinner(context, false);
          showErrorModal(context, '빙고 생성/수정 오류', '빙고 생성/수정에 실패했습니다.');
        });
        // }).catchError((_) {
        //   showSpinner(context, false);
        //   showErrorModal(context, '빙고 생성/수정 오류', '빙고 생성/수정에 실패했습니다.');
        // });
        //* 변경되지 않은 경우
      } else {
        return showAlert(
          context,
          title: '필수 항목 누락',
          content: '변경사항이 없습니다.',
        )();
      }
    } catch (_) {
      showErrorModal(context, '빙고 생성/수정 오류', '빙고 생성/수정에 실패했습니다.');
    }
  }

  //* 빙고 썸네일 생성
  FutureBool bingoToThumb() async {
    final renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      final image = await renderObject.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      setState(() {
        thumbnail = byteData?.buffer.asUint8List();
      });
    }
    return true;
  }

  //* 그룹 생성
  void createGroup(DynamicMap bingoData) {
    try {
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
        afterWork('그룹 생성이 완료되었습니다.', 1, () {
          changePrev(context, true);
          afterFewSec(
            jumpToOtherPage(
              context,
              page: InputPassword(
                isPublic: true,
                groupId: groupId,
              ),
            ),
          );
        });
      }).catchError((error) {
        showSpinner(context, false);
        showErrorModal(
          context,
          '그룹 생성 오류',
          '오류가 발생해 그룹이 생성되지 않았습니다.',
        );
      });
    } catch (_) {
      showErrorModal(
        context,
        '그룹 생성 오류',
        '오류가 발생해 그룹이 생성되지 않았습니다.',
      );
    }
  }

  //* 그룹 가입
  void joinGroup(DynamicMap bingoData) async {
    try {
      final groupId = getGroupId(context)!;
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
        //* 가입 승인 필요 시
        if (getNeedAuth(context) == true) {
          afterWork('가입 신청되었습니다.\n그룹장의 승인 후 가입됩니다.', 1, () {
            afterFewSec(
              () => toOtherPageWithoutPath(
                context,
                page: const Main(),
              ),
            );
          });
        } else {
          afterWork('성공적으로 가입되었습니다.', 1, () {
            afterFewSec(
              jumpToOtherPage(
                context,
                page: InputPassword(isPublic: true, groupId: groupId),
              ),
            );
          });
        }
      }).catchError((_) {
        showSpinner(context, false);
        showErrorModal(context, '가입 오류', '오류가 발생해 가입이 되지 않았습니다.');
      });
    } catch (_) {
      showSpinner(context, false);
      showErrorModal(context, '가입 오류', '오류가 발생해 가입이 되지 않았습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.beforeJoin
          ? () => onBackAction(context)
          : () {
              toBack(context);
              return Future.value(true);
            },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            CustomBoxContainer(
              onTap: unfocus,
              hasRoundEdge: false,
              width: getWidth(context),
              height: getHeight(context),
              color: whiteColor,
              image: watchBackground(context, false) != null
                  ? DecorationImage(
                      image: AssetImage(
                          backgroundList[watchBackground(context, false)!]),
                      fit: BoxFit.fitHeight,
                    )
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(top: 75),
                child: ColWithPadding(
                  horizontal: 10,
                  vertical: 5,
                  children: [
                    //* 빙고판 제목
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                CustomText(content: '빙고판 제목'),
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
                              explain: '빙고판 제목을 입력해주세요',
                              setValue: (value) =>
                                  setOption(context, 'title', value),
                              initialValue: watchTitle(context),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //* 빙고판 라벨 & 빙고판
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
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  CustomText(
                                    content: '- 빙고 칸을 눌러 내용을 작성/수정할 수 있습니다.',
                                    fontSize: FontSize.tinySize,
                                    color: greyColor,
                                  ),
                                ],
                              ),
                            ),
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
                    //* 빙고 설정 변경 탭 바
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
            //* 앱바
            CustomBoxContainer(
              color: transparentColor,
              height: 70,
              child: AppBarWithBack(
                transparent: true,
                onPressedBack: () =>
                    widget.beforeJoin ? onBackAction(context) : toBack(context),
              ),
            ),

            //* 스피너
            if (watchSpinner(context))
              CustomBoxContainer(
                color: blackColor.withOpacity(0.4),
                child: const Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CustomCirCularIndicator()],
                ),
              ),
            //* 토스트
            if (watchAfterWork(context))
              CustomToast(content: watchToastString(context))
          ],
        ),
      ),
    );
  }
}
