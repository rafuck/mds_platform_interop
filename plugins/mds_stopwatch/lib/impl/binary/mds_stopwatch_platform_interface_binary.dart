import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mds_stopwatch_method_channel_binary.dart';

abstract class MdsStopwatchPlatformBinary extends PlatformInterface {
  /// Constructs a MdsStopwatchPlatformBinary.
  MdsStopwatchPlatformBinary() : super(token: _token);

  static final Object _token = Object();

  static MdsStopwatchPlatformBinary _instance =
      MethodChannelMdsStopwatchBinary();

  /// The default instance of [MdsStopwatchPlatformBinary] to use.
  ///
  /// Defaults to [MethodChannelMdsStopwatch].
  static MdsStopwatchPlatformBinary get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MdsStopwatchPlatformBinary] when
  /// they register themselves.
  static set instance(MdsStopwatchPlatformBinary instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> start() {
    throw UnimplementedError('start() has not been implemented.');
  }

  Future<void> stop() {
    throw UnimplementedError('stop() has not been implemented.');
  }

  Future<void> reset() {
    throw UnimplementedError('reset() has not been implemented.');
  }

  Stream<Duration> get elapsedStream;
}
