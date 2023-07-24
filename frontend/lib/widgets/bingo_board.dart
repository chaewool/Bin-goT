import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* 빙고판
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
    print('widget => ${widget.bingoSize}, get => ${getBingoSize(context)}');
    setState(() {
      size = widget.bingoSize ?? getBingoSize(context);
    });
  }

  double applyGap() {
    switch (getGap(context)) {
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
        getBackground(context) != null
            ? const CustomBoxContainer(
                hasRoundEdge: false,
                image: DecorationImage(
                  image: AssetImage('assets/images/aaron-burden.jpg'),
                  fit: BoxFit.fill,
                ),
              )
            : const SizedBox(),
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
                            builder: (context, candidateData, rejectedData) =>
                                EachBingo(
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
class EachBingo extends StatefulWidget {
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
  State<EachBingo> createState() => _EachBingoState();
}

class _EachBingoState extends State<EachBingo> {
  // final eachBoxKey = GlobalKey();
  // Offset? position;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getOffset();
    // });
  }

  // void getOffset() {
  //   if (eachBoxKey.currentContext != null) {
  //     final renderBox =
  //         eachBoxKey.currentContext!.findRenderObject() as RenderBox;
  //     setState(() {
  //       position = renderBox.localToGlobal(Offset.zero);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Color convertedColor() => getHasBlackBox(context) ? whiteColor : blackColor;
    return Draggable<int>(
      feedback: widget.isDetail
          ? const SizedBox()
          : Transform.translate(
              offset: const Offset(50, 50),
              child: CustomBoxContainer(
                // key: eachBoxKey,
                color: whiteColor,
                borderColor: greyColor,
                width: 100,
                height: 100,
                hasRoundEdge: false,
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: blackColor,
                      fontFamily: getStringFont(context),
                    ),
                    child: Text(
                      getItemTitle(context, widget.index) ?? '빙고칸 제목',
                    ),
                  ),
                ),
              ),
            ),
      childWhenDragging: widget.isDetail
          ? draggableBox(context, convertedColor)
          : const CustomBoxContainer(color: whiteColor),
      data: widget.index,
      child: draggableBox(context, convertedColor),
    );
  }

  CustomBoxContainer draggableBox(
      BuildContext context, Color Function() convertedColor) {
    return CustomBoxContainer(
      onTap: showModal(
        context,
        page: BingoModal(
          index: widget.index,
          cnt: widget.size * widget.size,
          isDetail: widget.isDetail,
        ),
      ),
      child: CustomBoxContainer(
        color: getHasBlackBox(context) ? blackColor : whiteColor,
        hasRoundEdge: getHasRoundEdge(context),
        borderColor: getHasBorder(context) == true ? convertedColor() : null,
        child: Stack(
          children: [
            Center(
              child: CustomText(
                color: convertedColor(),
                content: getItemTitle(context, widget.index) ?? '빙고칸 제목',
                font: getStringFont(context),
                center: true,
                maxLines: 2,
                cutText: true,
              ),
            ),
            context.watch<GlobalBingoProvider>().isCheckTheme
                ? Center(
                    child: CustomIcon(
                      icon: getCheckIconData(context),
                      size: 80,
                      color: convertedColor(),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
