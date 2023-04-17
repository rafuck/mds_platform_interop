import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mds_stopwatch_method_channel.dart';

abstract class MdsStopwatchPlatform extends PlatformInterface {
  /// Constructs a MdsStopwatchPlatform.
  MdsStopwatchPlatform() : super(token: _token);

  static final Object _token = Object();

  static MdsStopwatchPlatform _instance = MethodChannelMdsStopwatch();

  /// The default instance of [MdsStopwatchPlatform] to use.
  ///
  /// Defaults to [MethodChannelMdsStopwatch].
  static MdsStopwatchPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MdsStopwatchPlatform] when
  /// they register themselves.
  static set instance(MdsStopwatchPlatform instance) {
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
