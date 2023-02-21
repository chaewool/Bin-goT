import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class ShowContentBox extends StatelessWidget {
  final String contentTitle, content;
  const ShowContentBox(
      {super.key, required this.contentTitle, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(content: contentTitle, fontSize: FontSize.textSize),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greyColor)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomText(content: content, fontSize: FontSize.textSize),
            ),
          )
        ],
      ),
    );
  }
}
