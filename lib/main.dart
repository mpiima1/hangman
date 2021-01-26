import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'gamelogic.dart';

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

  Future<bool> loadData() async {
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Gamelogic(
                                        finished: finState,
                                        oldchances: oldchances,
                                        oldword: svdword,
                                        olddummy: svddummy,
                                      ))).then(onGoBack);
                        },
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
                            builder: (context) =>
                                Gamelogic(finished: 'true'))).then(onGoBack);
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
