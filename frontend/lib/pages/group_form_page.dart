import 'dart:convert';
import 'dart:io';

import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

//* 그룹 생성/수정 페이지
class GroupForm extends StatefulWidget {
  final int? groupId;
  final String? password;
  final bool hasImg;
  const GroupForm({
    super.key,
    this.groupId,
    this.password,
    this.hasImg = false,
  });

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  //* select box
  final printedValues = [
    ['2 x 2', '3 x 3', '4 x 4', '5 x 5'],
    ['그룹장의\n승인 필요', '자동 가입']
  ];
  final convertedValues = [
    [2, 3, 4, 5],
    [true, false]
  ];
  final List<dynamic> selectedIndex = [0, 0];

  XFile? selectedImage;
  bool isChecked = true;
  // BoolList showList = [false, false];
  bool isImageUpdated = false;
  late bool hasImg;

  @override
  void initState() {
    super.initState();
    hasImg = widget.hasImg;
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
      groupData = {};
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedIndex[0] = getBingoSize(context)! - 1;
        selectedIndex[1] =
            context.read<GlobalGroupProvider>().needAuth! ? 0 : 1;
        isChecked = getPublic(context)!;
      });
    }
  }

  late final Map<String, dynamic> groupData;

  void Function(dynamic) setGroupData(String key) {
    return (value) => groupData[key] = value;
  }

  // void changeShowState(int index) {
  //   setState(() {
  //     if (!showList[index]) {
  //       showList[index] = true;
  //     } else {
  //       showList[index] = false;
  //     }
  //   });
  // }

  void createOrUpdate() async {
    if (groupData['headcount'].runtimeType != int) {
      groupData['headcount'] = int.parse(groupData['headcount']);
    }
    if (groupData['size'].runtimeType != int) {
      groupData['size'] = int.parse(groupData['size']);
    }

    if (widget.groupId == null) {
      if (groupData['groupname'].length < 3) {
        showAlert(context, title: '그룹명 오류', content: '그룹명을 3자 이상으로 입력해주세요.')();
      } else if (groupData['headcount'] < 1 || groupData['headcount'] > 30) {
        showAlert(context,
            title: '인원 수 오류', content: '인원 수는 1명 이상 30명 이하로 입력해주세요.')();
      } else if (groupData['start'] == '' || groupData['end'] == '') {
        showAlert(context, title: '기간 미선택', content: '달성 목표 기간을 설정해주세요.')();
      } else if (!groupData['is_public'] && groupData['password'].length < 4) {
        showAlert(context,
            title: '비밀번호 오류', content: '그룹 비밀번호를 4자 이상으로 입력해주세요.')();
      } else {
        print(groupData['size']);
        toOtherPage(
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
      if (groupData.containsKey('groupname') &&
          groupData['groupname'].length < 3) {
        showAlert(
          context,
          title: '그룹명 오류',
          content: '그룹명을 3자 이상으로 입력해주세요.',
        )();
      } else if (groupData.containsKey('headcount') &&
          (groupData['headcount'] < 1 || groupData['headcount'] > 30)) {
        showAlert(
          context,
          title: '인원 수 오류',
          content: '인원 수는 1명 이상 30명 이하로 입력해주세요.',
        )();
      } else if (groupData.containsKey('is_public') &&
          !groupData['is_public'] &&
          groupData['password'].length < 4) {
        showAlert(
          context,
          title: '비밀번호 오류',
          content: '그룹 비밀번호를 4자 이상으로 입력해주세요.',
        )();
      } else {
        print(groupData);
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
            .then((groupId) {
          toBack(context);
        }).catchError((error) {});
      }
    }
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
          if (localImage != null) {
            setState(() {
              selectedImage = localImage;
              isImageUpdated = true;
            });
          }
        }).catchError((error) {
          showErrorModal(context);
        });
      }
    });
  }

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

  String selectedDate() {
    final start = groupData['start'];
    final end = groupData['end'];
    if (start != '' && end != '') {
      return '$start ~ $end';
    }
    return '기간을 선택해주세요';
  }

  void changeGroupData(int i, int j) {
    setState(() {
      selectedIndex[i] = j;
    });
    setGroupData(i == 0 ? 'size' : 'need_auth')(convertedValues[i][j]);
  }

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
      print(
          'start => ${groupData['start']}-----, end => ${groupData['end']}------');
      print(
          '${groupData['start'].runtimeType} ${groupData['end'].runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: const AppBarWithBack(title: '그룹 생성'),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ColWithPadding(
            horizontal: 50,
            vertical: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                title: '그룹명',
                explainTitle: const ['필수', '시작일 전 수정 가능'],
                explain: '그룹명을 입력하세요',
                setValue: setGroupData('groupname'),
                initialValue: groupData.containsKey('groupname')
                    ? groupData['groupname']
                    : getGroupName(context),
              ),
              CustomInput(
                title: '참여인원 *',
                explain: '참여인원',
                onlyNum: true,
                setValue: setGroupData('headcount'),
                initialValue: groupData.containsKey('headcount')
                    ? groupData['headcount'].toString()
                    : context.read<GlobalGroupProvider>().headCount?.toString(),
              ),
              if (widget.groupId == null)
                Column(
                  children: [
                    InputDate(
                      title: '기간 *',
                      explain: selectedDate(),
                      start: groupData.containsKey('start')
                          ? groupData['start']
                          : getStart(context) ?? '',
                      end: groupData.containsKey('end')
                          ? groupData['end']
                          : context.read<GlobalGroupProvider>().end ?? '',
                      // onSubmit: setGroupData,
                      applyDay: applyDay,
                    ),
                    const CustomText(
                      content: '빙고 크기 *',
                      center: false,
                    ),
                    for (int i = 0; i < 2; i += 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int j = 0; j < 2; j += 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomBoxContainer(
                                borderColor: selectedIndex[0] == 2 * i + j
                                    ? null
                                    : greyColor,
                                onTap: () => changeGroupData(0, 2 * i + j),
                                width: 120,
                                height: 30,
                                color: selectedIndex[0] == 2 * i + j
                                    ? paleOrangeColor
                                    : whiteColor,
                                // boxShadow: applyBoxShadow(0, 2 * i + j),
                                child: Center(
                                  child: CustomText(
                                    content: printedValues[0][2 * i + j],
                                    color: selectedIndex[0] == 2 * i + j
                                        ? whiteColor
                                        : blackColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    expainDivider(
                        '총 ${(selectedIndex[0] + 2) * (selectedIndex[0] + 2)} 칸의 빙고판이 만들어집니다.'),
                    const CustomText(
                      content: '그룹 가입 시 자동 승인 여부*',
                      center: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int j = 0; j < 2; j += 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CustomBoxContainer(
                              borderColor:
                                  selectedIndex[1] == j ? null : greyColor,
                              onTap: () => changeGroupData(1, j),
                              width: 120,
                              height: 60,
                              color: selectedIndex[1] == j
                                  ? paleOrangeColor
                                  : whiteColor,
                              // boxShadow: applyBoxShadow(1, j),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: CustomText(
                                    content: printedValues[1][j],
                                    color: selectedIndex[1] == j
                                        ? whiteColor
                                        : blackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    expainDivider(
                      selectedIndex[1] == 0
                          ? '가입 신청 후, 그룹장의 허가가 있어야 가입됩니다.'
                          : '가입 신청 시, 자동으로 가입됩니다.',
                    ),
                    RowWithPadding(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(content: '그룹 공개 *'),
                          CustomSwitch(
                            value: isChecked,
                            onChanged: (_) {
                              setState(() {
                                isChecked = !isChecked;
                              });
                              setGroupData('is_public')(isChecked);
                            },
                          )
                        ]),
                    CustomText(
                      center: false,
                      content:
                          isChecked ? '추천 그룹, 검색 화면에 노출됩니다' : '초대로만 가입이 가능합니다',
                      fontSize: FontSize.smallSize,
                      color: greyColor,
                    ),
                    if (!isChecked)
                      CustomInput(
                        title: '그룹 가입 시 비밀번호 *',
                        explain: '비밀번호',
                        maxLength: 20,
                        setValue: setGroupData('password'),
                        initialValue: groupData.containsKey('password')
                            ? groupData['password']
                            : context.read<GlobalGroupProvider>().password,
                      )
                  ],
                ),
              const CustomDivider(),
              CustomInput(
                title: '그룹 설명',
                needMore: true,
                maxLength: 1000,
                setValue: setGroupData('description'),
                initialValue: groupData.containsKey('description')
                    ? groupData['description']
                    : context.read<GlobalGroupProvider>().description,
              ),
              CustomInput(
                title: '그룹 규칙',
                needMore: true,
                maxLength: 1000,
                setValue: setGroupData('rule'),
                initialValue: groupData.containsKey('rule')
                    ? groupData['rule']
                    : context.read<GlobalGroupProvider>().rule,
              ),
              const CustomText(content: '그룹 배경'),
              groupImage(),
            ],
          ),
        ),
        bottomNavigationBar: FormBottomBar(createOrUpdate: createOrUpdate));
  }

  Column expainDivider(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          content: content,
          fontSize: FontSize.smallSize,
          color: greyColor,
        ),
        const CustomDivider(),
      ],
    );
  }

  CustomBoxContainer groupImage() {
    if (selectedImage == null) {
      if (hasImg) {
        return CustomBoxContainer(
          width: 270,
          height: 150,
          child: Stack(
            children: [
              CachedNetworkImage(
                placeholder: (context, url) =>
                    const SizedBox(width: 270, height: 150),
                imageUrl: '${dotenv.env['fileUrl']}/groups/${widget.groupId}',
                // errorWidget: ,
              ),
              CustomIconButton(
                onPressed: deleteImage,
                icon: closeIcon,
              ),
            ],
          ),
        );
      }
      return CustomBoxContainer(
        width: 270,
        height: 150,
        onTap: imagePicker,
        borderColor: greyColor,
        hasRoundEdge: false,
        child: CustomIconButton(
          icon: addIcon,
          onPressed: imagePicker,
          color: greyColor,
        ),
      );
    } else {
      return CustomBoxContainer(
        width: 270,
        height: 150,
        onTap: imagePicker,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: FileImage(File(selectedImage!.path)),
        ),
        child: CustomIconButton(
          onPressed: deleteImage,
          icon: closeIcon,
        ),
      );
    }
  }

  // BoxShadowList applyBoxShadow(int i, int j) {
  //   if (selectedIndex[i] == j) {
  //     return [selectedShadow];
  //   } else {
  //     return [defaultShadow];
  //   }
  // }
}
