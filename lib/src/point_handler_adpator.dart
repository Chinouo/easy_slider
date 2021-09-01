// Copyright (c) 2021 Chinouo . All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'render_pointhandler.dart';
import 'dart:math';

const double HALF_PI = pi / 2;

//监听触摸的百分比的组件
/// A widget can provide slide percentage to given [ValueNotifier].
///
/// [DragPercentageProvider] is consist of two parts.
/// 1. Use [GestureDetector] to get gesture data which is be processed in
///  private method of [DragPercentageProvider]'s state.
/// 2. Use [GestureDetectorBox] to enable the child has ability to recive pointEvent.
///
///  This widget use context's size property to calculate the value,
///  and the percentage will be clamped from 0.0 to 1.0.
///
///  The default response direction it from `Left to Right`, `Top to Bottom`.
class DragPercentageProvider extends StatefulWidget {
  final Widget child;

  /// Notify percentage
  final ValueNotifier<double> valListener;

  /// Gesture response direction.
  final Axis? direction;
  final double? initVal;

  /// Whether to enable reverse behavior.
  final bool reverse;
  DragPercentageProvider(
      {Key? key,
      this.reverse = false,
      this.direction = Axis.horizontal,
      required this.child,
      required this.valListener,
      this.initVal})
      : super(key: key);

  @override
  _DragPercentageProviderState createState() => _DragPercentageProviderState();
}

class _DragPercentageProviderState extends State<DragPercentageProvider> {
  /// Store the percentage.
  late double storedPercentage;
  @override
  void initState() {
    storedPercentage = widget.initVal ?? 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reverse) {
      return GestureDetector(
          onPanUpdate: widget.direction == Axis.horizontal
              ? _handleReverseHorizontalDragGesture
              : _handleReverseVerticalDragGesture,
          child: GestureDetectorBox(child: widget.child));
    } else {
      return GestureDetector(
          onPanUpdate: widget.direction == Axis.horizontal
              ? _handleHorizontalDragGesture
              : _handleVerticalDragGesture,
          child: GestureDetectorBox(child: widget.child));
    }
  }

  //更改notifier的值并分发消息
  void _handleHorizontalDragGesture(DragUpdateDetails details) {
    storedPercentage += details.delta.dx / context.size!.width;
    storedPercentage = storedPercentage.clamp(0.0, 1.0);
    widget.valListener.value = storedPercentage;
  }

  void _handleVerticalDragGesture(DragUpdateDetails details) {
    storedPercentage += details.delta.dy / context.size!.height;
    storedPercentage = storedPercentage.clamp(0.0, 1.0);
    widget.valListener.value = storedPercentage;
  }

  //reverse版本
  void _handleReverseHorizontalDragGesture(DragUpdateDetails details) {
    storedPercentage -= details.delta.dx / context.size!.width;
    storedPercentage = storedPercentage.clamp(0.0, 1.0);
    widget.valListener.value = storedPercentage;
  }

  void _handleReverseVerticalDragGesture(DragUpdateDetails details) {
    storedPercentage -= details.delta.dy / context.size!.height;
    storedPercentage = storedPercentage.clamp(0.0, 1.0);
    widget.valListener.value = storedPercentage;
  }
}
