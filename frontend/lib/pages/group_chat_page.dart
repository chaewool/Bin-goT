import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/row_col.dart';
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
            const GroupChatBottomBar()
          ],
        ),
      ),
    );
  }

  Padding chatBox({bool needAuth = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: CustomBoxContainer(
        onTap: needAuth
            ? showAlert(
                context,
                title: '인증 확인',
                content: '이 인증이 유효한가요?',
              )
            : null,
        color: paleRedColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              RowWithPadding(
                vertical: 5,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleContainer(
                      radius: 20,
                      child: halfLogo,
                    ),
                  ),
                  const CustomText(
                    content: '조코조코링링링',
                    fontSize: FontSize.smallSize,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CustomText(
                    content: needAuth ? '코딩테스트 10회 응시 (1/10)' : '채팅'),
              ),
              needAuth ? halfLogo : const SizedBox(),
              needAuth
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CustomText(
                        content: '유플러스 인턴십 코테도 인정이죠?',
                        fontSize: FontSize.smallSize,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
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
