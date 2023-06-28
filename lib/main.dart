import 'package:flutter/material.dart';
import 'stopwatch/stopwatch.dart';
import 'button_click_counter/button_click_counter.dart';

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
  final stopWatches = [
    // Hide for presentation
    // StopwatchBinary(),

    StopwatchChannels(),
    StopwatchStd(),
  ];

  void _startOrPause() {
    if (stopWatches[0].isRunned) {
      for (final sw in stopWatches) {
        sw.stop();
      }
    } else {
      for (final sw in stopWatches) {
        sw.start();
      }
    }
  }

  void _reset() {
    for (final sw in stopWatches) {
      sw.reset();
    }
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: stopWatches.map((IStopwatch sw) {
                  return StreamBuilder(
                    initialData: sw.elapsed,
                    stream: sw.elapsedStream,
                    builder: (context, snapshot) {
                      final elapsed =
                          (snapshot.data!.inMilliseconds.toDouble() / 1e3)
                              .toStringAsFixed(1);
                      return Text(
                        "${sw.name} $elapsed sec.",
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.right,
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 50),
              const SizedBox(
                height: 60,
                width: 200,
                child: ButtonClickCounter(),
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
                stream: stopWatches[0].stateStream,
                builder: (_, __) => (stopWatches[0].isPaused)
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.pause),
              ),
            ),
          ],
        ));
  }
}
