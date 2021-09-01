import 'package:flutter/material.dart';
import 'package:easy_slider/easy_slider.dart';

class SliderWithText extends StatefulWidget {
  const SliderWithText({Key? key}) : super(key: key);
  @override
  _SliderWithTextState createState() => _SliderWithTextState();
}

class _SliderWithTextState extends State<SliderWithText> {
  final ValueNotifier<double> n = ValueNotifier<double>(0.0);
  @override
  void initState() {
    super.initState();
    n.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragPercentageProvider(
      valListener: n,
      child: SizedBox(
        height: 50,
        width: 200,
        child: ColoredBox(
          color: Colors.lightBlueAccent,
          child: Text("Touch&Move \n currentValue:${n.value}"),
        ),
      ),
    );
  }
}
