import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_drinking_app/main.dart';
import 'package:water_drinking_app/pages/login_page.dart';
import 'package:water_drinking_app/static.dart';
import 'package:http/http.dart' as http;

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  late TextEditingController idController;
  late TextEditingController nickController;
  late TextEditingController pwController;

  late String result;

  late String id;
  late String name;
  late String pw;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: Static.id);
    nickController = TextEditingController(text: Static.name);
    pwController = TextEditingController(text: Static.pw);
    name = Static.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.amberAccent,
                radius: 50,
                child: Icon(
                  Icons.person_outline,
                  size: 70,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: nickController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: pwController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        name = nickController.text;
                        pw = pwController.text;
                        _changeInfo();
                        _rebuild();
                      });
                    },
                    child: const Text(
                      '수정하기',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _leaveInfo();
                        rebuild();
                      });
                    },
                    child: const Text(
                      '탈퇴하기',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // functions
  _changeInfo() async {
    var uri = Uri.parse(
        "http://localhost:8080/Flutter/water_drinking/changeinfo.jsp?user_name=$name&user_pw=$pw&user_id=${idController.text}");
    var response = await http.get(uri);
    setState(() {
      var jSON = json.decode(utf8.decode(response.bodyBytes));
      result = jSON['result'];

      if (result == "OK") {
        sucessSnackbar(context);
      } else {
        if (Static.name == nickController.text &&
            Static.pw == pwController.text) {
          errorSnackbar(context);
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Main(),
          ));
    });
  }

  _rebuild() {
    setState(() {
      Static.name = name;
      Static.pw = pw;
    });
  }

  _leaveInfo() async {
    var uri = Uri.parse(
        "http://localhost:8080/Flutter/water_drinking/leaveinfo.jsp?&user_id=${idController.text}");
    var response = await http.get(uri);
    setState(() {
      var jSON = json.decode(utf8.decode(response.bodyBytes));
      result = jSON['result'];

      if (result == "OK") {
        goLeave();
      } else {
        errorSnackbar(context);
      }
    });
  }

  errorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('변경된 사항이 없습니다'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    ));
  }

  sucessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('변경사항이 적용되었습니다'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blue,
    ));
  }

  rebuild() {
    setState(() {
      id = Static.id;
    });
  }

  goLeave() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('탈퇴가 완료되었습니다.'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        )).then((value) => rebuild());
                  },
                  child: const Text('로그인 화면으로 가기'))
            ],
          );
        });
  }
}
