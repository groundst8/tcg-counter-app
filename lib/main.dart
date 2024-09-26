import 'package:flutter/material.dart';
import 'nfc_manager.dart';
import 'package:vibration/vibration.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NFCManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCG Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark()
      ),
      //themeMode: ThemeMode.dark, // Use system theme mode
      home: MyHomePage(title: 'TCG Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _tagDetected = false;


  @override
  void initState() {
    super.initState();
    NFCManager.nfcStream.listen((bool detected) {
      setState(() {
        _tagDetected = detected;
      });

      if (detected) {
        Vibration.vibrate(duration: 200);
      } else {
        Vibration.vibrate(pattern: [200, 200, 200, 200]);
      }
    });
  }

  @override
  void dispose() {
    NFCManager.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _doubleCounter() {
    setState(() {
      _counter*=2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: _tagDetected ? [
          //Icon(Icons.nfc),
          Image.asset('assets/icons/nfc_icon.png')
        ] : [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 128.0),//Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _resetCounter,
              tooltip: 'Reset',
              child: Icon(Icons.refresh),
            ),
            SizedBox(width: 8),
            FloatingActionButton.extended(
              onPressed: _doubleCounter,
              tooltip: 'Double',
              label: const Text('x2')
            ),
            SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: Icon(Icons.remove)),
            SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
