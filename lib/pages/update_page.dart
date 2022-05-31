import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdatePage extends StatefulWidget {
  final String cardId;
  final String cardKind;
  final String cardVolume;

  const UpdatePage(
      {Key? key,
      required this.cardId,
      required this.cardKind,
      required this.cardVolume,
      })
      : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController idController;
  late TextEditingController kindController;
  late TextEditingController volumeController;


  late String waterId;
  late String waterKind;
  late String waterVolume;
 
  late String result;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.cardId);
    kindController = TextEditingController(text: widget.cardKind);
    volumeController = TextEditingController(text: widget.cardVolume);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기록 수정하기'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: kindController,
                //decoration: const InputDecoration(labelText: '수정하세요.'),
                readOnly: true,
              ),
              TextField(
                controller: volumeController,
                decoration: const InputDecoration(labelText: '용량을 수정하세요.'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  waterId = idController.text;
                  waterKind = kindController.text;
                  waterVolume = volumeController.text;
      
                  updateAction();
                },
                child: const Text("수정하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Functions
  updateAction() async {
    // get방식으로 jsp로 데이터 넘겨주기
    var url = Uri.parse(
        'http://localhost:8080/Flutter/water_drinking/updatewater.jsp?water_volume=$waterVolume&water_id=$waterId');
    var response = await http.get(url);

    // db에 데이터 입력하고 결과값 받아서 오류나면 에러 아니면 alert
    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];

      if (result == "OK") {
        _showDialog(context);
      } else {
        errorSnackbar(context);
      }
    });
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("수정 결과"),
            content: const Text("수정이 완료되었습니다."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  errorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("사용자 정보 수정에 문제가 발생 하였습니다."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}//End
