import 'mds_stopwatch_platform_interface_binary.dart';

class MdsStopwatchBinary {
  Future<void> start() {
    return MdsStopwatchPlatformBinary.instance.start();
  }

  Future<void> stop() {
    return MdsStopwatchPlatformBinary.instance.stop();
  }

  Future<void> reset() {
    return MdsStopwatchPlatformBinary.instance.reset();
  }

  Stream<Duration> get elapsedStream =>
      MdsStopwatchPlatformBinary.instance.elapsedStream;
}
