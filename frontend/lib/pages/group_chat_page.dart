import 'dart:convert';

import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  int page = 1;
  GroupChatList chats = [];
  late int groupId;
  final controller = ScrollController();

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
    });

    controller.addListener(() {
      () {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent * 0.9) {
          print('${getPage(context, 0)}, ${getTotal(context, 0)}');
          if (getPage(context, 1) < getTotal(context, 1)!) {
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
      };
    });
  }

  void readChats([bool more = true]) async {
    GroupProvider().readGroupChatList(groupId, page).then((data) {
      print('chat data => $data');
      if (data is GroupChatList) {
        chats.addAll(data);
        setLoading(context, false);
        if (more) {
          setWorking(context, false);
          setAdditional(context, false);
        }
      }
    }).catchError((error) {});
    increasePage(context, 0);
  }

  void addChat(StringMap content, XFile? image) {
    GroupProvider()
        .createGroupChatChat(
      groupId,
      FormData.fromMap({
        'data': jsonEncode(content),
        'img': image != null
            ? MultipartFile.fromFileSync(
                image.path,
                contentType: MediaType('image', 'png'),
              )
            : null,
      }),
    )
        .then((data) {
      chats.insert(
          0,
          GroupChatModel.fromJson({
            ...data,
            ...content,
            'reviewed': false,
            'hasImage': image != null
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: InfiniteScroll(
                cnt: 50,
                reverse: true,
                data: chats,
                mode: 0,
                emptyWidget: Column(
                  children: const [
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
              groupId: groupId,
              addChat: addChat,
            )
          ],
        ),
      ),
    );
  }
}
