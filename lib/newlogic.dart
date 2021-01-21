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
    home: Hangman(),
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
  //String data;
  String text = '';
  int chances = 10;
  String dummy = '';
  int leng;

  /* _HangmanState() {
    _localPath().then((value) => setState(() {
          data = value;
        }));
    print(data);
  }
  void initState() {
    super.initState();
    _localPath().then((value) => setState(() {
          data = value;
        }));
  }*/

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
              child: FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/wordlist.txt'),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var rand = new Random();
                      LineSplitter ls = new LineSplitter();
                      List<String> lines = ls.convert(snapshot.data);
                      var word = lines[rand.nextInt(7000)];
                      dummy = dummyString(word);
                      return Column(
                        children: <Widget>[
                          Text(dummy,
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
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
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
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = key.text;
      if (!_oneofkeys()) {
        chances -= chances;
      } else {
        dummy = _updatedummy();
      }
    } else {}
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
}

/*
import 'package:flutter/material.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Virtual Keyboard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Holds the text that user typed.
  String text = '';
  // True if shift enabled.
  bool shiftEnabled = false;
  // is true will show the numeric keyboard.
  bool isNumericMode = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.display1,
            ),
            SwitchListTile(
              title: Text(
                'Keyboard Type = ' +
                    (isNumericMode
                        ? 'VirtualKeyboardType.Numeric'
                        : 'VirtualKeyboardType.Alphanumeric'),
              ),
              value: isNumericMode,
              onChanged: (val) {
                setState(() {
                  isNumericMode = val;
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              color: Colors.deepPurple,
              child: VirtualKeyboard(
                  height: 300,
                  textColor: Colors.white,
                  type: isNumericMode
                      ? VirtualKeyboardType.Numeric
                      : VirtualKeyboardType.Alphanumeric,
                  onKeyPress: _onKeyPress),
            )
          ],
        ),
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }
}
*/
