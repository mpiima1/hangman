import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Tests(),
  ));
}

class LoadAssets {
  Future<String> getdirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> loadData() async {
    final data = await rootBundle.loadString('assets/wordlist.txt');
    return data;
  }

  //LoadAssets() {}
}

Future<String> _localPath() async {
  final directory = (await getApplicationDocumentsDirectory()).path;
  final data = await rootBundle.loadString('assets/wordlist.txt');
  final file = await File('$directory/wordlist.txt').writeAsString(data);
  return file.readAsString();
}

class Hangman extends StatefulWidget {
  @override
  _HangmanState createState() => _HangmanState();
}

class _HangmanState extends State<Hangman> {
  String word = '';
  String data;
  String text = '';
  int chances = 10;
  String dummy = '';
  int leng;
  bool loading;
  List<String> lines;
  var rand = new Random();
  LineSplitter ls = new LineSplitter();
  int states = 0;

  /* _HangmanState() {
    _localPath().then((value) => setState(() {
          data = value;
        }));
    print(data);
  }*/
  void initState() {
    super.initState();
    loading = true;
    _localPath().then((value) => setState(() {
          data = value;
          lines = ls.convert(data);
          word = lines[rand.nextInt(7000)];
          dummy = dummyString(word);
          loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('Hangman'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/mpiima.jpeg'),
                radius: 30,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name:   ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'Mpiima',
                  style: TextStyle(
                    color: Colors.redAccent,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Score',
                  style: TextStyle(
                    color: Colors.redAccent,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: getWidget(),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _onkeypres(VirtualKeyboardKey key) {
    if (chances != 0) {
      if (key.keyType == VirtualKeyboardKeyType.String) {
        text = key.text;
        if (!_oneofkeys()) {
          chances = chances - 1;
        } else {
          dummy = _updatedummy();
        }
      } else {}
    } else {
      chances = 10;
      word = lines[rand.nextInt(7000)];
      dummy = dummyString(word);
    }
    setState(() {});
  }

  _oneofkeys() {
    return word.contains(text);
  }

  _updatedummy() {
    var arrdummy = dummy.split('');
    var arrword = word.split('');
    for (int i = 0; i < leng; i++) {
      if (arrword[i] == text) {
        arrdummy[i] = text;
      }
    }
    return arrdummy.join();
  }

  dummyString(String word) {
    leng = word.length;
    String dummy = '';
    for (int i = 0; i < leng; i++) {
      dummy = dummy + '_';
    }
    return dummy;
  }

  Widget getWidget() {
    if (states == 0) {}
    if (loading == true) {
      return CircularProgressIndicator();
    } else {
      return Column(
        children: <Widget>[
          Text(dummy + '   ' + chances.toString(),
              style: TextStyle(
                color: Colors.yellow,
                letterSpacing: 3.0,
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey[700],
            child: VirtualKeyboard(
              type: VirtualKeyboardType.Alphanumeric,
              onKeyPress: _onkeypres,
              textColor: Colors.white,
              height: 250,
            ),
          )
        ],
      );
    }
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Tests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Hangman()),
            );
          },
          child: Text("well"),
        ),
      ),
    );
  }
}
