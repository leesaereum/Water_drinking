import 'package:flutter/material.dart';
import 'package:water_drinking_app/home.dart';
import 'package:water_drinking_app/pages/calendar.dart';
import 'package:water_drinking_app/pages/login_page.dart';
import 'package:water_drinking_app/pages/mypage.dart';
import 'package:water_drinking_app/pages/today.dart';
import 'package:water_drinking_app/static.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const Main(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  late TabController controller;
  late String id = "";
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    rebuild();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          controller: controller,
          children: const [Home(), Today(), Calendar()]),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.amber,
        child: TabBar(
            controller: controller,
            indicatorColor: Colors.amber,
            labelColor: Colors.black87,
            tabs: const [
              Tab(
                icon: Icon(Icons.local_florist, color: Colors.black87),
                text: '꽃피우기',
              ),
              Tab(
                icon: Icon(Icons.water_drop, color: Colors.black87),
                text: '오늘의 물',
              ),
              Tab(
                icon: Icon(Icons.calendar_month, color: Colors.black87),
                text: '캘린더',
              ),
            ]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.amber,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // const CircleAvatar(
                  //   backgroundImage: AssetImage('images/5.jpg'),
                  //   radius: 100,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(Static.name.isNotEmpty
                        ? '${Static.name}님 환영합니다!'
                        : '로그인을 해주세요.'),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            id.isEmpty
                ? ListTile(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            )).then((value) => rebuild());
                      });
                    },
                    leading: const Icon(Icons.login),
                    title: const Text('로그인'),
                  )
                : ListTile(
                    onTap: () {
                      setState(() {
                        Static.goal = 0;
                        Static.id = "";
                        Static.name = "";
                        Static.water = 0;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Main(),
                            ));
                      });
                      rebuild();
                      gologin();
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text('로그아웃'),
                  ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Today()));
              },
              leading: const Icon(Icons.water_drop),
              title: const Text('오늘의 물주기'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Calendar()));
              },
              leading: const Icon(Icons.calendar_month),
              title: const Text('한달의 기록'),
            ),
            if (Static.id.isNotEmpty) // id가 isNotEmpty이면 마이페이지 화면보이기
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Mypage(),
                    ),
                  );
                },
                leading: const Icon(Icons.settings),
                title: const Text('마이페이지'),
              )
          ],
        ),
      ),
    );
  }

  rebuild() {
    setState(() {
      id = Static.id;
    });
  }

  gologin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('로그아웃 완료되었습니다.'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        )).then((value) => rebuild());
                  },
                  child: const Text('로그인 하러가기'))
            ],
          );
        });
  }
}
