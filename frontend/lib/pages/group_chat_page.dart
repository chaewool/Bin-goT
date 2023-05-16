import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/badge.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatelessWidget {
  final int groupId;
  const GroupChat({
    super.key,
    this.groupId = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBack(),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: StreamBuilder<List<ChatDetailModel>>(
                stream: streamChats(groupId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('오류가 발생했습니다.'));
                  } else {
                    List<ChatDetailModel> chats = snapshot.data!;

                    return Column(
                      children: [
                        for (var chat in chats) chatBox(context, chat)
                      ],
                    );
                  }
                },
              )),
            ),
            const GroupChatBottomBar()
          ],
        ),
      ),
    );
  }

  Stream<List<ChatDetailModel>> streamChats(int groupId) {
    try {
      // 해당 그룹의 메세지 컬렉션의 스냅샷(stream) 가져오기
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('chatrooms/$groupId/messages')
          .snapshots();

      print('스냅샷: $snapshots');

      // 스냅샷 내부의 자료들을 List<ChatDetailModel>로 변환
      return snapshots.map((querySnapshot) {
        List<ChatDetailModel> chats = [];

        for (var element in querySnapshot.docs) {
          chats.add(
              ChatDetailModel.fromJson(element.id, element.data as DynamicMap));
        }

        return chats;
      });
    } catch (error) {
      print('에러: $error');
      return Stream.error(error.toString());
    }
  }

  Padding chatBox(BuildContext context, ChatDetailModel chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: CustomBoxContainer(
        onTap: chat.needCheck
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CustomBadge(radius: 20),
                  ),
                  CustomText(
                    content: chat.nickname,
                    fontSize: FontSize.smallSize,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CustomText(
                    content: chat.needCheck ? '코딩테스트 10회 응시 (1/10)' : '채팅'),
              ),
              chat.needCheck ? halfLogo : const SizedBox(),
              chat.needCheck
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
}
