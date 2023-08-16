import 'dart:io';

import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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
  GroupChatList chats = [];
  late int groupId;
  final controller = ScrollController();
  bool showImg = false;
  XFile? selectedImage;
  GlobalKey bottomBarKey = GlobalKey();
  double appBarHeight = 50;

  @override
  void initState() {
    super.initState();
    groupId = getGroupId(context)!;
    print('group id => $groupId');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadingData(context, 0);
      if (readLoading(context)) {
        readChats(false);
      }
      appBarHeight += MediaQuery.of(context).padding.top + 20;
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
            Future.delayed(const Duration(seconds: 3), () {
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
        appBarHeight += renderBox.size.height;
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
        chats.addAll(data);
      }
      setLoading(context, false);
      print('read loading ${readLoading(context)}');
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
    }).catchError((error) {});
  }

  void addChat(StringMap inputData, XFile? image) {
    final content = inputData['content'];
    if (content != '' || image != null) {
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
        setState(() {
          chats.insert(
              0,
              GroupChatModel.fromJson({
                ...data,
                'content': content,
                'reviewed': false,
                'hasImage': image != null
              }));
        });
        if (showImg) {
          setState(() {
            showImg = false;
          });
        }
      });
    }
  }

  void imagePicker() async {
    final ImagePicker picker = ImagePicker();
    final localImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (localImage != null) {
      setState(() {
        selectedImage = localImage;
        showImg = true;
      });
    }
    print(showImg);
  }

  void deleteImg() async {
    setState(() {
      selectedImage = null;
      showImg = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppBarWithBack(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: InfiniteScroll(
                  color: whiteColor,
                  controller: controller,
                  cnt: 50,
                  reverse: true,
                  data: chats,
                  mode: 0,
                  emptyWidget: const Column(
                    children: [
                      CustomText(
                        center: true,
                        fontSize: FontSize.titleSize,
                        content: '채팅 기록이 없습니다.',
                        height: 1.5,
                      ),
                    ],
                  ),
                ),
              ),
              GroupChatBottomBar(
                key: bottomBarKey,
                addChat: addChat,
                selectedImage: selectedImage,
                imagePicker: imagePicker,
              ),
            ],
          ),
          if (showImg)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomBoxContainer(
                  hasRoundEdge: false,
                  width: getWidth(context),
                  height: getHeight(context) - appBarHeight,
                  color: Colors.black38,
                  image: DecorationImage(
                    image: FileImage(
                      File(selectedImage!.path),
                    ),
                  ),
                  child: CustomIconButton(
                    icon: closeIcon,
                    onPressed: deleteImg,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
