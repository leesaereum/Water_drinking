import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:water_drinking_app/static.dart';
import 'package:http/http.dart' as http;

class Insert extends StatefulWidget {
  const Insert({Key? key}) : super(key: key);

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final TextEditingController volume = TextEditingController();
  var date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('물 주기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date),
            TextField(
              controller: volume,
              decoration: const InputDecoration(labelText: '물의 용량을 입력하세요.'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
                onPressed: () {
                  insertWater();
                },
                child: const Text('물주기'))
          ],
        ),
      ),
    );
  }

  insertWater() async {
    String water_kind = '물';
    var url = Uri.parse(
        'http://localhost:8080/Flutter/water_drinking/insert.jsp?id=${Static.id}&date=${Static.date}&volume=${volume.text}&kind=$water_kind');
    var response = await http.get(url);

    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      var result = JSON['result'];
      if (result == 'OK') {
        Navigator.of(context).pop();
      } else {
        failJoin();
      }
    });
  }

  failJoin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('물 주기 작업에 실패하였습니다. \n다시 시도하여주세요.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
