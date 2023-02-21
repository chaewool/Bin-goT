import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final bool isSearchMode;
  const GroupList({super.key, required this.isSearchMode});

  @override
  Widget build(BuildContext context) {
    const String count = '(5/10)';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupMain()),
          );
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 3))
                ]),
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CustomText(
                          content: '미라클 모닝', fontSize: FontSize.textSize),
                      CustomText(content: 'D-day', fontSize: FontSize.textSize),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      CustomText(content: count, fontSize: FontSize.textSize),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class RankList extends StatelessWidget {
  int rank, achievement;
  String nickname;
  RankList(
      {super.key,
      required this.rank,
      required this.nickname,
      required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: greyColor,
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(3, 3))
            ],
            color: whiteColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(100),
                    shape: BoxShape.circle,
                    border: Border.all(color: greyColor)),
                child:
                    CustomText(content: '$rank', fontSize: FontSize.largeSize),
              ),
              const SizedBox(
                width: 30,
              ),
              CustomText(
                  content: '$nickname / $achievement%',
                  fontSize: FontSize.textSize),
            ],
          ),
        ),
      ),
    );
  }
}
