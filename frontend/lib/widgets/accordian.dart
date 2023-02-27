import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class EachAccordian extends StatefulWidget {
  final String question, answer;
  const EachAccordian(
      {super.key, required this.question, required this.answer});

  @override
  State<EachAccordian> createState() => _EachAccordianState();
}

class _EachAccordianState extends State<EachAccordian> {
  bool accordianState = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionPanelList(
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (context, isExpended) => Center(
              child: CustomText(
                content: widget.question,
                fontSize: FontSize.textSize,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: CustomText(
                  content: widget.answer,
                  fontSize: FontSize.textSize,
                ),
              ),
            ),
            isExpanded: accordianState,
          )
        ],
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            accordianState = !accordianState;
          });
        },
      ),
    );
  }
}
