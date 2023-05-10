import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class SelectBox extends StatelessWidget {
  final double width, height;
  final ReturnVoid onTap;
  final String value;

  const SelectBox({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      onTap: onTap,
      width: width,
      height: height,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              content: value,
              fontSize: FontSize.smallSize,
            ),
            const CustomIcon(icon: downIcon)
          ],
        ),
      ),
    );
  }
}

class SelectBoxContainer extends StatefulWidget {
  final List listItems, valueItems;
  final int index;
  final String mapKey;
  final ReturnVoid changeShowState;
  final void Function(String, int) changeIdx;
  const SelectBoxContainer({
    super.key,
    required this.listItems,
    required this.valueItems,
    required this.index,
    required this.mapKey,
    required this.changeShowState,
    required this.changeIdx,
  });

  @override
  State<SelectBoxContainer> createState() => _SelectBoxContainerState();
}

class _SelectBoxContainerState extends State<SelectBoxContainer> {
  late final int length;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    length = widget.listItems.length;
    selectedIndex = widget.index;
  }

  void changeSelected({
    required int newIdx,
  }) {
    setState(() {
      selectedIndex = newIdx;
      widget.changeIdx(widget.mapKey, newIdx);
      widget.changeShowState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomBoxContainer(
            hasRoundEdge: false,
            width: 150,
            color: whiteColor,
            boxShadow: const [defaultShadow],
            child: Column(
              children: [
                for (int i = 0; i < length; i += 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomBoxContainer(
                      onTap: () => changeSelected(
                        newIdx: i,
                      ),
                      width: 150,
                      child: Center(
                        child: CustomText(
                          content: widget.listItems[i],
                          fontSize: FontSize.smallSize,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
