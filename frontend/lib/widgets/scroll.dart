import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class InfiniteScroll extends StatelessWidget {
  final List data;
  final MyGroupModel? myGroupModel;
  final bool isSearchMode, hasNotGroup;
  const InfiniteScroll({
    super.key,
    required this.data,
    required this.isSearchMode,
    required this.myGroupModel,
    this.hasNotGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      child: !getLoading(context)
          ? data.isNotEmpty && !hasNotGroup
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final returnedWidget = GroupListItem(
                        isSearchMode: isSearchMode, groupInfo: myGroupModel!);
                    return Column(
                      children: [
                        i < getPage(context) * 10
                            // || !getAdditional(context)
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: returnedWidget,
                              )
                            : const SizedBox(),
                        i == data.length - 1 &&
                                getTotal(context)! > getPage(context)
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox()
                      ],
                    );
                  },
                )
              : Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CustomText(
                          height: 1.7,
                          center: true,
                          content: '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
                          color: whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    CustomText(
                      content: '추천그룹',
                      fontSize: FontSize.titleSize,
                    ),
                  ],
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// class CustomSilverList extends StatelessWidget {
//   final bool showReview, isMain, isSearch;
//   final int? toiletId, folderId;
//   final String? toiletName;
//   final List data;
//   final ReturnVoid refreshPage;
//   const CustomSilverList({
//     super.key,
//     required this.showReview,
//     required this.isMain,
//     required this.isSearch,
//     this.toiletId,
//     this.folderId,
//     this.toiletName,
//     required this.data,
//     required this.refreshPage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     int cnt = showReview || (!isMain && !isSearch) ? 10 : 20;
//     String ifEmpty() {
//       String showedContent = '';
//       if (isSearch) {
//         showedContent = '조건에 맞는 화장실이';
//       } else if (showReview) {
//         showedContent = '이 화장실에 대한 리뷰가';
//       } else if (isMain) {
//         showedContent = '주변에 화장실이';
//       } else {
//         showedContent = '즐겨찾기한 화장실이';
//       }
//       return '$showedContent 없습니다.';
//     }

//     return CustomBox(
//       color: mainColor,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: !getLoading(context)
//             ? data.isNotEmpty
//                 ? CustomListView(
//                     itemCount: data.length,
//                     itemBuilder: (context, i) {
//                       final returnedWidget = showReview
//                           ? ReviewBox(
//                               review: data[i],
//                               toiletId: toiletId!,
//                               toiletName: toiletName!,
//                               refreshPage: refreshPage,
//                             )
//                           : ListItem(
//                               showReview: false,
//                               toiletModel: data[i],
//                               isMain: isMain,
//                               refreshPage: refreshPage,
//                               index: i,
//                             );

//                       return Column(
//                         children: [
//                           i < getPage(context) * cnt
//                               // || !getAdditional(context)
//                               ? Padding(
//                                   padding: const EdgeInsets.only(bottom: 20),
//                                   child: returnedWidget,
//                                 )
//                               : const SizedBox(),
//                           i == data.length - 1 &&
//                                   getTotal(context)! > getPage(context)
//                               ? const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 40,
//                                   ),
//                                   child: Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 )
//                               : const SizedBox()
//                         ],
//                       );
//                     },
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.only(top: 40),
//                     child: Center(
//                       child: CustomText(
//                         title: ifEmpty(),
//                         color: CustomColors.whiteColor,
//                       ),
//                     ),
//                   )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }

// class CustomBoxWithScrollView extends StatefulWidget {
//   final ScrollController? appBarScroll, listScroll;
//   final Widget flexibleSpace;
//   final double toolbarHeight;
//   // expandedHeight;
//   final Color backgroundColor;
//   final WidgetList? silverChild;
//   // final ReturnVoid addScrollListner;
//   // final SliverChildDelegate? sliverChildDelegate;
//   // final ScrollPhysics physics;

//   const CustomBoxWithScrollView({
//     super.key,
//     this.appBarScroll,
//     this.listScroll,
//     required this.flexibleSpace,
//     this.toolbarHeight = 200,
//     // this.expandedHeight = 100,
//     this.backgroundColor = mainColor,
//     this.silverChild,
//     // required this.addScrollListner,
//     // this.sliverChildDelegate,
//     // this.physics = const AlwaysScrollableScrollPhysics(),
//   });

//   @override
//   State<CustomBoxWithScrollView> createState() =>
//       _CustomBoxWithScrollViewState();
// }

// class _CustomBoxWithScrollViewState extends State<CustomBoxWithScrollView> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBox(
//       radius: 0,
//       color: mainColor,
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//       child: Column(
//         children: [
//           SizedBox(
//             height: widget.toolbarHeight,
//             child: CustomScrollView(
//               controller: widget.appBarScroll,
//               slivers: [
//                 CustomSilverAppBar(
//                   elevation: 0,
//                   toolbarHeight: widget.toolbarHeight,
//                   // expandedHeight: widget.expandedHeight,
//                   flexibleSpace: widget.flexibleSpace,
//                   backgroundColor: widget.backgroundColor,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: CustomScrollView(
//               controller: widget.listScroll,
//               slivers: [
//                 SliverList(
//                   delegate: SliverChildListDelegate(widget.silverChild!),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }