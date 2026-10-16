
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
      debugShowCheckedModeBanner: false,
      title: 'Colour Demo',
      theme: ThemeData.dark(),
      home: const ColourHome(),
    );
  }
}

class ColourHome extends StatefulWidget {
  const ColourHome({super.key});

  @override
  State<ColourHome> createState() => _ColourHomeState();
}

class _ColourHomeState extends State<ColourHome> {
  int seconds = 30;
  String? selectedColour;
  String result = 'पहले राउंड का इंतजार करें';
  final List<String> history = [];
  final Random random = Random();
  Timer? timer;

  final Map<String, Color> colours = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Violet': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        seconds--;
        if (seconds <= 0) {
          _newRound();
          seconds = 30;
        }
      });
    });
  }

  void _newRound() {
    final names = colours.keys.toList();
    result = names[random.nextInt(names.length)];
    history.insert(0, result);
    if (history.length > 10) {
      history.removeLast();
    }
    selectedColour = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colour Trading Demo'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'DEMO GAME • NO REAL MONEY',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'अगले रिज़ल्ट में समय',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '$seconds सेकंड',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'अपना रंग चुनें',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            ...colours.entries.map((entry) {
              final name = entry.key;
              final colour = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colour,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedColour = name;
                    });
                  },
                  child: Text(
                    selectedColour == name ? '$name ✓ Selected' : name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Demo Result',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colours[result] ?? Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedColour == null
                          ? 'आपने अभी कोई रंग नहीं चुना'
                          : 'आपका चयन: $selectedColour',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'पिछले रिज़ल्ट',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (history.isEmpty)
              const Text('पहला राउंड पूरा होने पर हिस्ट्री दिखेगी'),
            ...history.asMap().entries.map((entry) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colours[entry.value],
                  child: Text('${entry.key + 1}'),
                ),
                title: Text(entry.value),
                subtitle: const Text('Demo result only'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
