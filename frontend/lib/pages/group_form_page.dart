import 'dart:convert';
import 'dart:io';

import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//? 그룹 생성/수정
class GroupForm extends StatefulWidget {
  final int? groupId;
  final bool hasImg;
  const GroupForm({
    super.key,
    this.groupId,
    this.hasImg = false,
  });

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  //* 선택 목록
  final printedValues = [
    ['2 ✕ 2', '3 ✕ 3', '4 ✕ 4', '5 ✕ 5'],
    ['그룹장의\n승인 필요', '자동 가입']
  ];
  final convertedValues = [
    [2, 3, 4, 5],
    [true, false]
  ];
  final List<dynamic> selectedIndex = [0, 0];

  //* 변수
  XFile? selectedImage;
  bool isChecked = true;
  bool isImageUpdated = false;
  late bool hasImg;
  late final Map<String, dynamic> groupData;

  @override
  void initState() {
    super.initState();
    hasImg = widget.hasImg;
    //* 그룹 생성
    if (widget.groupId == null) {
      groupData = {
        'groupname': '',
        'start': '',
        'end': '',
        'size': 2,
        'is_public': true,
        'password': '',
        'description': '',
        'rule': '',
        'need_auth': true,
        'headcount': ''
      };
    } else {
      //* 그룹 수정
      groupData = {};
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedIndex[0] = getBingoSize(context)! - 1;
        selectedIndex[1] = getNeedAuth(context)! ? 0 : 1;
      });
    }
  }

  //* 데이터 변경
  void Function(dynamic) setData(String key) {
    return (value) => groupData[key] = value;
  }

  //* 그룹 생성/수정
  void createOrUpdate() async {
    try {
      //* 인원수 확인
      if (groupData.containsKey('headcount') &&
          groupData['headcount'].runtimeType != int) {
        groupData['headcount'] = int.parse(groupData['headcount']);
      }
      //* 그룹 생성
      if (widget.groupId == null) {
        //* 빙고 크기
        if (groupData['size'].runtimeType != int) {
          groupData['size'] = int.parse(groupData['size']);
        }
        //* 그룹명 길이
        if (groupData['groupname'].length < 3) {
          showAlert(context,
              title: '그룹명 오류', content: '그룹명을 3자 이상으로 입력해주세요.')();
          //* 인원수 범위
        } else if (groupData['headcount'] < 1 || groupData['headcount'] > 30) {
          showAlert(context,
              title: '인원 수 오류', content: '인원 수는 1명 이상 30명 이하로 입력해주세요.')();
          //* 기간
        } else if (groupData['start'] == '' || groupData['end'] == '') {
          showAlert(context, title: '기간 미선택', content: '달성 목표 기간을 설정해주세요.')();
          //* 비밀번호
        } else if (!groupData['is_public'] &&
            groupData['password'].length < 4) {
          showAlert(context,
              title: '비밀번호 오류', content: '그룹 비밀번호를 4자 이상으로 입력해주세요.')();
        } else {
          //* 빙고 id 초기화
          final bingoId = getBingoId(context);
          if (bingoId != null && bingoId != 0) {
            setBingoId(context, 0);
          }
          //* 빙고 생성 페이지로 이동
          toOtherPageWithAnimation(
            context,
            page: BingoForm(
              beforeData: groupData,
              bingoSize: groupData['size'],
              needAuth: groupData['need_auth'],
              groupImg: selectedImage,
            ),
          )();
        }
      } else {
        //* 그룹 수정
        //* 그룹명
        if (groupData.containsKey('groupname') &&
            groupData['groupname'].length < 3) {
          showAlert(
            context,
            title: '그룹명 오류',
            content: '그룹명을 3자 이상으로 입력해주세요.',
          )();
          //* 인원 수
        } else if (groupData.containsKey('headcount') &&
            (groupData['headcount'] < 1 || groupData['headcount'] > 30)) {
          showAlert(
            context,
            title: '인원 수 오류',
            content: '인원 수는 1명 이상 30명 이하로 입력해주세요.',
          )();
          //* 비밀번호
        } else if (groupData.containsKey('is_public') &&
            !groupData['is_public'] &&
            groupData['password'].length < 4) {
          showAlert(
            context,
            title: '비밀번호 오류',
            content: '그룹 비밀번호를 4자 이상으로 입력해주세요.',
          )();
          //* 그룹 수정 요청
        } else {
          GroupProvider()
              .editOwnGroup(
                  widget.groupId!,
                  FormData.fromMap({
                    'data': jsonEncode(groupData),
                    'img': isImageUpdated && selectedImage != null
                        ? MultipartFile.fromFileSync(
                            selectedImage!.path,
                            contentType: MediaType('image', 'png'),
                          )
                        : null,
                    'update_img': isImageUpdated,
                  }))
              .then((_) {
            //* 그룹 데이터 변경
            GroupProvider().readGroupDetail(getGroupId(context)!).then((data) {
              setGroupData(context, data);
              setLoading(context, false);
              toBack(context);
            }).catchError((error) {
              setLoading(context, false);
              showAlert(
                context,
                title: '오류 발생',
                content: '오류가 발생해 그룹 정보를 받아올 수 없습니다.',
                hasCancel: false,
                onPressed: () {
                  toBack(context);
                  toBack(context);
                },
              )();
            });
          }).catchError((error) {
            toBack(context);
            setLoading(context, false);
            showAlert(
              context,
              title: '오류 발생',
              content: '그룹 수정 시 오류가 발생했습니다.',
              hasCancel: false,
              onPressed: () {
                toBack(context);
                toBack(context);
              },
            )();
          });
        }
      }
    } catch (_) {
      showAlert(
        context,
        title: '오류 발생',
        content: '그룹 생성/수정 시 오류가 발생했습니다.',
        hasCancel: false,
        onPressed: () {
          toBack(context);
          toBack(context);
        },
      )();
    }
  }

  //* 이미지 선택
  void groupFormImagePicker() {
    return imagePicker(
      context,
      thenFunc: (localImage) {
        if (localImage != null) {
          setState(() {
            selectedImage = localImage;
            isImageUpdated = true;
          });
        }
      },
    );
  }

  //* 이미지 삭제
  void deleteImage() {
    setState(() {
      selectedImage = null;
      if (widget.groupId != null) {
        if (hasImg) {
          hasImg = false;
        }
        isImageUpdated = true;
      }
    });
  }

  //* 기간 선택 창 내부
  String selectedDate() {
    final start = groupData['start'];
    final end = groupData['end'];
    if (start != '' && end != '') {
      return '$start ~ $end';
    }
    return '기간을 선택해주세요';
  }

  //* 빙고 크기, 가입 승인 데이터 변경
  void changeGroupData(int i, int j) {
    setState(() {
      selectedIndex[i] = j;
    });
    setData(i == 0 ? 'size' : 'need_auth')(convertedValues[i][j]);
  }

  //* 기간 데이터 형식 변경
  void applyDay(List<DateTime?> dateList) {
    dateList =
        dateList.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();

    if (dateList.isNotEmpty) {
      setState(() {
        groupData['start'] =
            dateList[0].toString().replaceAll('00:00:00.000', '').trim();
        groupData['end'] = dateList.length > 1
            ? dateList[1].toString().replaceAll('00:00:00.000', '').trim()
            : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      //* 앱 바
      appBar: AppBarWithBack(
        title: widget.groupId == null ? '그룹 생성' : '그룹 수정',
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ColWithPadding(
          horizontal: 50,
          vertical: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* 그룹명 입력창
            groupFormInput(
              title: '그룹명',
              explainTitleType: 0,
              explain: '그룹명을 입력하세요.',
              maxLength: 20,
              setValue: setData('groupname'),
              initialValue: groupData.containsKey('groupname')
                  ? groupData['groupname']
                  : getGroupName(context),
            ),
            //* 참여인원 입력창
            groupFormInput(
              title: '참여인원',
              explain: '2에서 30 사이의 숫자로 입력하세요.',
              explainTitleType: 0,
              onlyNum: true,
              setValue: setData('headcount'),
              initialValue: groupData.containsKey('headcount')
                  ? groupData['headcount'].toString()
                  : context.read<GlobalGroupProvider>().headCount?.toString(),
            ),
            //* 그룹 생성 시에만 설정 가능한 항목
            if (widget.groupId == null)
              Column(
                children: [
                  //* 기간 선택
                  groupFormInput(
                    title: '기간',
                    explainTitleType: 1,
                    inputWidget: InputDate(
                      explain: selectedDate(),
                      start: groupData.containsKey('start')
                          ? groupData['start']
                          : getStart(context) ?? '',
                      end: groupData.containsKey('end')
                          ? groupData['end']
                          : context.read<GlobalGroupProvider>().end ?? '',
                      applyDay: applyDay,
                    ),
                  ),
                  //* 빙고 크기 선택
                  groupFormInput(
                    title: '빙고 크기',
                    divider: true,
                    explainTitleType: 1,
                    content:
                        '총 ${(selectedIndex[0] + 2) * (selectedIndex[0] + 2)} 칸의 빙고판이 만들어집니다.',
                    inputWidget: RowWithPadding(
                      vertical: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < 4; i += 1)
                          CustomBoxContainer(
                            borderColor:
                                selectedIndex[0] == i ? whiteColor : greyColor,
                            onTap: () => changeGroupData(0, i),
                            color: selectedIndex[0] == i
                                ? palePinkColor
                                : whiteColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CustomText(
                                content: printedValues[0][i],
                                color: selectedIndex[0] == i
                                    ? whiteColor
                                    : blackColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //* 자동 승인 여부 선택
                  groupFormInput(
                    title: '가입 시 자동 승인',
                    explainTitleType: 1,
                    divider: true,
                    inputWidget: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int j = 0; j < 2; j += 1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CustomBoxContainer(
                                  borderColor:
                                      selectedIndex[1] == j ? null : greyColor,
                                  onTap: () => changeGroupData(1, j),
                                  width: 120,
                                  height: 60,
                                  color: selectedIndex[1] == j
                                      ? palePinkColor
                                      : whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Center(
                                      child: CustomText(
                                        content: printedValues[1][j],
                                        color: selectedIndex[1] == j
                                            ? whiteColor
                                            : blackColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    content: selectedIndex[1] == 0
                        ? '가입 신청 후, 그룹장의 허가가 있어야 가입됩니다.'
                        : '가입 신청 시, 자동으로 가입됩니다.',
                  ),
                  //* 공개 여부 선택
                  groupFormInput(
                    divider: true,
                    inputWidget: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            const Row(
                              children: [
                                CustomText(content: '그룹 공개'),
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
                                const CustomText(
                                  content: '수정 불가',
                                  fontSize: FontSize.tinySize,
                                  color: greyColor,
                                ),
                                CustomSwitch(
                                  value: isChecked,
                                  onChanged: (_) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                    setData('is_public')(isChecked);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        //* 비밀번호 입력창
                        if (!isChecked)
                          groupFormInput(
                            title: '비밀번호',
                            explain: '비밀번호',
                            maxLength: 20,
                            setValue: setData('password'),
                            initialValue: groupData.containsKey('password')
                                ? groupData['password']
                                : context.read<GlobalGroupProvider>().password,
                          ),
                      ],
                    ),
                    content:
                        isChecked ? '추천 그룹, 검색 화면에 노출됩니다' : '초대로만 가입이 가능합니다',
                  ),
                ],
              ),
            //* 그룹 설명 입력창
            groupFormInput(
              title: '그룹 설명',
              explain: '그룹을 설명하는 내용을 입력하세요.',
              explainTitleType: 2,
              needMore: true,
              maxLength: 1000,
              setValue: setData('description'),
              initialValue: groupData.containsKey('description')
                  ? groupData['description']
                  : context.read<GlobalGroupProvider>().description,
            ),
            //* 그룹 규칙 입력창
            groupFormInput(
              title: '그룹 규칙',
              explain: '그룹의 규칙을 입력하세요.',
              explainTitleType: 2,
              needMore: true,
              maxLength: 1000,
              setValue: setData('rule'),
              initialValue: groupData.containsKey('rule')
                  ? groupData['rule']
                  : context.read<GlobalGroupProvider>().rule,
            ),
            //* 그룹 배경 입력창
            groupFormInput(
              title: '그룹 배경',
              explainTitleType: 2,
              inputWidget: groupImage(),
            )
          ],
        ),
      ),
      bottomNavigationBar: FormBottomBar(createOrUpdate: createOrUpdate),
    );
  }

  //* 그룹 입력창 형식
  Column groupFormInput({
    String? title,
    Function(String)? setValue,
    int? explainTitleType,
    String? initialValue,
    Widget? inputWidget,
    String? content,
    int? maxLength,
    String explain = '',
    bool needMore = false,
    bool onlyNum = false,
    bool divider = false,
  }) {
    List<StringList> explainTitles = [
      ['(필수)', '시작일 전 수정 가능'],
      ['(필수)', '수정 불가'],
      ['(선택)', '시작일 전 수정 가능']
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              if (title != null) CustomText(content: title),
              const SizedBox(width: 5),
              if (explainTitleType != null)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 2; i += 1)
                        CustomText(
                          content: explainTitles[explainTitleType][i],
                          fontSize: FontSize.tinySize,
                          color: greyColor,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        inputWidget ??
            CustomInput(
              explain: explain,
              setValue: setValue!,
              initialValue: initialValue,
              needMore: needMore,
              onlyNum: onlyNum,
              maxLength: maxLength,
            ),
        if (content != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              content: content,
              fontSize: FontSize.smallSize,
              color: greyColor,
              height: 1.2,
            ),
          ),
        divider ? const CustomDivider() : const SizedBox(height: 25),
      ],
    );
  }

  //* 그룹 이미지 선택 창 형식
  Widget groupImage() {
    if (selectedImage == null && !hasImg) {
      return CustomBoxContainer(
        width: 300,
        height: 150,
        onTap: groupFormImagePicker,
        borderColor: Colors.grey,
        borderRadius: BorderRadius.circular(4),
        child: CustomIconButton(
          icon: addIcon,
          onPressed: groupFormImagePicker,
          color: greyColor,
        ),
      );
    } else {
      return Column(
        children: [
          CustomBoxContainer(
            borderColor: Colors.grey,
            hasRoundEdge: false,
            width: 270,
            height: 150,
            onTap: groupFormImagePicker,
            image: !hasImg || selectedImage != null
                ? DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: FileImage(File(selectedImage!.path)),
                  )
                : null,
            child: hasImg && selectedImage == null
                ? CustomCachedNetworkImage(
                    path: '/groups/${widget.groupId}',
                    width: 270,
                    height: 150,
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    onPressed: groupFormImagePicker, content: '다시 고르기'),
                CustomButton(
                  onPressed: deleteImage,
                  content: '삭제',
                  color: palePinkColor,
                  textColor: whiteColor,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
