import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomInput extends StatelessWidget {
  final String? explain;
  final bool needMore, onlyNum, enabled;
  final double? width, height, vertical, horizontal;
  final bool filled;
  final Color filledColor;
  final FontSize fontSize;
  final int? maxLength;
  final String title;
  final String? initialValue;
  // final String? Function() returnValue;
  final void Function(String) setValue;

  const CustomInput({
    super.key,
    required this.setValue,
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
    this.horizontal = 20.0,
    this.vertical = 10.0,
    this.initialValue,
    // required this.returnValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title != '' ? CustomText(content: title) : const SizedBox(),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: vertical!,
            horizontal: horizontal!,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: TextField(
              controller: TextEditingController(text: initialValue),
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
              onChanged: setValue,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              textInputAction: TextInputAction.next,
              // focusNode: inputFocus,
            ),
          ),
        ),
      ],
    );
  }
}

class InputDate extends StatelessWidget {
  final String explain, title;
  final Function(BuildContext, String) onSubmit;
  const InputDate({
    super.key,
    required this.explain,
    required this.title,
    required this.onSubmit,
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
            width: getWidth(context) * 0.9,
            height: getHeight(context) * 0.8,
            color: whiteColor,
            child: SfDateRangePicker(
              showTodayButton: true,
              view: DateRangePickerView.year,
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              enableMultiView: true,
              confirmText: '적용',
              cancelText: '취소',
              headerHeight: 100,
              minDate: now,
              maxDate: now.add(const Duration(days: 365)),
              enablePastDates: false,
              showActionButtons: true,
              selectionMode: DateRangePickerSelectionMode.range,
              onCancel: () => toBack(context),
              onSubmit: (pickedDate) {
                final start = (pickedDate as PickerDateRange)
                    .startDate
                    ?.toString()
                    .split(' ')[0];
                final end = pickedDate.endDate?.toString().split(' ')[0];
                if (start != null && end != null) {
                  onSubmit(context, 'start')(start);
                  onSubmit(context, 'end')(end);
                  toBack(context);
                }
              },
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
          setValue: (value) {},
        ),
      ),
    ]);
  }
}
