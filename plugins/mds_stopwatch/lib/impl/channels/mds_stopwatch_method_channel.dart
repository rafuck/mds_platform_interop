import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mds_stopwatch_platform_interface.dart';

const _kMethodChannel = 'mds_stopwatch';
const _kEventChannel = 'mds_stopwatch_event';

class MethodChannelMdsStopwatch extends MdsStopwatchPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(_kMethodChannel);

  @visibleForTesting
  final eventChannel = const EventChannel(_kEventChannel);

  @override
  Future<void> start() async {
    await methodChannel.invokeMethod<String>('start');
  }

  @override
  Future<void> stop() async {
    await methodChannel.invokeMethod<String>('stop');
  }

  @override
  Future<void> reset() async {
    await methodChannel.invokeMethod<String>('reset');
  }

  @override
  Stream<Duration> get elapsedStream => eventChannel
      .receiveBroadcastStream()
      .where((val) => val is int)
      .map((val) => Duration(milliseconds: val as int));
}
