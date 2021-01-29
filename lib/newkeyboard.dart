import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  List<String> row1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  List<String> row2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  List<String> row3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];
  CustomKeyboard({
    Key key,
    this.onTextInput,
    this.nulified,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final String nulified;

  void _textInputHandler(String text) => onTextInput?.call(text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: Colors.blue,
      child: Column(
        children: [
          buildRow(row1, nulified),
          buildRow(row2, nulified),
          buildRow(row3, nulified),
        ],
      ),
    );
  }

  Expanded buildRow(List<String> chars, String nullify) {
    return Expanded(
      child: Row(
        children: [
          for (var item in chars)
            TextKey(
              nulling: nullify,
              text: item,
              onTextInput: _textInputHandler,
            ),
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    Key key,
    @required this.text,
    this.onTextInput,
    this.flex = 1,
    this.nulling,
  }) : super(key: key);
  final String nulling;

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Material(
        color: !nulling.contains(text) ? Colors.grey[900] : Colors.grey[700],
        child: InkWell(
          onTap: () => !nulling.contains(text) ? onTextInput?.call(text) : null,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.yellow),
            )),
          ),
        ),
      ),
    );
  }
}
