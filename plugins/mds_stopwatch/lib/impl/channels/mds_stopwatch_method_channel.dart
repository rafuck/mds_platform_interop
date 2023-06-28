import 'dart:async';
import 'package:flutter/material.dart';

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

  Future _safeInvoke(String method) async {
    try {
      return await methodChannel.invokeMethod(method);
    } on PlatformException catch (ex) {
      debugPrint(ex.message);
      return null;
    } on UnimplementedError {
      debugPrint("$method is unimplemented");
      return null;
    } on MissingPluginException {
      debugPrint('Plugin is not registered');
      return null;
    }
  }

  @override
  Future start() async {
    await _safeInvoke('start');
  }

  @override
  Future stop() async {
    await _safeInvoke('stop');
  }

  @override
  Future reset() async {
    await _safeInvoke('reset');
  }

  Stream<dynamic>? _eventChannelStream;
  @override
  Stream<Duration> get elapsedStream {
    _eventChannelStream ??= eventChannel.receiveBroadcastStream();
    return _eventChannelStream!
        .where((val) => val is int)
        .map((val) => Duration(milliseconds: val as int));
  }
}
