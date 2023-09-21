// import 'package:bin_got/pages/main_page.dart';
// import 'package:bin_got/providers/group_provider.dart';
// import 'package:bin_got/utilities/global_func.dart';
// import 'package:bin_got/utilities/type_def_utils.dart';
// import 'package:bin_got/widgets/app_bar.dart';
// import 'package:bin_got/widgets/button.dart';
// import 'package:bin_got/widgets/scroll.dart';
// import 'package:bin_got/widgets/text.dart';
// import 'package:flutter/material.dart';

// class SearchGroup extends StatefulWidget {
//   final int public, order, period;
//   final String? query;
//   const SearchGroup({
//     super.key,
//     required this.public,
//     required this.order,
//     required this.period,
//     required this.query,
//   });

//   @override
//   State<SearchGroup> createState() => _SearchGroupState();
// }

// class _SearchGroupState extends State<SearchGroup> {
//   MyGroupList groups = [];
//   final controller = ScrollController();
//   bool showSearchBar = true;

//   @override
//   void initState() {
//     super.initState();
//     print('''
//     keyword: ${widget.query},
//       public: ${widget.public},
//       order: ${widget.order},
//       period: ${widget.period},
// ''');

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       initLoadingData(context, 0);
//       if (getLoading(context)) {
//         search(false);
//       }
//       // getOffset();
//       controller.addListener(() {
//         if (controller.position.pixels >=
//             controller.position.maxScrollExtent * 0.9) {
//           // print('${getPage(context, 0)}, ${getTotal(context, 0)}');
//           if (getLastId(context, 0) != -1) {
//             // if (getPage(context, 1) < getTotal(context, 1)!) {
//             if (!getWorking(context)) {
//               setWorking(context, true);
//               Future.delayed(const Duration(seconds: 2), () {
//                 if (!getAdditional(context)) {
//                   setAdditional(context, true);
//                   if (getAdditional(context)) {
//                     search();
//                   }
//                 }
//               });
//             }
//           }
//         }
//       });
//     });
//   }

//   void search([bool more = true]) {
//     GroupProvider()
//         .searchGroupList(
//       keyword: widget.query,
//       public: widget.public,
//       lastId: getLastId(context, 0),
//       // page: widget.page,
//       order: widget.order,
//       period: widget.period,
//     )
//         .then((newGroups) {
//       // if (newGroups is MyGroupList) {
//       groups.addAll(newGroups);
//       setLoading(context, false);
//       if (more) {
//         setWorking(context, false);
//         setAdditional(context, false);
//       }
//       // }
//     });
//     // increasePage(context, 0);
//   }

//   void changeShowSearchBar() {
//     setState(() {
//       showSearchBar = !showSearchBar;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         toOtherPage(context, page: const Main())();
//         return Future.value(false);
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBarWithBack(
//           onPressedClose: changeShowSearchBar,
//           otherIcon: showSearchBar
//               ? Icons.keyboard_arrow_up_outlined
//               : Icons.keyboard_arrow_down_outlined,
//         ),
//         body: Stack(
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 if (showSearchBar)
//                   // CustomSearchBar(
//                   //   public: widget.public,
//                   //   period: widget.period,
//                   //   query: widget.query,
//                   // ),
//                   Expanded(
//                     child: GroupInfiniteScroll(
//                       controller: controller,
//                       data: groups,
//                       mode: 0,
//                       emptyWidget: const Padding(
//                         padding: EdgeInsets.only(top: 40),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             CustomText(
//                               center: true,
//                               content:
//                                   '조건에 맞는 그룹이 없어요.\n다른 그룹을 검색하거나\n그룹을 생성해보세요.',
//                               height: 1.5,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const CreateGroupButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }
