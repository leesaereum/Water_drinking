import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_drinking_app/static.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  late List list;

  @override
  void initState() {
    super.initState();
    list = [];
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 물주기'),
      ),
      body: Center(
        child: list.isEmpty
            ? const Text('오늘의 물주기 기록이 없습니다.')
            : GestureDetector(
                onTap: () {
                  Text('테스트');
                },
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.fromLTRB(25, 30, 25, 0)
                            : const EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: Card(
                          color: list[index]['kind'] == "물"
                          ? Colors.blueAccent
                          : Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('음료 종류 : '),
                                    Text(list[index]['kind'])
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('음료 용량 : '),
                                    Text(list[index]['volume'])
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      ),
    );
  }

  getdata() async {
    var url = Uri.parse(
        "http://localhost:8080/Flutter/water_drinking/readwater.jsp?water_user=${Static.id}&water_date=${Static.date}");

    var response = await http.get(url);
    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      if (JSON['result'] != null) {
        List result = JSON['result'];
        list.addAll(result);
      } else
        list = [];
    });
  }

  rebuild() {
    setState(() {
      list = [];
      getdata();
    });
  }
}
