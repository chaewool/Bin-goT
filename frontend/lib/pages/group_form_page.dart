import 'dart:convert';
import 'dart:io';

import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//* 그룹 생성/수정 페이지
class GroupForm extends StatefulWidget {
  final int? groupId;
  const GroupForm({super.key, this.groupId});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  XFile? selectedImage;
  bool isChecked = true;
  final StringList bingoSize = ['N * N', '2 * 2', '3 * 3', '4 * 4', '5 * 5'];
  final StringList joinMethod = ['그룹장의 승인 필요', '자동 가입'];
  void createGroup() async {
    final groupData = context.read<GroupDataProvider>().groupData;
    if (groupData['groupName'].length < 3) {
      showAlert(context, title: '그룹명 오류', content: '그룹명을 3자 이상으로 입력해주세요.')();
    } else if (groupData['headcount'] < 1 || groupData['headcount'] > 30) {
      showAlert(context,
          title: '인원 수 오류', content: '인원 수는 1명 이상 30명 이하로 입력해주세요.')();
    } else if (!groupData['isPublic'] && groupData['password'].length < 4) {
      showAlert(context,
          title: '비밀번호 오류', content: '그룹 비밀번호를 4자 이상으로 입력해주세요.')();
    } else {
      GroupProvider()
          .createOwnGroup(FormData.fromMap({
            'data': json.encode(groupData),
            'file': selectedImage,
          }))
          .then((groupId) => toOtherPage(context,
              page: GroupCreateCompleted(
                groupId: groupId,
                password: groupData['password'],
              ))());
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

  @override
  Widget build(BuildContext context) {
    // void datePicker() {
    // }

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
              const CustomInput(title: '그룹명 *', explain: '그룹명을 입력하세요'),
              const CustomInput(
                  title: '참여인원 *', explain: '참여인원', onlyNum: true),
              const InputDate(title: '기간 *', explain: '기간'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CustomText(content: '빙고 크기 *'),
                  SelectBox(selectList: bingoSize, width: 60, height: 50),
                ],
              ),
              const CustomText(content: '그룹 가입 시 자동 승인 여부 *'),
              SelectBox(selectList: joinMethod, width: 150, height: 50),
              CustomCheckBox(
                label: '공개 여부 *',
                value: isChecked,
                onChange: (value) {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
              ),
              !isChecked
                  ? Column(
                      children: const [
                        CustomInput(
                          title: '그룹 가입 시 비밀번호 *',
                          explain: '비밀번호',
                          maxLength: 20,
                        ),
                      ],
                    )
                  : const SizedBox(),
              const CustomInput(
                title: '그룹 설명',
                needMore: true,
                maxLength: 1000,
              ),
              const CustomInput(
                title: '그룹 규칙',
                needMore: true,
                maxLength: 1000,
              ),
              const CustomText(content: '그룹 배경'),
              GestureDetector(
                onTap: showModal(context,
                    page: ImageModal(
                      image: selectedImage,
                      imagePicker: imagePicker,
                      deleteImage: deleteImage,
                    )),
                child: selectedImage == null
                    ? const CustomInput(
                        explain: '그룹 이미지를 선택하세요',
                        needMore: true,
                        enabled: false,
                      )
                    : CustomBoxContainer(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(selectedImage!.path)),
                        ),
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: FormBottomBar(createGroup: createGroup));
  }
}

//* 그룹 생성 완료 페이지
class GroupCreateCompleted extends StatelessWidget {
  final bool isPublic;
  final String password;
  final int groupId;
  const GroupCreateCompleted({
    super.key,
    this.isPublic = true,
    this.password = '',
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    String privateInvitation = isPublic ? '' : '비밀번호 : $password';
    String message =
        'ㅇㅇㅇ 그룹에서\n당신을 기다리고 있어요\nBin:goT에서\n같이 계획을 공유해보세요\n $privateInvitation';
    void copyText() {
      Clipboard.setData(ClipboardData(text: message));
    }

    return Scaffold(
      body: ColWithPadding(
        vertical: 60,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const CustomText(
            content: '그룹이\n생성되었습니다',
            fontSize: FontSize.titleSize,
            center: true,
          ),
          const CustomText(
            content: '친구들을\n초대해보세요',
            fontSize: FontSize.largeSize,
            center: true,
          ),
          CustomBoxContainer(
            width: 200,
            height: 200,
            borderColor: blackColor,
            child: Center(
              child: CustomText(
                content: message,
                center: true,
                height: 1.7,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconButtonInRow(
                onPressed: shareToFriends,
                icon: shareIcon,
              ),
              IconButtonInRow(
                onPressed: copyText,
                icon: copyIcon,
              ),
            ],
          ),
          CustomButton(
            content: '생성된 그룹으로 가기',
            onPressed: toOtherPage(
              context,
              page: GroupMain(
                groupId: groupId,
                isPublic: isPublic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
