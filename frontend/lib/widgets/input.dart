import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomInput extends StatefulWidget {
  final String? explain, initialValue;
  final bool needMore, onlyNum, enabled;
  final double? width, height;
  final bool filled;
  final Color filledColor;
  final FontSize fontSize;
  final int? maxLength;
  final String title;
  final void Function(dynamic) setValue;

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
    required this.setValue,
    this.initialValue,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  FocusNode inputFocus = FocusNode();
  StringMap inputValue = {'value': ''};
  @override
  void initState() {
    super.initState();
    focusListener();
    print('initialValue : ${widget.initialValue}');
    inputValue['value'] = widget.initialValue ?? '';
  }

  void focusListener() {
    inputFocus.addListener(() {
      if (!inputFocus.hasFocus) {
        widget.setValue(inputValue['value']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(content: widget.title),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: TextField(
              controller: TextEditingController(text: inputValue['value']),
              decoration: InputDecoration(
                filled: widget.filled,
                fillColor: widget.filledColor,
                border: const OutlineInputBorder(),
                hintText: widget.explain,
              ),
              maxLength: widget.maxLength,
              style: TextStyle(fontSize: convertedFontSize(widget.fontSize)),
              maxLines: widget.needMore ? 7 : 1,
              keyboardType: widget.onlyNum ? TextInputType.number : null,
              inputFormatters: widget.onlyNum
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              enabled: widget.enabled,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                inputValue['value'] = value;
              },
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              textInputAction: TextInputAction.next,
              focusNode: inputFocus,
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
            color: whiteColor,
            child: SfDateRangePicker(
              minDate: now,
              maxDate: now.add(const Duration(days: 365)),
              enablePastDates: false,
              showActionButtons: true,
              selectionMode: DateRangePickerSelectionMode.range,
              onCancel: toBack(context),
              onSubmit: (pickedDate) {
                final start = (pickedDate as PickerDateRange)
                    .startDate
                    ?.toString()
                    .split(' ')[0];
                final end = pickedDate.endDate?.toString().split(' ')[0];
                if (start != null && end != null) {
                  onSubmit(context, 'start')(start);
                  onSubmit(context, 'end')(end);
                  toBack(context)();
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
