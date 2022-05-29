import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late TextEditingController idController;
  late TextEditingController nickController;
  late TextEditingController pwController;
  bool checking = false;
  late String join_result = "";

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    nickController = TextEditingController();
    pwController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign-In',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input ID',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nickController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input Nickname',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: pwController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (idController.text.isEmpty ||
                          nickController.text.isEmpty ||
                          pwController.text.isEmpty) {
                        if (idController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('아이디를 입력하세요.'),
                            backgroundColor: Colors.red,
                          ));
                        } else if (nickController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('닉네임을 입력하세요.'),
                            backgroundColor: Colors.red,
                          ));
                        } else if (pwController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('비밀번호를 입력하세요.'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      } else {
                        checkID();
                      }
                    },
                    child: const Text('Sign in')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // functions
  checkID() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/water_drinking/checkid.jsp?id=${idController.text}');
    var response = await http.get(url);

    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      var ids = JSON['result']['id'];
      if (ids == idController.text) {
        errorSnackbar();
      } else {
        join();
      }
    });
  }

  join() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/water_drinking/join.jsp?id=${idController.text}&name=${nickController.text}&pw=${pwController.text}');
    var response = await http.get(url);

    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      join_result = JSON['result'];
      if (join_result == 'OK') {
        sucessJoin();
      } else {
        failJoin();
      }
    });
  }

  errorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('중복된 아이디 입니다.'),
      backgroundColor: Colors.red,
    ));
  }

  sucessJoin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('회원가입이 완료되었습니다.'),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('로그인하러 가기')),
              )
            ],
          );
        });
  }

  failJoin() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('입력하신 정보들을 다시 확인하여주세요.'),
      backgroundColor: Colors.red,
    ));
  }
}
