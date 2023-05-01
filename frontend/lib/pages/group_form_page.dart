import 'dart:convert';
import 'dart:io';

import 'package:bin_got/pages/group_create_completed.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

//* 그룹 생성/수정 페이지
class GroupForm extends StatefulWidget {
  final int? groupId;
  const GroupForm({super.key, this.groupId});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  //* select box
  final labelList = ['빙고 크기 *', '그룹 가입 시 자동 승인 여부'];
  final printedValues = [
    ['2 * 2', '3 * 3', '4 * 4', '5 * 5'],
    ['그룹장의 승인 필요', '자동 가입']
  ];
  final convertedValues = [
    [2, 3, 4, 5],
    [true, false]
  ];
  final List<dynamic> selectedIndex = [0, 0];

  XFile? selectedImage;
  bool isChecked = true;
  BoolList showList = [false, false];

  @override
  void initState() {
    super.initState();
    if (widget.groupId == null) {
      groupData = {
        'groupname': '',
        'start': '',
        'end': '',
        'size': 0, // 0
        'is_public': true,
        'password': '',
        'description': '',
        'rule': '',
        'need_auth': true, // true
        'headcount': 0
      };
    } else {
      groupData = {};
    }
  }

  late final Map<String, dynamic> groupData;

  void Function(dynamic) setGroupData(BuildContext context, String key) {
    return (value) => groupData[key] = value;
  }

  void changeShowState(int index) {
    print(index);
    print(showList);
    setState(() {
      if (!showList[index]) {
        showList[index] = true;
      } else {
        showList[index] = false;
      }
    });
  }

  void changeSelected({
    required int index,
    required int listItemIndex,
    required String key,
  }) {
    setState(() {
      selectedIndex[index] = listItemIndex;
      changeShowState(index);
      setGroupData(context, key)(convertedValues[index][listItemIndex]);
    });
  }

  void createOrUpdate() async {
    if (groupData['headcount'].runtimeType != int) {
      groupData['headcount'] = int.parse(groupData['headcount']);
    }
    if (groupData['groupname'].length < 3) {
      showAlert(context, title: '그룹명 오류', content: '그룹명을 3자 이상으로 입력해주세요.')();
    } else if (groupData['headcount'] < 1 || groupData['headcount'] > 30) {
      showAlert(context,
          title: '인원 수 오류', content: '인원 수는 1명 이상 30명 이하로 입력해주세요.')();
    } else if (!groupData['is_public'] && groupData['password'].length < 4) {
      showAlert(context,
          title: '비밀번호 오류', content: '그룹 비밀번호를 4자 이상으로 입력해주세요.')();
    } else if (widget.groupId == null) {
      GroupProvider()
          .createOwnGroup(FormData.fromMap({
        'data': jsonEncode(groupData),
        'img': selectedImage != null
            ? MultipartFile.fromFileSync(selectedImage!.path,
                contentType: MediaType('image', 'jpg'))
            : null,
      }))
          .then((groupId) {
        toOtherPage(
          context,
          page: GroupCreateCompleted(
            groupId: groupId,
            password: groupData['password'],
          ),
        )();
      });
    } else {
      print(groupData);
      GroupProvider()
          .editOwnGroup(
              widget.groupId!,
              FormData.fromMap({
                'data': groupData,
                'img': selectedImage,
              }))
          .then((groupId) {
        toBack(context)();
      });
    }
  }

  void imagePicker() async {
    final ImagePicker picker = ImagePicker();
    final localImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      selectedImage = localImage;
    });
  }

  void deleteImage() {
    setState(() {
      selectedImage = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ColWithPadding(
            horizontal: 30,
            vertical: 40,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CustomText(
                  content: '그룹 생성',
                  center: true,
                  fontSize: FontSize.titleSize,
                ),
              ),
              CustomInput(
                title: '그룹명 *',
                explain: '그룹명을 입력하세요',
                setValue: setGroupData(context, 'groupname'),
              ),
              CustomInput(
                title: '참여인원 *',
                explain: '참여인원',
                onlyNum: true,
                setValue: setGroupData(context, 'headcount'),
              ),
              InputDate(
                title: '기간 *',
                explain: selectedDate(),
                onSubmit: setGroupData,
              ),
              for (int i = 0; i < 2; i += 1)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomText(content: labelList[i]),
                    Stack(
                      children: [
                        SelectBox(
                          value: printedValues[i][selectedIndex[i]],
                          width: 60,
                          height: 50,
                          onTap: () => changeShowState(i),
                        ),
                        showList[i]
                            ? sortList(
                                listItems: printedValues[i],
                                valueItems: convertedValues[i],
                                index: i,
                                key: i == 0 ? 'size' : 'need_auth',
                              )
                            : const SizedBox(),
                      ],
                    )
                  ],
                ),
              CustomCheckBox(
                label: '공개 여부 *',
                value: isChecked,
                onChange: (_) {
                  setState(() {
                    isChecked = !isChecked;
                  });
                  setGroupData(context, 'is_public')(isChecked);
                },
              ),
              !isChecked
                  ? CustomInput(
                      title: '그룹 가입 시 비밀번호 *',
                      explain: '비밀번호',
                      maxLength: 20,
                      setValue: setGroupData(context, 'password'),
                    )
                  : const SizedBox(),
              CustomInput(
                title: '그룹 설명',
                needMore: true,
                maxLength: 1000,
                setValue: setGroupData(context, 'description'),
              ),
              CustomInput(
                title: '그룹 규칙',
                needMore: true,
                maxLength: 1000,
                setValue: setGroupData(context, 'rule'),
              ),
              const CustomText(content: '그룹 배경'),
              groupImage(),
            ],
          ),
        ),
        bottomNavigationBar: FormBottomBar(createOrUpdate: createOrUpdate));
  }

  Padding sortList({
    required List listItems,
    required List valueItems,
    required int index,
    required String key,
  }) {
    final length = listItems.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomBoxContainer(
            hasRoundEdge: false,
            width: 150,
            color: whiteColor,
            boxShadow: const [defaultShadow],
            child: Column(
              children: [
                for (int i = 0; i < length; i += 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomBoxContainer(
                      onTap: () => changeSelected(
                        index: index,
                        listItemIndex: i,
                        key: key,
                      ),
                      width: 150,
                      child: Center(
                        child: CustomText(
                          content: listItems[i],
                          fontSize: FontSize.smallSize,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomBoxContainer groupImage() {
    return selectedImage == null
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
          );
  }
}
