import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 빙고판
class BingoBoard extends StatefulWidget {
  final bool isDetail;
  final int? bingoSize;
  const BingoBoard({
    super.key,
    required this.isDetail,
    this.bingoSize,
  });

  @override
  State<BingoBoard> createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  late final int? size;
  @override
  void initState() {
    super.initState();
    setState(() {
      size = widget.bingoSize ?? getBingoSize(context);
      print('size => $size');
    });
  }

  double applyGap() {
    switch (watchGap(context, widget.isDetail)) {
      case 0:
        return 0;
      case 1:
        return 8;
      default:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            for (int i = 0; i < size!; i += 1)
              Flexible(
                child: Row(
                  children: [
                    for (int j = 0; j < size!; j += 1)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(applyGap()),
                          child: DragTarget<int>(
                            builder: (context, _, rejectedData) => EachBingo(
                              size: size!,
                              isDetail: widget.isDetail,
                              index: size! * i + j,
                            ),
                            onAccept: (data) {
                              if (!widget.isDetail) {
                                final index = size! * i + j;
                                context
                                    .read<GlobalBingoProvider>()
                                    .changeItem(data, index);
                              }
                            },
                          ),
                        ),
                      )
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

//* 빙고칸
class EachBingo extends StatelessWidget {
  final bool isDetail;
  final int index;
  final int size;

  const EachBingo({
    super.key,
    required this.size,
    required this.index,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    Color convertedColor() =>
        watchHasBlackBox(context, isDetail) ? whiteColor : blackColor;
    return Draggable<int>(
      feedback: isDetail
          ? const SizedBox()
          : Transform.translate(
              offset: const Offset(50, 50),
              child: CustomBoxContainer(
                color: whiteColor,
                borderColor: greyColor,
                width: 100,
                height: 100,
                hasRoundEdge: false,
                child: Center(
                  child: CustomText(
                    content:
                        watchItemTitle(context, index, isDetail) ?? '빙고칸 제목',
                    font: getStringFont(context),
                  ),
                ),
              ),
            ),
      childWhenDragging: isDetail
          ? draggableBox(context, convertedColor)
          : CustomBoxContainer(
              hasRoundEdge: watchHasRoundEdge(context, isDetail),
              color: whiteColor,
            ),
      data: index,
      child: draggableBox(context, convertedColor),
    );
  }

  CustomBoxContainer draggableBox(
      BuildContext context, Color Function() convertedColor) {
    return CustomBoxContainer(
      onTap: showModal(
        context,
        page: isDetail
            ? BingoDetailModal(index: index, cnt: size * size)
            : BingoFormModal(index: index, cnt: size * size),
      ),
      child: CustomBoxContainer(
        color: watchHasBlackBox(context, isDetail) ? blackColor : whiteColor,
        hasRoundEdge: watchHasRoundEdge(context, isDetail),
        borderColor:
            watchHasBorder(context, isDetail) == true ? convertedColor() : null,
        child: Stack(
          children: [
            Center(
              child: CustomText(
                color: convertedColor(),
                content: watchItemTitle(context, index, isDetail) ?? '빙고칸 제목',
                font: getStringFont(context, isDetail),
                center: true,
                maxLines: 2,
                cutText: true,
              ),
            ),
            if (!isDetail &&
                    context.watch<GlobalBingoProvider>().isCheckTheme ||
                (isDetail && watchFinished(context)![index]))
              Center(
                child: CustomIcon(
                  icon: getCheckIconData(context, isDetail),
                  size: 80,
                  color: convertedColor(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
