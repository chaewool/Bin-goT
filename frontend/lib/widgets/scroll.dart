import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:flutter/material.dart';

// class GroupScroll extends StatelessWidget {
//   final MyGroupList myGroupList;
//   final bool hasNotGroup;
//   final bool isSearch;
//   const GroupScroll({
//     super.key,
//     required this.myGroupList,
//     required this.isSearch,
//     required this.hasNotGroup,
//   });

//   @override
//   Widget build(BuildContext context) {
//     print('has not group => $hasNotGroup');
//     return GroupInfiniteScroll(
//       data: myGroupList,
//       mode: isSearch ? 0 : 1,
//       emptyWidget: Column(
//         children: const [
//           CustomText(
//             center: true,
//             content: '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
//             height: 1.7,
//           ),
//         ],
//       ),
//       hasNotGroupWidget: hasNotGroup
//           ? Column(
//               children: const [
//                 CustomText(
//                   center: true,
//                   content: '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
//                   height: 1.7,
//                 ),
//                 SizedBox(
//                   height: 70,
//                 ),
//                 CustomText(
//                   content: '추천그룹',
//                   fontSize: FontSize.titleSize,
//                 ),
//               ],
//             )
//           : null,
//     );
//   }
// }

// class BingoScroll extends StatelessWidget {
//   final MyBingoList myBingoList;
//   const BingoScroll({
//     super.key,
//     required this.myBingoList,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InfiniteScroll(
//       data: myBingoList,
//       mode: 2,
//       emptyWidget: const Padding(
//         padding: EdgeInsets.only(top: 40),
//         child: CustomText(
//           center: true,
//           height: 1.7,
//           content: '아직 생성한 빙고가 없어요.\n그룹 내에서\n빙고를 생성해보세요.',
//         ),
//       ),
//     );
//   }
// }

// class ChatScroll extends StatelessWidget {
//   final GroupChatList groupChatList;
//   const ChatScroll({
//     super.key,
//     required this.groupChatList,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InfiniteScroll(
//       data: groupChatList,
//       mode: 0,
//       emptyWidget: Column(
//         children: const [
//           CustomText(
//             center: true,
//             content: '그룹 채팅 데이터가 없습니다',
//             height: 1.7,
//           ),
//         ],
//       ),
//     );
//   }
// }

class GroupInfiniteScroll extends StatelessWidget {
  final List data;
  final int mode;
  final Widget emptyWidget;
  final Widget? hasNotGroupWidget;
  final ScrollController controller;
  // final MyGroupModel? myGroupModel;
  // final bool isGroupMode, isChatMode, isSearchMode, hasNotGroup;
  const GroupInfiniteScroll({
    super.key,
    required this.data,
    required this.emptyWidget,
    required this.mode,
    required this.controller,
    this.hasNotGroupWidget,
    // required this.myGroupModel,
  });

  @override
  Widget build(BuildContext context) {
    print('widget => $hasNotGroupWidget');
    return CustomBoxContainer(
      color: palePinkColor.withOpacity(0.8),
      child: !watchLoading(context)
          ? data.isNotEmpty
              ? Column(
                  children: [
                    if (hasNotGroupWidget != null)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          hasNotGroupWidget!,
                        ],
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              // i < getPage(context, mode) * 10
                              //     ?
                              data[i].id != getLastId(context, mode)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      child: GroupListItem(
                                        isSearchMode: mode == 0,
                                        groupInfo: data[i],
                                        public: data[i].isPublic,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 5),
                                          child: GroupListItem(
                                            isSearchMode: mode == 0,
                                            groupInfo: data[i],
                                            public: data[i].isPublic,
                                          ),
                                        ),
                                        if (hasNotGroupWidget == null &&
                                            getLastId(context, mode) != -1)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 40,
                                            ),
                                            child: CustomCirCularIndicator(),
                                          )
                                      ],
                                    ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                )
              : emptyWidget
          : const CustomCirCularIndicator(),
      // CustomText(content: '빙고 정보를 불러오는 중입니다')
    );
  }
}

class InfiniteScroll extends StatelessWidget {
  final List data;
  final int cnt, mode;
  final Widget emptyWidget;
  final bool reverse;
  final ScrollController controller;
  final Color color;
  // final MyGroupModel? myGroupModel;
  // final bool isGroupMode, isChatMode, isSearchMode, hasNotGroup;
  const InfiniteScroll({
    super.key,
    required this.data,
    this.cnt = 10,
    required this.emptyWidget,
    required this.mode,
    required this.controller,
    this.reverse = false,
    this.color = palePinkColor,
    // this.isChatMode = false,
  });

  @override
  Widget build(BuildContext context) {
    print('last id => ${getLastId(context, mode)}');
    return CustomBoxContainer(
      color: color,
      child: !watchLoading(context)
          ? data.isNotEmpty
              ? ListView.builder(
                  controller: controller,
                  reverse: reverse,
                  // hasNotGroupWidget ?? const SizedBox(),
                  itemCount: mode != 2 ? data.length : (data.length / 2).ceil(),
                  itemBuilder: (context, i) {
                    final length = data.length;
                    final hasTwo =
                        i != (length / 2).ceil() - 1 || data.length % 2 == 0;
                    final lastIdx = hasTwo ? 2 * i + 1 : 2 * i;
                    final returnedWidget = mode == 2
                        ? Row(
                            children: [
                              Flexible(
                                child: BingoGallery(bingo: data[2 * i]),
                              ),
                              Flexible(
                                child: hasTwo
                                    ? BingoGallery(bingo: data[2 * i + 1])
                                    : const SizedBox(),
                              ),
                            ],
                          )
                        : ChatListItem(
                            data: data[i],
                            date: i == data.length - 1 ||
                                    returnDate(data[i]) !=
                                        returnDate(data[i + 1])
                                ? returnDate(data[i])
                                : null,
                          );
                    return Column(
                      children: [
                        // i < getPage(context, mode) * cnt
                        // ?
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: returnedWidget,
                        ),
                        if (getLastId(context, mode) > 0 &&
                            (data[lastIdx].id == getLastId(context, mode)))
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 40,
                            ),
                            child: CustomCirCularIndicator(),
                          )
                        // : const SizedBox(),
                      ],
                    );
                  },
                )
              : emptyWidget
          : const CustomCirCularIndicator(),
      // CustomText(content: '빙고 정보를 불러오는 중입니다')
    );
  }
}
