import 'mds_stopwatch_platform_interface.dart';

class MdsStopwatchChannels {
  Future<void> start() {
    return MdsStopwatchPlatform.instance.start();
  }

  Future<void> stop() {
    return MdsStopwatchPlatform.instance.stop();
  }

  Future<void> reset() {
    return MdsStopwatchPlatform.instance.reset();
  }

  Stream<Duration> get elapsedStream =>
      MdsStopwatchPlatform.instance.elapsedStream;
}
