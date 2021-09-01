// Copyright (c) 2021 Chinouo . All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'point_handler_adpator.dart';
import 'package:flutter/material.dart';
import 'animation_manager.dart';

/// a widget can trigger animation with slide behavior when slide percentage reached
/// the [AnimationController]'s trigger value.
///
/// This widget is used for multi [TriggerValWithControllerEntry] which is combined
/// [AnimationController] with a trigger value.
///
/// Notice:The widget collected controllers in a list with a certain index!
class DragWithAnimationController extends StatefulWidget {
  final ValueNotifier<double>? percentageNotifier;

  /// Notify which controllerEntry is active.
  final ValueNotifier<TriggerValWithControllerEntry?>? activeControllerNotifier;
  final List<TriggerValWithControllerEntry> controllers;
  final int? initIndex;
  final Widget child;
  final Axis? direction;
  final bool? reverse;
  const DragWithAnimationController(
      {Key? key,
      required this.percentageNotifier,
      required this.controllers,
      required this.child,
      this.activeControllerNotifier,
      this.direction = Axis.horizontal,
      this.initIndex = 0,
      this.reverse = false})
      : super(key: key);

  @override
  _DragWithAnimationControllerState createState() =>
      _DragWithAnimationControllerState();
}

class _DragWithAnimationControllerState
    extends State<DragWithAnimationController> {
  late AnimationControllerManager _manager;
  late ValueNotifier<double> percentageNotifier;
  @override
  void initState() {
    super.initState();
    percentageNotifier = widget.percentageNotifier ?? ValueNotifier(0.0);
    percentageNotifier.addListener(handleValueChange);
    _manager = AnimationControllerManager(
        initIndex: widget.initIndex!,
        controllers: widget.controllers,
        notifier: widget.activeControllerNotifier);
  }

  @override
  void dispose() {
    percentageNotifier.removeListener(handleValueChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double intialPercentage = 0.0;
    if (widget.initIndex != widget.controllers.length) {
      if (widget.initIndex != 0)
        intialPercentage =
            widget.controllers[widget.initIndex! - 1].triggerValue;
    } else {
      intialPercentage = 1.0;
    }

    return DragPercentageProvider(
      reverse: widget.reverse!,
      initVal: intialPercentage,
      child: widget.child,
      valListener: percentageNotifier,
      direction: widget.direction,
    );
  }

  //定义手势变化后的行为
  void handleValueChange() {
    _manager.handleGesture(percentageNotifier.value);
  }
}
