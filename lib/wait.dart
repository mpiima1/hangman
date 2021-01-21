import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hangman/working.dart';
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

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Tutorial()));
            },
            child: Text('deep'),
          )
        ],
      ),
    );
  }
}

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text('1.Create Player or try as guest'),
            SizedBox(
              height: 30,
            ),
            Text('2.Upload avator'),
            SizedBox(
              height: 30,
            ),
            Text('3.Add telegram username to chat during multiplayer'),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Statistics()));
              },
              child: Text('deeper'),
            ),
          ],
        ),
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('done'),
    );
  }
}

class Playing extends StatefulWidget {
  @override
  _PlayingState createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
