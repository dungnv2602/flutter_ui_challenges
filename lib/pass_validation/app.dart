/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
/// Implementation originated by: https://github.com/tunitowen/password_animation
/// With my own workarounds and improvements
/// source: https://dribbble.com/shots/4755212-Password-Guide
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'text_notifier.dart';
import 'validate_item.dart';


class Home extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TextNotifier(''),
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 32),
            StackWidgets(textController: textController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Consumer<TextNotifier>(
                builder: (_, notifier, child) => TextField(
                  controller: textController,
                  onChanged: (text) => notifier.value = text,
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Set a password',
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(width: 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(width: 0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: double.infinity,
              child: FlatButton(
                padding: const EdgeInsets.all(16),
                color: Colors.yellow[700],
                child: Text(
                  'SAVE',
                  style:
                      const TextStyle(color: Colors.deepPurple, fontSize: 18),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StackWidgets extends StatefulWidget {
  final TextEditingController textController;

  const StackWidgets({Key key, @required this.textController})
      : super(key: key);

  @override
  _StackWidgetsState createState() => _StackWidgetsState();
}

class _StackWidgetsState extends State<StackWidgets>
    with SingleTickerProviderStateMixin<StackWidgets> {
  AnimationController _controller;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _scale = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  bool eightChars(String text) => text.length >= 8;

  bool number(String text) => text.contains(RegExp(r'\d'), 0);

  bool upperCaseChar(String text) => text.contains(new RegExp(r'[A-Z]'), 0);

  bool specialChar(String text) =>
      text.isNotEmpty && !text.contains(RegExp(r'^[\w&.-]+$'), 0);

  final separator = Container(height: 1, color: Colors.blue[100]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Card(
            shape: CircleBorder(),
            color: Colors.black12,
            child: Container(height: 150, width: 150),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32, left: 10),
            child: Transform.rotate(
              angle: -0.2,
              child: Icon(Icons.lock, color: Colors.pink, size: 60),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 60),
            child: Transform.rotate(
              angle: 0.05,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 4,
                color: Colors.yellow[800],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    4,
                    (_) => Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 0, 6),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.brightness_1,
                            color: Colors.deepPurple,
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.1,
            child: Card(
              margin: const EdgeInsets.only(left: 80),
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      separator,
                      ValidateItemConsumer(
                          title: '8 characters', onValueChanged: eightChars),
                      separator,
                      ValidateItemConsumer(
                          title: '1 special char', onValueChanged: specialChar),
                      separator,
                      ValidateItemConsumer(
                          title: '1 upper case', onValueChanged: upperCaseChar),
                      separator,
                      ValidateItemConsumer(
                          title: '1 number', onValueChanged: number),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 32),
                    width: 2,
                    height: 170,
                    color: Colors.red,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    width: 50,
                    height: 50,
                    child: Consumer<TextNotifier>(
                      builder: (_, notifier, child) {
                        final text = notifier.value;
                        (eightChars(text) &&
                                number(text) &&
                                specialChar(text) &&
                                upperCaseChar(text))
                            ? _controller.forward()
                            : _controller.reverse();
                        return ScaleTransition(
                          scale: _scale,
                          child: child,
                        );
                      },
                      child: Card(
                        shape: CircleBorder(),
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.check, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
