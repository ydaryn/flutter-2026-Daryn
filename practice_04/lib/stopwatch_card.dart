import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  String get formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _start() {
    if (_timer != null) return;

    setState(() {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
            (_) {
          setState(() => _seconds++);
        },
      );
    });
  }

  void _stop() {
    _timer?.cancel();

    setState(() => _timer = null);
  }

  void _reset() {
    _timer?.cancel();

    setState(() {
      _timer = null;
      _seconds = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: _timer == null ? _start : null,
                  child: const Text('Start'),
                ),
                OutlinedButton(
                  onPressed: _timer == null ? null : _stop,
                  child: const Text('Stop'),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}