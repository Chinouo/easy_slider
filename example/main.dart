import 'package:flutter/material.dart';
import 'dart:core';
import 'reverse_custompaint_demo.dart';
import 'custompaint_demo.dart';
import 'vertical_custompaint_demo.dart';
import 'animatedicon_demo.dart';
import 'slider_base.dart';

void main(List<String> args) {
  runApp(Demo());
}

class Demo extends StatelessWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SliderDemo"),
        ),
        body: Column(
          children: [
            ColorBoxSlider(),
            ReverseColorBoxSlider(),
            VerticalColorBoxSlider(),
            AnimationIconSlider(),
            SliderWithText()
          ],
        ),
      ),
    );
  }
}
