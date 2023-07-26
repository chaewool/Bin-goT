import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/group_create_completed.dart';
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
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class BingoForm extends StatefulWidget {
  final int bingoSize;
  final int? bingoId;
  final bool needAuth, beforeJoin;
  final DynamicMap? beforeData;
  final XFile? groupImg;
  const BingoForm({
    super.key,
    this.bingoId,
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
      bingoToThumb().then((_) {
        final data = context.read<GlobalBingoProvider>().data;
        if (data['title'] == null) {
          return showAlert(
            context,
            title: '필수 항목 누락',
            content: '빙고명을 입력해주세요',
          )();
        }
        int cnt = 0;
        for (var element in (data['items'] as List)) {
          final title = element['title'].trim();
          final content = element['content'].trim();
          if (title != null &&
              title != '' &&
              content != null &&
              content != '') {
            cnt += 1;
          }
        }

        if (cnt != size * size) {
          return showAlert(
            context,
            title: '필수 항목 누락',
            content: '빙고칸 내부를 채워주세요',
          )();
        }
        print('bingo data => $data');

        if (widget.bingoId == null) {
          widget.beforeJoin ? joinGroup(data) : createGroup(data);
        } else {
          final bingoData = FormData.fromMap({
            'data': jsonEncode(data),
            'thumbnail': MultipartFile.fromBytes(
              thumbnail!,
              filename: 'thumbnail.png',
              contentType: MediaType('image', 'png'),
            ),
            'img': widget.groupImg != null
                ? MultipartFile.fromFileSync(widget.groupImg!.path,
                    contentType: MediaType('image', 'png'))
                : null,
          });
          print(widget.bingoId);
          BingoProvider()
              .editOwnBingo(widget.bingoId!, bingoData)
              .then((value) {
            if (value['statusCode'] == 401) {
              showLoginModal(context);
            } else {
              toOtherPage(
                context,
                page: BingoDetail(bingoId: widget.bingoId!),
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
      var boundary = renderObject;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      setState(() {
        thumbnail = byteData?.buffer.asUint8List();
      });
    }
    return true;
  }

  void createGroup(DynamicMap bingoData) {
    final formData = FormData.fromMap({
      'data': jsonEncode(widget.beforeData),
      'board_data': jsonEncode(bingoData),
      'thumbnail': MultipartFile.fromBytes(
        thumbnail!,
        filename: 'thumbnail.png',
        contentType: MediaType('image', 'png'),
      ),
      'img': widget.groupImg != null
          ? MultipartFile.fromFileSync(widget.groupImg!.path,
              contentType: MediaType('image', 'png'))
          : null,
    });
    GroupProvider().createOwnGroup(formData).then((groupId) {
      toOtherPage(
        context,
        page: GroupCreateCompleted(
          groupId: groupId,
          password: widget.beforeData?['password'] ?? '',
        ),
      )();
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
        if (widget.needAuth == true) {
          toBack(context);
          showAlert(
            context,
            title: '가입 신청',
            content: '가입 신청되었습니다.\n그룹장의 승인 후 가입됩니다.',
            hasCancel: false,
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
      body: ColWithPadding(
        horizontal: 10,
        vertical: 5,
        children: [
          Flexible(
            flex: 2,
            child: CustomInput(
              explain: '빙고 이름',
              setValue: (value) => setOption(context, 'title', value),
              initialValue: getTitle(context),
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: RepaintBoundary(
                key: globalKey,
                child: BingoBoard(
                  isDetail: false,
                  bingoSize: size,
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 4,
            child: BingoTabBar(),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: CustomButton(
                onPressed: createOrEditBingo,
                content: widget.beforeJoin ? '가입 신청' : '완료',
                fontSize: FontSize.textSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
