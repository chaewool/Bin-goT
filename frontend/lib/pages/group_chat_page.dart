import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  final int page, groupId;
  const GroupChat({
    super.key,
    required this.page,
    required this.groupId,
  });

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  GroupChatList chats = [];
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    initLoadingData(context, 0);
    if (readLoading(context)) {
      readChats(false);
    }

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
    GroupProvider()
        .readGroupChatList(
      widget.groupId,
      widget.page,
    )
        .then((data) {
      if (data is GroupChatList) {
        chats.addAll(data);
        setLoading(context, false);
        if (more) {
          setWorking(context, false);
          setAdditional(context, false);
        }
      }
    });
    increasePage(context, 0);
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
            )),
            GroupChatBottomBar(groupId: widget.groupId)
          ],
        ),
      ),
    );
  }
}
