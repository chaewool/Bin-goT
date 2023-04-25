import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomInput extends StatelessWidget {
  final String? explain;
  final bool needMore, onlyNum, enabled;
  final double? width, height;
  final bool filled;
  final Color filledColor;
  final FontSize fontSize;
  final int? maxLength;
  final String title;

  const CustomInput({
    super.key,
    this.explain,
    this.needMore = false,
    this.onlyNum = false,
    this.enabled = true,
    this.width,
    this.height,
    this.filled = false,
    this.filledColor = whiteColor,
    this.fontSize = FontSize.smallSize,
    this.maxLength,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(content: title),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SizedBox(
            width: width,
            height: height,
            child: TextField(
              decoration: InputDecoration(
                filled: filled,
                fillColor: filledColor,
                border: const OutlineInputBorder(),
                hintText: explain,
              ),
              maxLength: maxLength,
              style: TextStyle(fontSize: convertedFontSize(fontSize)),
              maxLines: needMore ? 7 : 1,
              keyboardType: onlyNum ? TextInputType.number : null,
              inputFormatters:
                  onlyNum ? [FilteringTextInputFormatter.digitsOnly] : null,
              enabled: enabled,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ),
      ],
    );
  }
}

class InputDate extends StatelessWidget {
  final String explain, title;
  const InputDate({
    super.key,
    required this.explain,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(children: [
      CustomText(content: title),
      GestureDetector(
        onTap: showModal(
          context,
          page: CustomBoxContainer(
            color: whiteColor,
            child: SfDateRangePicker(
              minDate: now,
              maxDate: now.add(const Duration(days: 365)),
            ),
          ),
        ),
        // () {

        //   Future<DateTimeRange?> selectedDate = showDateRangePicker(
        //     context: context,
        //     firstDate: now, // 시작일
        //     lastDate: now.add(const Duration(days: 365)), // 마지막일
        //     builder: (BuildContext context, Widget? child) {
        //       return Theme(
        //         data: ThemeData.light(), // 다크테마
        //         child: child!,
        //       );
        //     },
        //   );

        //   selectedDate.then((dateTimeRange) {
        //     print(dateTimeRange);
        //   });
        // },

        // () async => await showDateRangePicker(
        //     context: context,
        //     firstDate: now,
        //     lastDate: now.add(const Duration(days: 365)),
        //     initialEntryMode: DatePickerEntryMode.calendarOnly),

        // showModal(context, page: const DateModal()),
        child: CustomInput(
          explain: explain,
          enabled: false,
        ),
      ),
    ]);
  }
}
