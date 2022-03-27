import 'dart:async';
import 'dart:convert';

import 'package:final_620710820/pages/quiz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Future<List> _data = _getQuiz();
  var _id = 0;
  var _text = "";
  var _isCorrect = false;
  var _incorrect = 0;

  Future<List> _getQuiz() async {
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/quizzes');
    var response = await http.get(url, headers: {'id': '620710820'},);

    var json = jsonDecode(response.body);
    var apiResult = ApiResult.fromJson(json);
    List data = apiResult.data;
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(_id < 5)
                    FutureBuilder<List>(
                      future: _data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData) {
                          var data = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(data[_id]['image'], height: 350.0,),
                              for(var i = 0; i <
                                  data[_id]['choice_list'].length; ++i)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (data[_id]['choice_list'][i] ==
                                            data[_id]['answer']) {
                                          _text = "ถูกต้องนะค้าบ";
                                          _isCorrect = true;
                                          Timer(Duration(seconds: 1), () {
                                            setState(() {
                                              _id++;
                                              _text = "";
                                            });
                                          });
                                        } else {
                                          setState(() {
                                            _text = "ผิดค้าบผม";
                                            _isCorrect = false;
                                            _incorrect++;
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                        height: 50.0,
                                        color: Colors.blue,
                                        child: Center(child: Text(
                                          data[_id]['choice_list'][i],
                                          style: TextStyle(fontSize: 18.0),))
                                    ),
                                  ),
                                )
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("จบเกม", style: TextStyle(fontSize: 38.0),),
                        Text("ทายผิด $_incorrect ครั้ง",
                          style: TextStyle(fontSize: 26.0),),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _id = 0;
                              _incorrect = 0;
                              _data = _getQuiz();
                            });
                          },
                          child: Container(
                              height: 50.0,
                              width: 150.0,
                              color: Colors.blue,
                              child: Text("เริ่มเกมใหม่", textAlign: TextAlign
                                  .center, style: TextStyle(fontSize: 18.0),)
                          ),
                        )
                      ],
                    ),
                  if(_isCorrect)
                    Text(_text,
                      style: TextStyle(fontSize: 26.0, color: Colors.green),)
                  else
                    Text(_text,
                      style: TextStyle(fontSize: 26.0, color: Colors.red),)
                ],
              ),
            )
        ),
      ),
    );
  }
}