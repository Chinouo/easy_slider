import 'package:easy_slider/easy_slider.dart';
import 'package:easy_slider/src/dragwithAnimationController.dart';
import 'package:flutter/material.dart';

class AnimationIconSlider extends StatefulWidget {
  AnimationIconSlider({Key? key}) : super(key: key);

  @override
  _AnimationIconSliderState createState() => _AnimationIconSliderState();
}

class _AnimationIconSliderState extends State<AnimationIconSlider>
    with TickerProviderStateMixin {
  List<TriggerValWithControllerEntry> controllers =
      <TriggerValWithControllerEntry>[];
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.lightBlue,
      child: DragWithAnimationController(
          percentageNotifier: ValueNotifier(0.0),
          controllers: controllers,
          child: Flex(direction: Axis.horizontal, children: _buildIcons())),
    );
  }

  List<Widget> _buildIcons() {
    List<Widget> widgets = <Widget>[];

    controllers.add(TriggerValWithControllerEntry(
        controller:
            AnimationController(vsync: this, duration: Duration(seconds: 1)),
        triggerValue: 0.2));
    widgets.add(Expanded(
        child: Center(
      child: AnimatedIcon(
          size: 20,
          icon: AnimatedIcons.add_event,
          progress: controllers[0].controller),
    )));

    controllers.add(TriggerValWithControllerEntry(
        controller:
            AnimationController(vsync: this, duration: Duration(seconds: 1)),
        triggerValue: 0.4));
    widgets.add(Expanded(
        child: Center(
      child: AnimatedIcon(
          size: 20,
          icon: AnimatedIcons.arrow_menu,
          progress: controllers[1].controller),
    )));

    controllers.add(TriggerValWithControllerEntry(
        controller:
            AnimationController(vsync: this, duration: Duration(seconds: 1)),
        triggerValue: 0.6));
    widgets.add(Expanded(
        child: Center(
      child: AnimatedIcon(
          size: 20,
          icon: AnimatedIcons.ellipsis_search,
          progress: controllers[2].controller),
    )));

    return widgets;
  }
}
