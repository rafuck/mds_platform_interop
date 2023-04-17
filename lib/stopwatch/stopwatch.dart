import 'dart:async';
export './impl/stopwatch_std.dart';
export './impl/stopwatch_binary.dart';
export './impl/stopwatch_channels.dart';

enum StopwatchState { paused, runned }

abstract class IStopwatch {
  bool get isPaused;
  bool get isRunned;
  void reset();
  void start();
  void stop();

  Duration get elapsed;
  Stream<Duration> get elapsedStream;

  StopwatchState get state;
  Stream<StopwatchState> get stateStream;
}
