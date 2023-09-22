import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupInfiniteScroll extends StatelessWidget {
  final List data;
  final int mode;
  final Widget emptyWidget;
  final Widget? hasNotGroupWidget;
  final ScrollController controller;
  const GroupInfiniteScroll({
    super.key,
    required this.data,
    required this.emptyWidget,
    required this.mode,
    required this.controller,
    this.hasNotGroupWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      hasRoundEdge: mode == 1,
      color: palePinkColor.withOpacity(0.5),
      child: !watchLoading(context)
          ? data.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: GroupListItem(
                                    isSearchMode: mode == 0,
                                    groupInfo: data[i],
                                    public: data[i].isPublic,
                                  ),
                                ),
                                if (getLastId(context, mode) > 0 &&
                                    (data[i].id == getLastId(context, mode)))
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40,
                                    ),
                                    child: CustomCirCularIndicator(),
                                  ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              : emptyWidget
          : const CustomCirCularIndicator(),
    );
  }
}

class BingoInfiniteScroll extends StatelessWidget {
  final MyBingoList data;
  final ScrollController controller;
  const BingoInfiniteScroll({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const mode = 2;
    return CustomBoxContainer(
      color: palePinkColor.withOpacity(0.5),
      child: !watchLoading(context)
          ? data.isNotEmpty
              ? ListView.builder(
                  controller: controller,
                  itemCount: (data.length / 2).ceil(),
                  itemBuilder: (context, i) {
                    final length = data.length;
                    final hasTwo =
                        i != (length / 2).ceil() - 1 || data.length % 2 == 0;
                    final lastIdx = hasTwo ? 2 * i + 1 : 2 * i;

                    final returnedWidget = Row(
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
                    );

                    return Column(
                      children: [
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
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: CustomText(
                        center: true,
                        height: 1.7,
                        content: '조건을 만족하는 빙고가 없어요.',
                      ),
                    ),
                  ],
                )
          : const CustomCirCularIndicator(),
    );
  }
}

class ChatInfiniteScroll extends StatelessWidget {
  final GroupChatList data;
  final ScrollController controller;
  const ChatInfiniteScroll({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const mode = 0;
    return CustomBoxContainer(
      color: whiteColor,
      child: !watchLoading(context)
          ? data.isNotEmpty
              ? ListView.builder(
                  controller: controller,
                  reverse: true,
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        if (getLastId(context, mode) > 0 &&
                            (data[i].id == getLastId(context, mode)))
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: CustomCirCularIndicator(),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: ChatListItem(
                            data: data[i],
                            date: i == data.length - 1 ||
                                    returnDate(data[i]) !=
                                        returnDate(data[i + 1])
                                ? returnDate(data[i])
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: CustomText(
                        center: true,
                        fontSize: FontSize.titleSize,
                        content: '채팅 기록이 없습니다.',
                        height: 1.5,
                      ),
                    ),
                  ],
                )
          : const CustomCirCularIndicator(),
    );
  }
}
