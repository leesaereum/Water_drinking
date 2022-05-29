import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_drinking_app/main.dart';
import 'package:water_drinking_app/pages/siginin_page.dart';
import 'package:http/http.dart' as http;
import 'package:water_drinking_app/static.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController(text: 'test');
  final pwController = TextEditingController(text: '1234');
  String Id = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login temp_screen'),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.brown[200],
                  radius: 50,
                  child: const Icon(
                    Icons.free_breakfast,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: idController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input ID(Email)'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: pwController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input PassWord'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (idController.text.isEmpty ||
                          pwController.text.isEmpty) {
                        inputerror();
                      } else {
                        _logIn();
                      }
                    },
                    child: const Text('Log in')),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninPage(),
                        ));
                  },
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // functions
  _logIn() async {
    var url = Uri.parse(
        "http://localhost:8080/Flutter/water_drinking/login.jsp?user_id=${idController.text}&user_pw=${pwController.text}");
    var response = await http.get(url);
    setState(() {
      var JSON = json.decode(utf8.decode(response.bodyBytes));
      var result = JSON['result'];
      if (result[0]['id'] == '실패') {
        login_fail();
      } else {
        Static.id = result[0]['id'];
        Static.name = result[0]['name'];
        Static.goal = int.parse(result[0]['goal']);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Main(),
            ));
      }
    });
  }

  login_fail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('입력하신 아이디,비밀번호와 일치하는 정보가 없습니다.\n다시 확인해주세요.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  inputerror() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('아이디와 비밀번호를 입력해주세요.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
