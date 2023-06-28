import 'dart:async';
import 'package:mds_stopwatch/mds_stopwatch.dart';
import '../stopwatch.dart';

class StopwatchChannels implements IStopwatch {
  //-- Private state
  final _stopwatch = MdsStopwatchChannels();

  StopwatchState _state = StopwatchState.paused;
  Duration _elapsed = const Duration();

  final _stateStream = StreamController<StopwatchState>.broadcast();

  static final _finalizer =
      Finalizer<StopwatchChannels>((StopwatchChannels obj) => obj._close());

  void _close() {
    _stateStream.close();
    _finalizer.detach(this);
  }

  void _setState(StopwatchState state) {
    _state = state;
    _stateStream.add(_state);
  }

  //-- IStopwatch public interface
  @override
  String get name => 'PCh';

  @override
  bool get isRunned => _state == StopwatchState.runned;

  @override
  bool get isPaused => !isRunned;

  StopwatchChannels() {
    _finalizer.attach(this, this, detach: this);
  }

  @override
  void start() {
    if (isRunned) {
      return;
    }
    _stopwatch.start();
    _setState(StopwatchState.runned);
  }

  @override
  void stop() {
    if (isPaused) {
      return;
    }
    _stopwatch.stop();
    _setState(StopwatchState.paused);
  }

  @override
  void reset() {
    _stopwatch.reset();
    _elapsed = const Duration();
  }

  @override
  Duration get elapsed => _elapsed;

  @override
  Stream<Duration> get elapsedStream => _stopwatch.elapsedStream;

  @override
  StopwatchState get state => _state;

  @override
  Stream<StopwatchState> get stateStream => _stateStream.stream;
}
