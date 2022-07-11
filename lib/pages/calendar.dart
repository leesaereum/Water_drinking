import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:water_drinking_app/pages/today.dart';
import 'package:water_drinking_app/static.dart';
import 'package:http/http.dart' as http;

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List data = [];
  int i = 0;

  @override
  void initState() {
    super.initState();
    if (Static.id != '') {
      readcalendar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 450,
              width: 400,
              child: TableCalendar(
                // locale: 'ko-KR',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
                headerStyle: const HeaderStyle(
                  headerMargin:
                      EdgeInsets.only(left: 40, top: 10, right: 40, bottom: 10),
                  titleCentered: true,
                  //-- 2weeks / week format
                  //formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.arrow_left),
                  rightChevronIcon: Icon(Icons.arrow_right),
                  titleTextStyle: TextStyle(fontSize: 20.0),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  weekendTextStyle:
                      const TextStyle().copyWith(color: Colors.red),
                ),
                eventLoader: (day) {
                  if (data.isEmpty) {
                    return [];
                  } else {
                    if (day.toString().substring(0, 10) == data[i]['date']) {
                      if (i < data.length - 1) {
                        print(data);
                        i++;
                        return ['hi'];
                      }
                      i = 0;
                      return ['hi'];
                    }

                    return [];
                  }
                  // if(day.day%2==0){
                  //   return ['hi'];
                  // }
                  // return[];
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_selectedDay != null) {
                    Static.date = (_selectedDay.toString()).substring(0, 10);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Today(),
                        )).then((value) => resetDate());
                  } else {
                    dateUnselect();
                  }
                },
                child: const Text('물주기 확인하기')),
          ],
        ),
      ),
    );
  }

  readcalendar() async {
    var url = Uri.parse(
        "http://localhost:8080/Flutter/water_drinking/readcalendar.jsp?water_user=${Static.id}");
    var response = await http.get(url);

    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      List result = JSON['result'];
      print(result);
      for (int i = 0; i < result.length; i++) {
        if (Static.goal != null) {
          if (double.parse(result[i]['sum']) >= Static.goal) {
            data.add(result[i]);
            print(data);
          }
        } else {
          if (double.parse(result[i]['sum']) >= 2000) {
            data.add(result[i]);
          }
        }
      }
    });
  }

  resetDate() async {
    var date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    Static.date = date;
  }

  dateUnselect() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('날짜를 선택해 주세요'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('확인'))
            ],
          );
        });
  }
} // End