import 'dart:io';

import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//? 그룹 채팅
class GroupChat extends StatefulWidget {
  const GroupChat({
    super.key,
  });

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  //* 변수
  int groupId = 0;
  double appBarHeight = 50;
  bool showImg = false;
  XFile? selectedImage;
  final controller = ScrollController();
  GlobalKey bottomBarKey = GlobalKey();
  StringMap chatText = {'content': ''};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //* 채팅 데이터 초기화
      if (getChats(context).isNotEmpty) {
        context.read<GlobalGroupProvider>().clearChat();
      }
      //* 변수 초기화
      groupId = getGroupId(context)!;
      setState(() {
        appBarHeight = getStatusBarHeight(context);
      });

      //* 채팅 불러오기
      initLoadingData(context, 0);
      if (getLoading(context)) {
        readChats(false);
      }
    });

    //* 무한 스크롤 적용
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent * 0.95) {
        if (getLastId(context, 0) != -1) {
          if (!getWorking(context)) {
            setWorking(context, true);
            afterFewSec(() {
              if (!getAdditional(context)) {
                setAdditional(context, true);
                if (getAdditional(context)) {
                  readChats();
                }
              }
            }, 2000);
          }
        }
      }
    });
  }

  //* 채팅 목록 불러오기
  void readChats([bool more = true]) {
    GroupProvider()
        .readGroupChatList(groupId, getLastId(context, 0))
        .then((data) {
      if (data.isNotEmpty) {
        context.read<GlobalGroupProvider>().addChats(data);
      }
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
    }).catchError((error) {
      showErrorModal(context, '채팅 불러오기 오류', '오류가 발생해 채팅 목록을 불러올 수 없습니다');
    });
  }

  void changeChat(String value) {
    chatText['content'] = value;
  }

  //* 채팅 추가
  void addChat() {
    final content = chatText['content'];
    if (content != '' || selectedImage != null) {
      showSpinner(context, true);
      if (showImg) {
        setState(() {
          showImg = false;
        });
      }

      GroupProvider()
          .createGroupChatChat(
        groupId,
        FormData.fromMap({
          'content': content,
          'img': selectedImage != null
              ? MultipartFile.fromFileSync(
                  selectedImage!.path,
                  contentType: MediaType('image', 'png'),
                )
              : null,
        }),
      )
          .then((data) {
        showSpinner(context, false);
        context.read<GlobalGroupProvider>().insertChat(
              GroupChatModel.fromJson(
                {
                  ...data,
                  'content': content,
                  'reviewed': false,
                  'hasImage': selectedImage != null,
                },
              ),
            );
        setState(() {
          chatText['content'] = '';
          selectedImage = null;
        });
      }).catchError((_) {
        showErrorModal(context, '채팅 생성 오류', '채팅 생성에 실패했습니다.');
      });
    }
  }

  //* 이미지 선택
  void chatImagePicker() {
    return imagePicker(
      context,
      thenFunc: (localImage) {
        if (localImage != null) {
          setState(() {
            selectedImage = localImage;
            showImg = true;
          });
        }
      },
    );
  }

  //* 이미지 삭제
  void deleteImg() {
    setState(() {
      selectedImage = null;
      showImg = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            //* 채팅 목록
            Padding(
              padding: EdgeInsets.only(top: appBarHeight, bottom: 80),
              child: ChatInfiniteScroll(
                controller: controller,
                data: watchChats(context),
              ),
            ),
            //* 앱 바
            const CustomBoxContainer(
              color: transparentColor,
              height: 70,
              child: AppBarWithBack(transparent: true),
            ),
            //* 채팅 입력창
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GroupChatBottomBar(
                  changeChat: changeChat,
                  addChat: addChat,
                  imagePicker: chatImagePicker,
                ),
              ],
            ),
            //* 이미지 미리보기
            if (showImg)
              CustomBoxContainer(
                hasRoundEdge: false,
                width: getWidth(context),
                height: getHeight(context),
                color: blackColor.withOpacity(0.8),
                child: Padding(
                  padding: EdgeInsets.only(top: appBarHeight + 10),
                  child: ColWithPadding(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    vertical: 10,
                    children: [
                      CustomBoxContainer(
                        height: getHeight(context) * 0.8,
                        hasRoundEdge: false,
                        color: transparentColor,
                        image: DecorationImage(
                          image: FileImage(File(selectedImage!.path)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              onPressed: addChat,
                              content: '전송',
                              color: paleRedColor,
                              textColor: whiteColor,
                            ),
                            const SizedBox(width: 20),
                            CustomButton(
                              onPressed: deleteImg,
                              content: '취소',
                              color: whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            //* 스피너
            if (watchSpinner(context))
              CustomBoxContainer(
                hasRoundEdge: false,
                width: getWidth(context),
                height: getHeight(context),
                color: blackColor.withOpacity(0.8),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CustomCirCularIndicator()],
                ),
              )
          ],
        ),
      ),
    );
  }
}
