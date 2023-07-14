import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/list.dart';
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
  late Future<GroupChatList> chats;

  @override
  void initState() {
    super.initState();
    readChats();
  }

  void readChats() async {
    GroupProvider()
        .readGroupChatList(
      widget.groupId,
      widget.page,
    )
        .then((data) {
      if (data is GroupChatList) {
        chats = data;
      }
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
                child: FutureBuilder(
                    future: chats,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        if (data!.isNotEmpty) {
                          return Flexible(
                            fit: FlexFit.loose,
                            child: groupChatList(data),
                          );
                        }
                        return Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            children: const [
                              CustomText(
                                center: true,
                                fontSize: FontSize.titleSize,
                                content: '채팅 기록이 없습니다.',
                                height: 1.5,
                              ),
                            ],
                          ),
                        );
                      }
                      return const Flexible(
                        fit: FlexFit.loose,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    })),
            GroupChatBottomBar(groupId: widget.groupId)
          ],
        ),
      ),
    );
  }

  ListView groupChatList(GroupChatList data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ChatListItem(data: data[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
