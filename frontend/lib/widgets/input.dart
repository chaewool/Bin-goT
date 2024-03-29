import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//? 입력창

//* input
class CustomInput extends StatelessWidget {
  final String? explain;
  final StringList? explainTitle;
  final bool needMore, onlyNum, enabled, needSearch;
  final double? width, height, vertical, horizontal;
  final bool filled;
  final Color filledColor;
  final FontSize fontSize;
  final int? maxLength;
  final String? initialValue;
  final void Function(String) setValue;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;
  final double? contentHorizontalPadding;

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
    this.horizontal = 0,
    this.vertical = 0,
    this.initialValue,
    this.needSearch = false,
    this.onSubmitted,
    this.suffixIcon,
    this.explainTitle,
    this.contentHorizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical!,
        horizontal: horizontal!,
      ),
      child: CustomBoxContainer(
        borderRadius: BorderRadius.circular(4),
        width: width,
        height: height,
        child: TextField(
          controller: TextEditingController(text: initialValue),
          decoration: InputDecoration(
            filled: filled,
            fillColor: filledColor,
            border: const OutlineInputBorder(),
            hintText: explain,
            focusColor: whiteColor,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: palePinkColor),
            ),
            suffixIcon: suffixIcon,
            contentPadding:
                needMore ? null : const EdgeInsets.symmetric(horizontal: 10),
          ),
          maxLength: maxLength,
          style: TextStyle(fontSize: convertedFontSize(fontSize), height: 1.2),
          maxLines: needMore ? 7 : 1,
          keyboardType: onlyNum ? TextInputType.number : null,
          inputFormatters:
              onlyNum ? [FilteringTextInputFormatter.digitsOnly] : null,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          onChanged: setValue,
          onSubmitted: onSubmitted,
          textInputAction: needSearch ? TextInputAction.search : null,
          enabled: enabled,
        ),
      ),
    );
  }
}

//* date input
class InputDate extends StatefulWidget {
  final String explain;
  final String? start, end;
  final Function(List<DateTime?>) applyDay;
  const InputDate({
    super.key,
    required this.explain,
    required this.start,
    required this.end,
    required this.applyDay,
  });

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  final now = DateTime.now();
  DateTime? endDate, startDate;
  late List<DateTime?> calendarPickerValue;

  @override
  void initState() {
    super.initState();
    calendarPickerValue = [
      widget.start != '' ? DateTime.parse(widget.start!) : null,
      widget.end != '' ? DateTime.parse(widget.end!) : null,
    ];
  }

  @override
  Widget build(BuildContext context) {
    const dayTextStyle =
        TextStyle(color: darkGreyColor, fontWeight: FontWeight.w500);

    const weekendTextStyle =
        TextStyle(color: paleRedColor, fontWeight: FontWeight.w500);

    final config = CalendarDatePicker2WithActionButtonsConfig(
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: palePinkColor,
      selectedRangeHighlightColor: palePinkColor.withOpacity(0.5),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 0,
      weekdayLabelTextStyle: const TextStyle(
        color: blackColor,
        fontWeight: FontWeight.w600,
      ),
      controlsTextStyle: const TextStyle(
        color: blackColor,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: whiteColor),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }

        return textStyle;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        if (isDisabled == false) {
          return Center(
            child: Container(
              decoration: decoration,
              height: 36,
              width: 72,
              child: Center(
                child: Semantics(
                  selected: isSelected,
                  button: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        year.toString(),
                        style: textStyle,
                      ),
                      if (isCurrentYear == true)
                        Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return null;
      },
    );
    return GestureDetector(
      onTap: () async {
        unfocus();
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: calendarPickerValue,
          dialogBackgroundColor: whiteColor,
        );
        if (values != null) {
          widget.applyDay(values);

          setState(() {
            calendarPickerValue = values;
          });
        }
      },
      child: CustomBoxContainer(
        width: 300,
        height: 45,
        borderColor: Colors.grey,
        borderRadius: BorderRadius.circular(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CustomText(
                content: widget.explain,
                color: greyColor,
                fontSize: FontSize.smallSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
