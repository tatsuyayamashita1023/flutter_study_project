import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final _stopwatch = Stopwatch();
  String _elapsedTime = '00:00:00:00';

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = Ticker((elapsed) {
      _updateElapsedTime();
    });
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  void _toggleStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _ticker.stop();
    } else {
      _stopwatch.start();
      _ticker.start();
    }
    _updateElapsedTime();
  }

  String _format00(int value) {
    const zero = '0';
    return value.toString().padLeft(2, zero);
  }

  void _updateElapsedTime() {
    debugPrint('${_stopwatch.elapsedMilliseconds}');
    setState(() {
      _elapsedTime =
          '${_format00(_stopwatch.elapsed.inHours)}:${_format00(_stopwatch.elapsed.inMinutes % 60)}:${_format00(_stopwatch.elapsed.inSeconds % 60)}:${_format00(_stopwatch.elapsed.inMilliseconds % 60)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('課題3：ストップウォッチ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _elapsedTime,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleStopwatch,
              child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _stopwatch.reset();
                _updateElapsedTime();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
