import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'newkeyboard.dart';

Future<String> _localpaths() async {
  final directory = (await getApplicationDocumentsDirectory()).path;
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
  final String nulified;
  Gamelogic({
    Key key,
    this.finished,
    this.oldchances,
    this.olddummy,
    this.oldword,
    this.nulified,
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
  String nulified;

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
            writedammy('finstate.txt', 'true');
            nulified = '0';
          } else {
            word = widget.oldword;
            dummy = widget.olddummy;
            leng = dummy.length;
            chances = int.parse(widget.oldchances);
            nulified = widget.nulified;
          }

          loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(
          'Hangman',
          style: TextStyle(letterSpacing: 2.0, color: Colors.yellow),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
      ),
      body: Container(
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
            Center(
              child: getWidget(),
            ),
          ],
        ),
      ),
    );
  }

  _onkeypres(String mykey) {
    if (chances != 0 && dummy != word) {
      text = mykey;
      nulified = nulified + mykey;
      if (!_oneofkeys()) {
        chances = chances - 1;
      } else {
        dummy = _updatedummy();
      }
      writedammy('svddummy.txt', dummy);
      writedammy('oldchances.txt', chances.toString());
      writedammy('finstate.txt', 'false');
      writedammy('nullified.txt', nulified);

      if (chances == 0 || dummy == word) {
        newgames = 0;
        writedammy('finstate.txt', 'true');
        chances = 10;
        nulified = '0';
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
            Text(
              chances.toString(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.yellow,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(dummy,
                style: TextStyle(
                  color: Colors.yellow,
                  letterSpacing: 4.0,
                  fontSize: 20,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: CustomKeyboard(
                      onTextInput: (mytext) => _onkeypres(mytext),
                      nulified: nulified,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      } else {
        if (word == dummy) {
          return Column(
            children: <Widget>[
              Text(
                'congs the word is: ' + word,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.yellow,
                ),
              ),
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
              Text(
                'sorry, the word is: ' + word,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.yellow,
                ),
              ),
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
