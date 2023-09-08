import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bin_got/main.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/widgets/bingo_detail.dart';
import 'package:bin_got/pages/input_password_page.dart';
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
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
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
  late final size;

  @override
  void initState() {
    super.initState();
    print('before data => ${widget.beforeData}');
    size = widget.bingoSize;
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
      for (var element in (data['items'] as List)) {
        final title = element['title'].trim();
        if (title != null && title != '') {
          cnt += 1;
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

          BingoProvider()
              .editOwnBingo(groupId!, bingoId, bingoData)
              .then((value) {
            if (value['statusCode'] == 401) {
              showLoginModal(context);
            } else {
              toOtherPage(
                context,
                page: const BingoDetail(),
              )();
            }
          }).catchError((_) {
            showErrorModal(context);
          });
        }
      }).catchError((_) {
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
      // var boundary = renderObject;
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
    GroupProvider().createOwnGroup(formData).then((groupId) {
      initBingoData(context);
      showAlert(
        context,
        title: '그룹 생성 완료',
        content: '그룹 생성이 완료되었습니다. 메인 페이지로 이동합니다.',
        hasCancel: false,
        onPressed: () => toOtherPageWithoutPath(context, page: const Main()),
      )();
      // toOtherPage(
      //   context,
      //   page: GroupCreateCompleted(
      //     groupId: groupId,
      //     password: widget.beforeData?['password'] ?? '',
      //   ),
      // )();
    }).catchError((error) {
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
      GroupProvider().joinGroup(groupId, formData).then((data) {
        print('그룹 가입 성공 => $data');
        print('form data : $bingoData');
        print('빙고 생성 성공');
        initBingoData(context);
        if (getNeedAuth(context) == true) {
          showAlert(
            context,
            title: '가입 신청',
            content: '가입 신청되었습니다.\n그룹장의 승인 후 가입됩니다.',
            hasCancel: false,
            onPressed: () => toOtherPageWithoutPath(
              context,
              page: const Main(),
            ),
          )();
        } else {
          showAlert(
            context,
            title: '가입 완료',
            content: '성공적으로 가입되었습니다.',
            hasCancel: false,
            onPressed: toOtherPage(
              context,
              page: InputPassword(
                isPublic: true,
                groupId: groupId,
              ),
            ),
          )();
        }
      }).catchError((e) {
        print('catch error : $e');
        showAlert(
          context,
          title: '가입 오류',
          content: '오류가 발생해 가입이 되지 않았습니다.',
          hasCancel: false,
        )();
      });
    } catch (error) {
      print('error : $error');
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
      appBar: const AppBarWithBack(),
      body: CustomBoxContainer(
        color: whiteColor,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      explain: '빙고명을 입력해주세요',
                      setValue: (value) => setOption(context, 'title', value),
                      initialValue: watchTitle(context),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        CustomText(content: '빙고판'),
                        SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    color: paleOrangeColor,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
