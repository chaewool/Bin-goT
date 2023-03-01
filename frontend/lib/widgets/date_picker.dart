import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bin_got/utilities/calendar_utils.dart';

// class DatePicker extends StatefulWidget {
//   const DatePicker({super.key});

//   @override
//   State<DatePicker> createState() => _DatePickerState();
// }

// class _DatePickerState extends State<DatePicker> {
//   @override
//   Widget build(BuildContext context) {
//     String _selectedDate = '';
//     Future selectDate(context) async {
//       final DateTimeRange? selected = await showDateRangePicker(
//           context: context,
//           firstDate: DateTime(2023),
//           lastDate: DateTime(2024),
//           currentDate: DateTime.now());
//       if (selected != null) {
//         print(selected);
//         setState(() {
//           _selectedDate = selected.toString();
//         });
//       }
//     }
//     return Dialog(

//     );
//   }
// }

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    String startDay =
        _rangeStart != null ? _rangeStart.toString().split(' ').first : '';
    String endDay =
        _rangeEnd != null ? _rangeEnd.toString().split(' ').first : '';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            headerStyle: const HeaderStyle(
                titleCentered: true, formatButtonVisible: false),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null; // Important to clean those
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
          ),
          Text('시작일 : $startDay', style: const TextStyle(fontSize: 20)),
          Text('종료일 : $endDay', style: const TextStyle(fontSize: 20)),
          Row(
            children: [
              CustomButton(onPressed: () {}, content: '한 달'),
              CustomButton(onPressed: () {}, content: '100일'),
              CustomButton(onPressed: () {}, content: '6개월'),
              CustomButton(onPressed: () {}, content: '1년'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                  onPressed: () => toBack(context: context), content: '취소'),
              CustomButton(
                  onPressed: () => toBack(context: context), content: '완료')
            ],
          )
        ],
      ),
    );
  }
}
