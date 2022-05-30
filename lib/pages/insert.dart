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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Today",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600
            ),
            ),
            Text(date,
             style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200
            ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //
                  }
                , child: const Text("물")
                ),
                ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                  }
                , child: const Text("커피")
                ),
                ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                  }
                , child: const Text("탄산음료")
                ),
                ElevatedButton(
                  onPressed: () {
                  //Navigator.of(context).pop();
                  }
                , child: const Text("차")
                ),
                ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                  }
                , child: const Text("주스")
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    //
                  }
                , child: const Text("100")
                ),
                TextButton(
                  onPressed: () {
                    //
                  }
                , child: const Text("200")
                ),
                TextButton(
                  onPressed: () {
                    //
                  }
                , child: const Text("300")
                ),
              ],
            ),
            Row(
              children: [
                TextButton(onPressed: () {
                  // showdialog로 용량 바꾸기 
                  //volumDialog();
                }, child: Text("컵 바꾸기"),
                style : TextButton.styleFrom(
                  primary: Colors.black87
                ),
                ),
              ],
            )
            // TextField(
            //   controller: volume,
            //   decoration: const InputDecoration(labelText: '물의 용량을 입력하세요.'),
            //   keyboardType: TextInputType.number,
            // ),
            ,ElevatedButton(
                onPressed: () {
                  insertWater();
                },
                child: const Text('더하기'))
          ],
        ),
      ),
    );
  }
  //function
  insertWater() async {
    //현재 물로 세팅됨 
    //String water_kind = '물';
    //test
     String water_kind = '커피';
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
