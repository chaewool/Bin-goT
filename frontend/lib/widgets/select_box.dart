import 'package:flutter/material.dart';

// const List<String> period = <String>[
//   '기간을 선택해주세요',
//   '하루 ~ 한 달',
//   '한 달 ~ 세 달',
//   '세 달 ~ 여섯 달',
//   '여섯 달 ~ 아홉 달',
//   '아홉 달 ~ 1년'
// ];
const List<String> sort = <String>['모집 중', '전체'];

const List<String> publicFilter = <String>['공개', '비공개', '전체'];

class SelectBox extends StatefulWidget {
  final List<String> selectList;
  const SelectBox({super.key, required this.selectList});

  @override
  State<SelectBox> createState() => _SelectBox();
}

class _SelectBox extends State<SelectBox> {
  late String dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectList.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      // underline: Container(
      //   height: 2,
      //   color: Colors.deepPurpleAccent,
      // ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.selectList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
