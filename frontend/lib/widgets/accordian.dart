import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class EachAccordion extends StatefulWidget {
  final String question, answer;
  const EachAccordion(
      {super.key, required this.question, required this.answer});

  @override
  State<EachAccordion> createState() => _EachAccordionState();
}

class _EachAccordionState extends State<EachAccordion> {
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
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: CustomText(content: widget.answer),
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
