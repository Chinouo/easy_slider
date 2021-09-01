import 'package:flutter/material.dart';
import 'package:easy_slider/easy_slider.dart';

class VerticalColorBoxSlider extends StatefulWidget {
  VerticalColorBoxSlider({Key? key}) : super(key: key);

  @override
  _VerticalColorBoxSliderState createState() => _VerticalColorBoxSliderState();
}

class _VerticalColorBoxSliderState extends State<VerticalColorBoxSlider>
    with TickerProviderStateMixin {
  late ValueNotifier<double> currentPercentage;
  late ValueNotifier<TriggerValWithControllerEntry?> aninot;
  late Animation<Color?> colorAni;
  List<TriggerValWithControllerEntry> cl = [];
  List<Widget> widgets = [];
  List<Animation<Color?>> animations = <Animation<Color?>>[];
  int i = 0;

  @override
  void initState() {
    super.initState();
    currentPercentage = ValueNotifier(0.0);

    aninot = ValueNotifier<TriggerValWithControllerEntry?>(null)
      ..addListener(() {});
    double val = 1 / 18;
    int i = 1;
    for (var x in Colors.primaries) {
      var c = AnimationController(vsync: this, duration: Duration(seconds: 1));
      Animation<Color?> ct = ColorTween(begin: Colors.grey, end: x).animate(c);
      animations.add(ct);
      cl.add(
          TriggerValWithControllerEntry(controller: c, triggerValue: i * val));
      i += 1;
    }

    for (int i = 0; i < cl.length; ++i) {
      widgets.add(Expanded(
          child: DrawBit(
        size: Size(50, 100),
        color: animations[i],
        controller: cl[i].controller,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragWithAnimationController(
      direction: Axis.vertical,
      controllers: cl,
      activeControllerNotifier: aninot,
      percentageNotifier: currentPercentage,
      child: SizedBox(
        height: 300,
        child: Flex(
          direction: Axis.vertical,
          children: widgets,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}

class DrawBit extends StatelessWidget {
  final Animation<Color?> color;
  final AnimationController controller;
  final Size size;
  const DrawBit(
      {Key? key,
      required this.size,
      required this.color,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BitPainter(color: color, controller: controller),
      size: size,
    );
  }
}

class BitPainter extends CustomPainter {
  final Animation<Color?> color;
  final AnimationController controller;
  BitPainter({required this.color, required this.controller})
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()..color = color.value!;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), p);
  }

  @override
  bool shouldRepaint(BitPainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRebuildSemantics(BitPainter oldDelegate) => false;
}
