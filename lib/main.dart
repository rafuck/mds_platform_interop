import 'package:flutter/material.dart';
import 'stopwatch/stopwatch.dart';

const kTitle = 'Stopwatch';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(key: const Key('HomePage')),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final stopWatch = StopwatchChannels();

  void _startOrPause() {
    if (stopWatch.isRunned) {
      stopWatch.stop();
    } else {
      stopWatch.start();
    }
  }

  void _reset() {
    stopWatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Elapsed',
            ),
            StreamBuilder(
              initialData: stopWatch.elapsed,
              stream: stopWatch.elapsedStream,
              builder: (context, snapshot) {
                final elapsed = (snapshot.data!.inMicroseconds.toDouble() / 1e6)
                    .toStringAsFixed(6);
                return Text(
                  "$elapsed sec.",
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _reset,
            tooltip: 'Reset',
            child: const Icon(Icons.restart_alt),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _startOrPause,
            tooltip: 'Play/Pause',
            child: StreamBuilder(
              initialData: StopwatchState.paused,
              stream: stopWatch.stateStream,
              builder: (_, __) => (stopWatch.isPaused)
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
            ),
          ),
        ],
      ),
    );
  }
}
