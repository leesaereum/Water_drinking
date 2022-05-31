import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_drinking_app/pages/update_page.dart';
import 'package:water_drinking_app/static.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  late List list;
  late String waterId;
  late String result;

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
                          color: Colors.amberAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                          Text("${list[index]['volume']}ml"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePage(
                                          cardId: list[index]['waterId'],
                                          cardKind: list[index]['kind'],
                                          cardVolume: list[index]['volume'],
                                        ),
                                      ),
                                    ).then((value) => rebuild());
                                  },
                                  icon: const Icon(Icons.mode),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      waterId = list[index]['waterId'];
                                      showAlert(context);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
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

  deleteAction(BuildContext context) async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/water_drinking/deletewater.jsp?water_id=$waterId');
    var response = await http.get(url);
    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];

      if (result == "OK") {
        deletesuccessSnackbar(context);
        rebuild();
      } else {
        deleteerrorSnackbar(context);
      }
    });
  }

  deletesuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("삭제가 완료되었습니다."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  deleteerrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("사용자 정보 삭제에 문제가 발생 하였습니다."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("삭제하기"),
            content: const Text("기록을 삭제할까요?"),
            actions: [
              TextButton(
                onPressed: () {
                  deleteAction(context);
                  Navigator.of(ctx).pop();
                },
                child: const Text("네"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("아니요")),
            ],
          );
        });
  }
}//End 
