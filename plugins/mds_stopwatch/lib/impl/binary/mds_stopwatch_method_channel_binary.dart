import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mds_stopwatch_platform_interface_binary.dart';

const _kBinaryChannel = 'mds_stopwatch_binary';
const _kBinaryEventChannel = 'mds_stopwatch_binary_event';

class MethodChannelMdsStopwatchBinary extends MdsStopwatchPlatformBinary {
  @override
  Future<void> start() async {
    _invokeMethod('start');
  }

  @override
  Future<void> stop() async {
    _invokeMethod('stop');
  }

  @override
  Future<void> reset() async {
    _invokeMethod('reset');
  }

  final _elapsedStream = StreamController<Duration>.broadcast();
  @override
  Stream<Duration> get elapsedStream => _elapsedStream.stream;

  MethodChannelMdsStopwatchBinary() {
    binaryMessenger.setMessageHandler(_kBinaryEventChannel, (message) {
      if (message == null) {
        return null;
      }
      final elapsed = message.getInt64(0);
      _elapsedStream.add(Duration(milliseconds: elapsed));

      return null;
    });
  }

  BinaryMessenger? _binaryMessenger;
  BinaryMessenger get binaryMessenger =>
      _binaryMessenger ??= _findBinaryMessenger();
  BinaryMessenger _findBinaryMessenger() {
    return !kIsWeb && ServicesBinding.rootIsolateToken == null
        ? BackgroundIsolateBinaryMessenger.instance
        : ServicesBinding.instance.defaultBinaryMessenger;
  }

  Future<void> _invokeMethod(String method) async {
    final Uint8List encoded = utf8.encoder.convert(method);
    await binaryMessenger.send(_kBinaryChannel, encoded.buffer.asByteData());
  }
}
