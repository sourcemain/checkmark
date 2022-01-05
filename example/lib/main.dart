import 'package:checkmark/checkmark.dart';
import 'package:flutter/material.dart';

class CheckMarkPage extends StatefulWidget {
  const CheckMarkPage({Key? key}) : super(key: key);

  @override
  _CheckMarkPageState createState() => _CheckMarkPageState();
}

class _CheckMarkPageState extends State<CheckMarkPage> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            setState(() {
              checked = !checked;
            });
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: CheckMark(
              active: checked,
              curve: Curves.decelerate,
              duration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      ),
    );
  }
}
