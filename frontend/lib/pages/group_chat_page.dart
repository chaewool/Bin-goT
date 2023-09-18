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

class GroupChat extends StatefulWidget {
  // final int bingoId;
  const GroupChat({
    super.key,
    // required this.bingoId,
  });

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  // GroupChatList chats = [];
  int groupId = 0;
  final controller = ScrollController();
  bool showImg = false;
  XFile? selectedImage;
  GlobalKey bottomBarKey = GlobalKey();
  double appBarHeight = 50;
  double bottomBarHeight = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getChats(context).isNotEmpty) {
        context.read<GlobalGroupProvider>().clearChat();
      }
      groupId = getGroupId(context)!;
      print('group id => $groupId');
      initLoadingData(context, 0);
      if (getLoading(context)) {
        readChats(false);
      }
      setState(() {
        appBarHeight = MediaQuery.of(context).padding.top;
      });
      getImgHeight();
    });

    controller.addListener(() {
      // print(
      // 'pixels => ${controller.position.pixels}, max => ${controller.position.maxScrollExtent}');
      if (controller.position.pixels >=
          controller.position.maxScrollExtent * 0.95) {
        print('last id => ${getLastId(context, 0)}');
        if (getLastId(context, 0) != -1) {
          // print('${getPage(context, 0)}, ${getTotal(context, 0)}');
          // if (getPage(context, 1) < getTotal(context, 1)!) {
          if (!getWorking(context)) {
            setWorking(context, true);
            Future.delayed(const Duration(seconds: 2), () {
              if (!getAdditional(context)) {
                setAdditional(context, true);
                if (getAdditional(context)) {
                  readChats();
                }
              }
            });
          }
        }
      }
    });
  }

  void getImgHeight() {
    if (bottomBarKey.currentContext != null) {
      final renderBox =
          bottomBarKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        bottomBarHeight = renderBox.size.height;
      });
    }
  }

  void readChats([bool more = true]) {
    GroupProvider()
        .readGroupChatList(groupId, getLastId(context, 0))
        .then((data) {
      print('read chat data => $data');
      print('last id => ${getLastId(context, 0)}');
      if (data.isNotEmpty) {
        context.read<GlobalGroupProvider>().addChats(data);
      }
      setLoading(context, false);
      print('read loading ${getLoading(context)}');
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
    }).catchError((error) {});
  }

  void addChat(StringMap inputData, XFile? image) {
    final content = inputData['content'];
    if (content != '' || image != null) {
      showSpinner(context, true);
      if (showImg) {
        setState(() {
          showImg = false;
          selectedImage = null;
        });
      }
      GroupProvider()
          .createGroupChatChat(
        groupId,
        FormData.fromMap({
          'content': content,
          'img': image != null
              ? MultipartFile.fromFileSync(
                  image.path,
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
                  'hasImage': image != null,
                },
              ),
            );
      });
    }
  }

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

  void deleteImg() {
    setState(() {
      selectedImage = null;
      showImg = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('appbar => $appBarHeight, bottom => $bottomBarHeight');
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: appBarHeight, bottom: 80),
              child: ChatInfiniteScroll(
                  // color: greyColor.withOpacity(0.2),
                  color: whiteColor,
                  controller: controller,
                  data: watchChats(context)),
            ),
            const CustomBoxContainer(
              color: Colors.transparent,
              height: 70,
              child: AppBarWithBack(transparent: true),
            ),
            if (showImg)
              CustomBoxContainer(
                hasRoundEdge: false,
                width: getWidth(context),
                height: getHeight(context) - 80 + appBarHeight,
                color: blackColor.withOpacity(0.8),
                child: ColWithPadding(
                  vertical: 10,
                  children: [
                    CustomBoxContainer(
                      height: getHeight(context) - 150,
                      hasRoundEdge: false,
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: FileImage(File(selectedImage!.path)),
                      ),
                    ),
                    CustomButton(
                      onPressed: deleteImg,
                      content: '취소',
                      color: whiteColor,
                    )
                  ],
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GroupChatBottomBar(
                  addChat: addChat,
                  selectedImage: selectedImage,
                  imagePicker: chatImagePicker,
                ),
              ],
            ),
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
