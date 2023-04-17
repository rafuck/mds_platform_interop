import 'dart:async';
import 'package:mds_stopwatch/mds_stopwatch.dart';
import '../stopwatch.dart';

const _kAccuracy = Duration(milliseconds: 1);

class StopwatchBinary implements IStopwatch {
  //-- Private state
  final stopwatch = MdsStopwatchBinary();

  StopwatchState _state = StopwatchState.paused;
  Duration _elapsed = const Duration();

  final _stateStream = StreamController<StopwatchState>.broadcast();

  static final _finalizer =
      Finalizer<StopwatchBinary>((StopwatchBinary obj) => obj._close());

  void _close() {
    _stateStream.close();
    _finalizer.detach(this);
  }

  void _setState(StopwatchState state) {
    _state = state;
    _stateStream.add(_state);
  }

  final Duration accuracy;

  //-- IStopwatch public interface
  @override
  bool get isRunned => _state == StopwatchState.runned;

  @override
  bool get isPaused => !isRunned;

  StopwatchBinary({this.accuracy = _kAccuracy}) {
    _finalizer.attach(this, this, detach: this);
  }

  @override
  void start() {
    if (isRunned) {
      return;
    }
    stopwatch.start();
    _setState(StopwatchState.runned);
  }

  @override
  void stop() {
    if (isPaused) {
      return;
    }
    stopwatch.stop();
    _setState(StopwatchState.paused);
  }

  @override
  void reset() {
    stopwatch.reset();
    _elapsed = const Duration();
  }

  @override
  Duration get elapsed => _elapsed;

  @override
  Stream<Duration> get elapsedStream => stopwatch.elapsedStream;

  @override
  StopwatchState get state => _state;

  @override
  Stream<StopwatchState> get stateStream => _stateStream.stream;
}
