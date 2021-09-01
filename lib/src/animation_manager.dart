// Copyright (c) 2021 Chinouo . All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'controller_manager.dart';

//如果想要自定义动画器  要从这个类修重写

/// This class is used for [AnimationControllerManager] to manipulate
/// a double-linked list which stored `AnimationController` and its `trigger value`.
///
///  If you want a custom controller list, see [ControllerManagerBase] and [LinkedControllerManager].
class TriggerValWithControllerEntry
    extends LinkedListEntry<TriggerValWithControllerEntry> {
  final double triggerValue;
  final AnimationController controller;
  TriggerValWithControllerEntry(
      {required this.controller, required this.triggerValue});

  @override
  String toString() {
    return 'triggerVal:$triggerValue  controller:$controller';
  }
}

/// A manager deal with [AnimationController]s when given percentage has changed.
///
/// [AnimationControllerManager]'s behavior can be described as follows:
///  1.When the  given percentage has changed, it will check whether it is increasing or decreasing.
///  2.Find the [nextAliveControllerEntry] which its trigger value is closest and bigger than given percentage.
///     This means if we reach the end, this property will be `null`, also when it comes to start, the property is
///     first controller with trigger value in given list.
///
/// Notice: The item's trigger value in given list must be ascending order!
///
/// [AnimationControllerManager] also can notify which [TriggerValWithControllerEntry] is active,
///  give the [ValueNotifier] to notifier property, You can listen and use that in other classes.
class AnimationControllerManager
    extends LinkedControllerManager<TriggerValWithControllerEntry> {
  ValueNotifier<TriggerValWithControllerEntry?>? notifier;
  TriggerValWithControllerEntry? nextAliveControllerEntry; //储存下一个即将启用的控制器
  final int initIndex;
  AnimationControllerManager(
      {required List<TriggerValWithControllerEntry> controllers,
      this.notifier,
      this.initIndex = 0}) {
    //这里的代码可以优化成一次性完成所有的工作 但是可读性差  反正是初始化 不如分步做
    for (var controller in controllers) {
      super.controllers.add(controller);
    }
    var controllerLinkedList = super.controllers;
    if (initIndex == 0) {
      nextAliveControllerEntry = controllerLinkedList.first;
      storePointOffset = 0.0;
      return;
    }
    if (initIndex == controllerLinkedList.length) {
      for (var c in controllers) {
        c.controller.forward();
      }
      storePointOffset = 1.0;
      return;
    }
    //
    nextAliveControllerEntry = controllers[initIndex];
    storePointOffset = controllers[initIndex - 1].triggerValue;
    for (int i = 0; i < controllers.length; ++i) {
      if (i == initIndex) break;
      controllers[i].controller.forward();
    }
  }

  //处理手势
  void handleGesture(double pointOffset) {
    if (storePointOffset < pointOffset) {
      handlePointIncrease(pointOffset);
    } else {
      handlePointDecrease(pointOffset);
    }
    storePointOffset = pointOffset;
  }

  //处理滑动手势增加   参数 (原点偏移量)
  @override
  void handlePointIncrease(double pointOffset) {
    if (nextAliveControllerEntry != null) {
      while (nextAliveControllerEntry!.triggerValue <= pointOffset) {
        if (nextAliveControllerEntry!.controller.status !=
                AnimationStatus.forward &&
            nextAliveControllerEntry!.controller.status !=
                AnimationStatus.completed) {
          nextAliveControllerEntry!.controller.forward();
          notifier?.value = nextAliveControllerEntry;
        }
        nextAliveControllerEntry = nextAliveControllerEntry?.next;
        if (nextAliveControllerEntry == null) {
          break;
        }
      }
    } else {
      //走到这里 则是所有动画都放映完毕
      return;
    }
  }

  //处理滑动手势减少 参数(原点偏移量)
  @override
  void handlePointDecrease(double pointOffset) {
    if (nextAliveControllerEntry == null) {
      if (controllers.last.triggerValue > pointOffset) {
        nextAliveControllerEntry = controllers.last;
        if (nextAliveControllerEntry!.controller.status !=
                AnimationStatus.reverse ||
            nextAliveControllerEntry!.controller.status !=
                AnimationStatus.dismissed) {
          nextAliveControllerEntry!.controller.reverse();
          notifier?.value = nextAliveControllerEntry!;
        }
      }
    } else {
      while (nextAliveControllerEntry!.triggerValue >= pointOffset) {
        if (nextAliveControllerEntry!.controller.status !=
                AnimationStatus.reverse &&
            nextAliveControllerEntry!.controller.status !=
                AnimationStatus.dismissed) {
          nextAliveControllerEntry!.controller.reverse();
          notifier?.value = nextAliveControllerEntry!;
        }
        nextAliveControllerEntry = nextAliveControllerEntry?.previous;
        if (nextAliveControllerEntry == null) {
          //在这边 已经达到0起点
          nextAliveControllerEntry = controllers.first;
          notifier?.value = nextAliveControllerEntry!;
          break;
        }
      }
    }
  }
}
