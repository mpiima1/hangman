import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

Future<String> _localpaths() async {
  final directory = _localPath();
  final data = await rootBundle.loadString('assets/wordlist.txt');
  final file = await File('$directory/wordlist.txt').writeAsString(data);
  return file.readAsString();
}

Future<String> _localPath() async {
  final directory = await getExternalStorageDirectory();
  return directory.path;
}

Future<File> _localFile(String filename) async {
  final path = await _localPath();
  return File("$path/$filename");
}

Future<File> writedammy(String files, String data) async {
  final file = await _localFile(files);
  return file.writeAsString(data);
}

class Gamelogic extends StatefulWidget {
  final String finished;
  final String oldword;
  final String olddummy;
  final String oldchances;
  Gamelogic({
    Key key,
    this.finished,
    this.oldchances,
    this.olddummy,
    this.oldword,
  }) : super(key: key);
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
        } else {
          dummy = _updatedummy();
        }
        writedammy('svddummy.txt', dummy);
        writedammy('oldchances.txt', chances.toString());
        writedammy('finstate.txt', 'false');
      } else {}
      if (chances == 0 || dummy == word) {
        newgames = 0;
        writedammy('finstate.txt', 'true');
        chances = 10;
      }
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
            Text(dummy + chances.toString(),
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
              Text('congs the word is: ' + word),
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
              Text('sorry, the word is: ' + word),
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
