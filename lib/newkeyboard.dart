import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  List<String> row1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  List<String> row2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  List<String> row3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];
  CustomKeyboard({
    Key key,
    this.onTextInput,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;

  void _textInputHandler(String text) => onTextInput?.call(text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: Colors.blue,
      child: Column(
        children: [
          buildRow(row1),
          buildRow(row2),
          buildRow(row3),
        ],
      ),
    );
  }

  Expanded buildRow(List<String> chars) {
    return Expanded(
      child: Row(
        children: [
          for (var item in chars)
            TextKey(
              text: item,
              onTextInput: _textInputHandler,
            )
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
  }) : super(key: key);

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Material(
          color: Colors.grey[900],
          child: InkWell(
            onTap: () {
              onTextInput?.call(text);
            },
            child: Container(
              child: Center(
                  child: Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.yellow),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
