import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCG Electronic Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark()
      ),
      //themeMode: ThemeMode.dark, // Use system theme mode
      home: MyHomePage(title: 'TCG Electronic Counter'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
