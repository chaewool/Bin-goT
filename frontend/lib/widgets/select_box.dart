import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

// const List<String> period = <String>[
//   '기간을 선택해주세요',
//   '하루 ~ 한 달',
//   '한 달 ~ 세 달',
//   '세 달 ~ 여섯 달',
//   '여섯 달 ~ 아홉 달',
//   '아홉 달 ~ 1년'
// ];
const StringList sort = <String>['모집 중', '전체'];

const StringList publicFilter = <String>['공개', '비공개', '전체'];

class SelectBox extends StatefulWidget {
  final StringList selectList;
  final double width, height;
  const SelectBox(
      {super.key,
      required this.selectList,
      required this.width,
      required this.height});

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
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? value) {
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
      ),
    );
  }
}
