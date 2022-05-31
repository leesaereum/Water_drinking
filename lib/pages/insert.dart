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
  //용량 텍스트필드로 받기
  final TextEditingController volumeController = TextEditingController();
  var date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  //late String water_kind ="";
  //late String water_volume="";

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
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Today",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              date,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
            ),
            const SizedBox(
              height: 100,
            ),
            SingleChildScrollView(
              //스크롤
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //물 버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Static.water_kind = "물";
                      });
                    },
                    label: const Text("물"),
                    icon: const Icon(Icons.water_drop_outlined),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.teal.withOpacity(0.5);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.teal.withOpacity(0.5);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //커피버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Static.water_kind = "커피";
                      });
                    },
                    label: const Text("커피"),
                    icon: const Icon(Icons.coffee),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.teal.withOpacity(0.5);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.teal.withOpacity(0.5);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //탄산버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Static.water_kind = "탄산";
                      });
                    },
                    label: const Text("탄산"),
                    icon: const Icon(Icons.local_drink_rounded),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.teal.withOpacity(0.5);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.teal.withOpacity(0.5);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //차 버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Static.water_kind = "차";
                      });
                    },
                    label: const Text("차"),
                    icon: const Icon(Icons.emoji_food_beverage),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.teal.withOpacity(0.5);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.teal.withOpacity(0.5);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //주스 버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Static.water_kind = "주스";
                      });
                    },
                    label: const Text("주스"),
                    icon: const Icon(Icons.wine_bar),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.teal.withOpacity(0.5);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.teal.withOpacity(0.5);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // showdialog로 용량 바꾸기
                    volumeDialog(context);
                  },
                  label: Text("컵 바꾸기"),
                  icon: const Icon(Icons.settings),
                  style: TextButton.styleFrom(primary: Colors.black87),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        Static.water_volume = "100";
                      });
                    },
                    child: const Text(
                      "100ml",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    )),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Static.water_volume = "200";
                    });
                  },
                  child: const Text(
                    "200ml",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        Static.water_volume = "300";
                      });
                    },
                    child: const Text(
                      "300ml",
                      style: TextStyle(fontSize: 22),
                    )),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      //
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.teal[50],
                      minimumSize: const Size(80, 40),
                      side: const BorderSide(
                        color: Colors.teal,
                        width: 1.5,
                      ),
                    ),
                    child: Text("${Static.water_kind}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      //
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.teal[50],
                      minimumSize: const Size(80, 40),
                      side: const BorderSide(
                        color: Colors.teal,
                        width: 1.5,
                      ),
                    ),
                    child: Text("${Static.water_volume}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                    ))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                insertWater();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                minimumSize: Size(100, 50),
                //textStyle:Colors.black87,
              ),
              child: const Text('더 하 기',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600
              ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //function
  insertWater() async {
    //용량 버튼으로 입력받기
    String water_volume = '${Static.water_volume}';
    //종류 버튼으로 입력받기
    String water_kind = '${Static.water_kind}';
    //텍스트 필드로 받은값 static에 전달

    var url = Uri.parse(
        'http://localhost:8080/Flutter/water_drinking/insert.jsp?id=${Static.id}&date=${Static.date}&volume=${water_volume}&kind=$water_kind');
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

  //컵 바꾸기 dialog
  volumeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("컵 바꾸기"),
            content: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: volumeController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "용량을 입력하세요",
                    //힌트
                    hintText: "ex ) 350",
                  ),
                  //숫자만 입력받기
                  keyboardType: TextInputType.number,
                  //최대 한줄
                  maxLines: 1,
                ))
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  //static에 넣기
                  setState(() {
                    Static.water_volume = volumeController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }
}

//end
