import 'dart:io';

import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
  bool isImageUpdated = false;

  @override
  void initState() {
    super.initState();
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
        'headcount': 0
      };
    } else {
      groupData = {};
      isImageUpdated = true;
    }
  }

  late final Map<String, dynamic> groupData;

  void Function(dynamic) setGroupData(BuildContext context, String key) {
    return (value) => groupData[key] = value;
  }

  void changeShowState(int index) {
    setState(() {
      if (!showList[index]) {
        showList[index] = true;
      } else {
        showList[index] = false;
      }
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
      print(groupData['size']);
      toOtherPage(
        context,
        page: BingoForm(
          beforeData: groupData,
          bingoSize: groupData['size'],
          needAuth: groupData['need_auth'],
        ),
      )();
      // GroupProvider()
      //     .createOwnGroup(FormData.fromMap({
      //   'data': jsonEncode(groupData),
      //   'img': selectedImage != null
      //       ? MultipartFile.fromFileSync(selectedImage!.path,
      //           contentType: MediaType('image', 'png'))
      //       : null,
      // }))
      //     .then((groupId) {
      //   toOtherPage(
      //     context,
      //     page: GroupCreateCompleted(
      //       groupId: groupId,
      //       password: groupData['password'],
      //     ),
      //   )();
      // });
    } else {
      print(groupData);
      GroupProvider()
          .editOwnGroup(
              widget.groupId!,
              FormData.fromMap({
                'data': groupData,
                'img': widget.groupId == null || isImageUpdated
                    ? selectedImage
                    : null,
              }))
          .then((groupId) {
        toBack(context);
      });
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
          setState(() {
            selectedImage = localImage;
            isImageUpdated = true;
          });
        });
      }
    });
  }

  void deleteImage() {
    setState(() {
      selectedImage = null;
      if (widget.groupId != null) {
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
                initialValue: widget.groupId != null
                    ? context.read<GlobalGroupProvider>().groupName
                    : null,
              ),
              CustomInput(
                title: '참여인원 *',
                explain: '참여인원',
                onlyNum: true,
                setValue: setGroupData(context, 'headcount'),
                initialValue:
                    context.read<GlobalGroupProvider>().headCount?.toString(),
              ),
              widget.groupId == null
                  ? InputDate(
                      title: '기간 *',
                      explain: selectedDate(),
                      onSubmit: setGroupData,
                    )
                  : const SizedBox(),
              for (int i = 0; i < 2; i += 1)
                widget.groupId == null
                    ? Column(
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
                                  ? SelectBoxContainer(
                                      listItems: printedValues[i],
                                      valueItems: convertedValues[i],
                                      index: i,
                                      mapKey: i == 0 ? 'size' : 'need_auth',
                                      changeShowState: () => changeShowState(i),
                                      changeIdx: (key, idx) {
                                        setState(() {
                                          selectedIndex[i] = idx;
                                        });
                                        setGroupData(context, key)(
                                            convertedValues[i][idx]);
                                      })
                                  : const SizedBox(),
                            ],
                          )
                        ],
                      )
                    : const SizedBox(),
              widget.groupId == null
                  ? CustomCheckBox(
                      label: '공개 여부 *',
                      value: isChecked,
                      onChange: (_) {
                        setState(() {
                          isChecked = !isChecked;
                        });
                        setGroupData(context, 'is_public')(isChecked);
                      },
                    )
                  : const SizedBox(),
              widget.groupId == null && !isChecked
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
                initialValue: context.read<GlobalGroupProvider>().description,
              ),
              CustomInput(
                title: '그룹 규칙',
                needMore: true,
                maxLength: 1000,
                setValue: setGroupData(context, 'rule'),
                initialValue: context.read<GlobalGroupProvider>().rule,
              ),
              const CustomText(content: '그룹 배경'),
              groupImage(),
            ],
          ),
        ),
        bottomNavigationBar: FormBottomBar(createOrUpdate: createOrUpdate));
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
        : widget.groupId == null
            ? CustomBoxContainer(
                onTap: imagePicker,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: FileImage(File(selectedImage!.path)),
                ),
                child: CustomIconButton(
                  onPressed: deleteImage,
                  icon: closeIcon,
                ),
              )
            : CustomBoxContainer(
                child: Image.network(
                    '${dotenv.env['fileUrl']}/groups/${widget.groupId}'),
              );
  }
}
