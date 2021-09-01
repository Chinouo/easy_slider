// Copyright (c) 2021 Chinouo . All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:collection';

//最基本的控制器规范
/// Base controllerManager, if you want process value by yourself, extends this class.
abstract class ControllerManagerBase {
  /// Store the percentage last time.
  double storePointOffset = 0.0; // 储存上一次的点击事件的控制器的值

  void handlePointIncrease(double pointOffset); //处理滑动增加

  void handlePointDecrease(double pointOffset); //处理滑动减小
}

//使用双链表的控制器管理器
/// Double-linked list collects your own customized  controllers.
/// It not necessary to extends this class unconditionally if you want a customized  data struct.
abstract class LinkedControllerManager<T extends LinkedListEntry<T>>
    extends ControllerManagerBase {
  LinkedList<T> controllers = LinkedList<T>();
}
