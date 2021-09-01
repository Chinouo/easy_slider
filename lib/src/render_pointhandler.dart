// Copyright (c) 2021 Chinouo . All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'point_handler_adpator.dart';

/// A widget can recive pointEvent, its size is depended on child.
/// [GestureDetectorBox] is used for [DragPercentageProvider] to have ability to
/// recive gesture infomation by setting behavior to [HitTestBehavior.opaque].
/// See also: [ColoredBox].
class GestureDetectorBox extends SingleChildRenderObjectWidget {
  const GestureDetectorBox({Widget? child, Key? key})
      : super(child: child, key: key);

  @override
  _RenderGestureDetectorBox createRenderObject(BuildContext context) {
    return _RenderGestureDetectorBox();
  }
}

class _RenderGestureDetectorBox extends RenderProxyBoxWithHitTestBehavior {
  _RenderGestureDetectorBox() : super(behavior: HitTestBehavior.opaque);
  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}
