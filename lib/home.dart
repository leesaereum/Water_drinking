import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:water_drinking_app/pages/insert.dart';
import 'package:water_drinking_app/pages/login_page.dart';
import 'package:water_drinking_app/static.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    readWater();
  }

  String nickname = Static.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          width: 100,
        ),
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (Static.id.isEmpty) {
                  notlogin();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Insert(),
                      )).then((value) => readWater());
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black87,
              ))
        ],
        elevation: 0,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 5, 0),
            child: LinearPercentIndicator(
              width: 290.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 40.0,
              leading: const Text('0ml'),
              trailing: const Text('2000ml'),
              percent: (Static.water.toDouble() / Static.goal.toDouble()) > 1
                  ? 1
                  : Static.water.toDouble() / Static.goal.toDouble(),
              center: Static.id.isEmpty
                  ? const Text('0%')
                  : Text(
                      '${(Static.water / Static.goal * 100).roundToDouble()}%'),
              progressColor:
                  (Static.water / Static.goal * 100).roundToDouble() > 50
                      ? Colors.lightBlue
                      : Colors.redAccent,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Image.asset(Static.image),
        ],
      )),
    );
  }

  readWater() async {
    var date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    Static.date = date;
    var url = Uri.parse(
        "http://localhost:8080/Flutter/water_drinking/readwater.jsp?water_user=${Static.id}&water_date=$date");
    var response = await http.get(url);
    int sum = 0;
    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      List result = JSON['result'];
      //????????? ?????? ?????? ?????? ????????????
      for (int i = 0; i < result.length; i++) {
        if (result[i]['kind'] == '???') sum += int.parse(result[i]['volume']);
      }

      Static.water = sum;
      if (Static.water < Static.goal * 0.25) {
        Static.image = 'images/1.jpg';
      } else if (Static.water < Static.goal * 0.5) {
        Static.image = 'images/2.jpg';
      } else if (Static.water < Static.goal * 0.75) {
        Static.image = 'images/3.jpg';
      } else if (Static.water < Static.goal) {
        Static.image = 'images/4.jpg';
      } else {
        Static.image = 'images/5.jpg';
      }
    });
  }

  notlogin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('????????? ??????'),
            content: const Text('????????? ??? ?????? ?????????????????????.'),
            actions: [
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: const Text('????????? ????????????')))
            ],
          );
        });
  }
}
