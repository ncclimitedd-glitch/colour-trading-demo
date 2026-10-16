import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const ColourDemoApp());
}

class ColourDemoApp extends StatelessWidget {
  const ColourDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colour Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const ColourGamePage(),
    );
  }
}

class GameResult {
  const GameResult({required this.round, required this.colour, required this.time});

  final int round;
  final String colour;
  final DateTime time;
}

class ColourGamePage extends StatefulWidget {
  const ColourGamePage({super.key});

  @override
  State<ColourGamePage> createState() => _ColourGamePageState();
}

class _ColourGamePageState extends State<ColourGamePage> {
  static const int roundLength = 30;
  static const List<String> colours = ['Red', 'Green', 'Violet'];

  final Random _random = Random();
  final List<GameResult> _history = [];
  Timer? _timer;
  int _secondsLeft = roundLength;
  int _round = 1;
  String? _selectedColour;
  String? _latestResult;
  bool _roundFinished = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        _finishRound();
      }
    });
  }

  void _finishRound() {
    _timer?.cancel();
    final result = colours[_random.nextInt(colours.length)];
    setState(() {
      _latestResult = result;
      _history.insert(
        0,
        GameResult(round: _round, colour: result, time: DateTime.now()),
      );
      if (_history.length > 20) _history.removeLast();
      _roundFinished = true;
    });
  }

  void _nextRound() {
    setState(() {
      _round++;
      _secondsLeft = roundLength;
      _selectedColour = null;
      _roundFinished = false;
    });
    _startTimer();
  }

  void _selectColour(String colour) {
    if (_roundFinished) return;
    setState(() => _selectedColour = colour);
  }

  Color _colourValue(String colour) {
    switch (colour) {
      case 'Red':
        return const Color(0xFFE53935);
      case 'Green':
        return const Color(0xFF2E9D50);
      default:
        return const Color(0xFF8E44AD);
    }
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsLeft / roundLength;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Colour Trading Demo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6750A4), Color(0xFF9575CD)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ROUND $_round',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _roundFinished ? 'Round complete' : '00:${_secondsLeft.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.white30,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Demo only • No real money • No deposits or withdrawals',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Choose a colour',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: colours.map((colour) {
                final chosen = _selectedColour == colour;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilledButton(
                      onPressed: _roundFinished ? null : () => _selectColour(colour),
                      style: FilledButton.styleFrom(
                        backgroundColor: _colourValue(colour),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: chosen
                            ? const BorderSide(color: Colors.black, width: 3)
                            : BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(colour, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_selectedColour != null && !_roundFinished) ...[
              const SizedBox(height: 10),
              Text('Your demo selection: $_selectedColour',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 20),
            if (_roundFinished) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Result', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: _colourValue(_latestResult ?? 'Red'),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _latestResult ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: _nextRound,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Start next round'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                const Expanded(
                  child: Text('Result history',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text('${_history.length} rounds',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            if (_history.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('The first result will appear here when the timer ends.'),
                ),
              )
            else
              ..._history.map((item) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _colourValue(item.colour),
                        child: Text(
                          item.colour[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text('Round ${item.round} • ${item.colour}'),
                      subtitle: Text(_formatTime(item.time)),
                      trailing: const Icon(Icons.check_circle_outline),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
