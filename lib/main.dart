import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
//import 'dart:async';
import 'dart:io';
//import 'package:flutter/foundation.dart';
//import 'package:hangman/working.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Hangman(),
  ));
}

class Hangman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        title: Text('Hangman'),
        backgroundColor: Colors.grey[600],
      ),
      body: Homepage(),
    );
  }
}

Future<String> _localPath() async {
  final directory = await getExternalStorageDirectory();
  return directory.path;
}

Future<File> _localFile(String filename) async {
  final path = await _localPath();
  return File("$path/$filename");
}

Future<String> _readData(String filez) async {
  try {
    final file = await _localFile(filez);
    String content = await file.readAsString();
    return content;
  } catch (e) {
    return '0';
  }
}

Future<File> writedammy(String files, String data) async {
  final file = await _localFile(files);
  return file.writeAsString(data);
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool loading = true;
  String finState;
  String svddummy;
  String svdword;
  String gmsplyd;
  String gmspsd;
  String gmsfld;
  String oldchances;
  void _setmystate(_) {
    setState(() {});
  }

  Future<bool> loadData() async {
    //await writedammy('svddummy.txt', 'woooww');
    svddummy = await _readData('svddummy.txt');
    svdword = await _readData('svdword.txt');
    finState = await _readData('finstate.txt');
    gmsplyd = await _readData('gmsplyd.txt');
    gmspsd = await _readData('gmspsd.txt');
    gmsfld = await _readData('gmsfld.txt');
    oldchances = await _readData('oldchances.txt');
    return false;
  }

  FutureOr onGoBack(dynamic value) async {
    var name = await loadData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    loadData().then((value) => setState(() {
          loading = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Lubuulwa         ',
                style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 12,
                    color: Colors.yellow[300]),
              ),
              RaisedButton(
                onPressed: null, //_onpressed1,
                child: Text(
                  'statistics',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 12,
                    color: Colors.yellow[300],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: <Widget>[
                finState == 'false'
                    ? RaisedButton(
                        onPressed: null, //_onpressed2,
                        child: Text(
                          'resume',
                          style: TextStyle(letterSpacing: 2.0),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Gamelogic(
                                  finished: finState,
                                  oldchances: oldchances,
                                  olddummy: svddummy,
                                  oldword: svdword,
                                  setmystate: _setmystate,
                                ))).then(onGoBack);
                  },
                  child: Text(
                    'newgame',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      color: Colors.yellow[300],
                    ),
                  ),
                )
                /* DropdownButton(items: [
                  DropdownMenuItem(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Gamelogic()));
                      },
                      child: Text('animals'),
                    ),
                  )
                ], onChanged: null),*/
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<String> _localpaths() async {
  final directory = (await getApplicationDocumentsDirectory()).path;
  final data = await rootBundle.loadString('assets/wordlist.txt');
  final file = await File('$directory/wordlist.txt').writeAsString(data);
  return file.readAsString();
}

class Gamelogic extends StatefulWidget {
  String finished;
  String oldword;
  String olddummy;
  String oldchances;
  final ValueChanged<void> setmystate;
  Gamelogic(
      {Key key,
      this.finished,
      this.oldchances,
      this.olddummy,
      this.oldword,
      this.setmystate})
      : super(key: key);
  @override
  _GamelogicState createState() => _GamelogicState();
}

class _GamelogicState extends State<Gamelogic> {
  String word;
  String data;
  String text;
  int chances = 10;
  String dummy;
  int leng;
  bool loading;
  List<String> lines;
  var rand = new Random();
  LineSplitter ls = new LineSplitter();
  int states = 0;
  int newgames = 1;

  /* _GamelogicState() {
    _localpaths().then((value) => setState(() {
          data = value;
        }));
    print(data);
  }*/
  void initState() {
    super.initState();
    loading = true;
    _localpaths().then((value) => setState(() {
          data = value;
          lines = ls.convert(data);
          if (widget.finished == 'true') {
            word = lines[rand.nextInt(7000)];
            dummy = dummyString(word);
            writedammy('svdword.txt', word);
            writedammy('svddummy.txt', dummy);
          } else {
            word = widget.oldword;
            dummy = widget.olddummy;
            leng = dummy.length;
            chances = int.parse(widget.oldchances);
          }

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
    if (chances != 0 && dummy != word) {
      if (key.keyType == VirtualKeyboardKeyType.String) {
        text = key.text;
        if (!_oneofkeys()) {
          chances = chances - 1;
          widget.oldchances = chances.toString();
        } else {
          dummy = _updatedummy();
          widget.olddummy = dummy;
        }
        writedammy('svddummy.txt', dummy);
        writedammy('oldchances.txt', chances.toString());
        writedammy('finstate.txt', 'false');
        widget.setmystate(null);
        widget.finished = 'false';
      } else {}
    } else {
      newgames = 0;
      writedammy('finstate.txt', 'true');
      widget.finished = 'true';
      widget.setmystate(null);
      chances = 10;
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
    if (loading == true) {
      return CircularProgressIndicator();
    } else {
      if (newgames == 1) {
        return Column(
          children: <Widget>[
            Text(
                dummy +
                    '  ' +
                    word +
                    '  ' +
                    dummy.length.toString() +
                    ' ' +
                    chances.toString(),
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
        if (word == dummy) {
          return Column(
            children: <Widget>[
              Text('congs'),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  word = lines[rand.nextInt(7000)];
                  dummy = dummyString(word);
                  leng = dummy.length;
                  writedammy('svddummy.txt', dummy);
                  writedammy('svdword.txt', word);
                  newgames = 1;
                  setState(() {});
                },
                child: Text('again'),
              )
            ],
          );
        } else {
          return Column(
            children: <Widget>[
              Text('sorry'),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  word = lines[rand.nextInt(7000)];
                  dummy = dummyString(word);
                  writedammy('svddummy.txt', dummy);
                  writedammy('svdword.txt', word);
                  newgames = 1;
                  setState(() {});
                },
                child: Text('again'),
              )
            ],
          );
        }
      }
    }
  }
}
