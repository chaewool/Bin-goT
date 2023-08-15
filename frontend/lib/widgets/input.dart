import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String title;
  final String? initialValue;
  // final String? Function() returnValue;
  final void Function(String) setValue;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;

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
    this.horizontal = 0,
    this.vertical = 0,
    this.initialValue,
    this.needSearch = false,
    this.onSubmitted,
    this.suffixIcon,
    this.explainTitle,
    // required this.returnValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical!,
        horizontal: horizontal!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != ''
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CustomText(content: title),
                      Row(
                        children: [
                          if (explainTitle != null)
                            for (int i = 0; i < explainTitle!.length; i += 1)
                              CustomText(
                                content: explainTitle![i],
                                fontSize: FontSize.smallSize,
                                color: greyColor,
                              ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          SizedBox(
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
                  borderSide: BorderSide(color: paleOrangeColor),
                ),
                suffixIcon: suffixIcon,
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
              onSubmitted: onSubmitted,
              textInputAction:
                  needSearch ? TextInputAction.search : TextInputAction.next,
              // focusNode: inputFocus,
            ),
          ),
        ],
      ),
    );
  }
}

//* date input
class InputDate extends StatefulWidget {
  final String explain, title;
  final String? start, end;
  // final Function(BuildContext, String) onSubmit;
  final Function(List<DateTime?>) applyDay;
  const InputDate({
    super.key,
    required this.explain,
    required this.title,
    required this.start,
    required this.end,
    // required this.onSubmit,
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

  // String _getValueText(
  //   CalendarDatePicker2Type datePickerType,
  //   List<DateTime?> values,
  // ) {
  //   values =
  //       values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();

  //   if (values.isNotEmpty) {
  //     final startDate = values[0].toString().replaceAll('00:00:00.000', '');
  //     final endDate = values.length > 1
  //         ? values[1].toString().replaceAll('00:00:00.000', '')
  //         : 'null';
  //     return '$startDate to $endDate';
  //   } else {
  //     return 'null';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const dayTextStyle =
        TextStyle(color: blackColor, fontWeight: FontWeight.w500);
    const weekendTextStyle =
        TextStyle(color: redColor, fontWeight: FontWeight.w500);
    const anniversaryTextStyle = TextStyle(
      color: redColor,
      fontWeight: FontWeight.w700,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: paleOrangeColor,
      selectedRangeHighlightColor: beigeColor,
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
        // if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
        //   textStyle = anniversaryTextStyle;
        // }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            isSelected == true ? whiteColor : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
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
    return Column(children: [
      CustomText(content: widget.title),
      GestureDetector(
        onTap: () async {
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
            // print(_getValueText(
            //   config.calendarType,
            //   values,
            // ));
            setState(() {
              calendarPickerValue = values;
            });
          }
        },
        child: CustomInput(
          explain: widget.explain,
          enabled: false,
          setValue: (value) {},
        ),
      ),
    ]);
  }
}
