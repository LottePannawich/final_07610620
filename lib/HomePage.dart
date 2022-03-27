import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'animalclass.dart';
import 'api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<animal>? animal_list;
  int count = 0;
  int wrong_guess = 0;
  String message = "";

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
      animal_list = list.map((item) => animal.fromJson(item)).toList();
    });
  }

  void guess(String choice) {
    setState(() {
      if (animal_list![count].answer == choice) {
        message = "เก่งมากครับ";
      } else {
        message = "ตอบผิด กรุณาตอบใหม่";
      }
    });
    Timer timer = Timer(Duration(seconds: 1), () {
      setState(() {
        message = "";
        if (animal_list![count].answer == choice) {
          count++;
        } else {
          wrong_guess++;
        }
      });
    });
  }

  Widget printGuess() {
    if (message.isEmpty) {
      return SizedBox(height: 20, width: 10);
    } else if (message == "เก่งมากครับ") {
      return Text(message,style: TextStyle(color: Colors.green,fontSize: 20),);
    } else {
      return Text(message,style: TextStyle(color: Colors.blue,fontSize: 20));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: animal_list != null && count < animal_list!.length-1
          ? buildQuiz()
          : animal_list != null && count == animal_list!.length-1
          ? buildTryAgain()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTryAgain() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('End Game',style:TextStyle(color: Colors.green,fontSize: 50)),
            Text('ทายผิดไปทั้งหมด ${wrong_guess} ครั้ง',style: TextStyle(color: Colors.green,fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    wrong_guess = 0;
                    count = 0;
                    animal_list = null;
                    _fetch();
                  });
                },
                child: Text('เริ่มเกมส์ใหม่อีกครั้ง'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(animal_list![count].image, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < animal_list![count].choice_list.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(animal_list![count].choice_list[i].toString()),
                            child: Text(animal_list![count].choice_list[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printGuess(),
          ],
        ),
      ),
    );
  }
}