import 'package:flutter/material.dart';
import 'package:modern_navigation_bar/animated_navigation_bar.dart';

const Color PINK = Color(0xFFe34288);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final List<BarItem> _barItems = [
    BarItem(Icons.home, "Home"),
    BarItem(Icons.explore, "Explore"),
    BarItem(Icons.settings, "Settings")
  ];

  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PINK,
        title: Text("Tab Bar Animation"),
      ),
      bottomNavigationBar: AnimatedBottomBar(
        barItems: _barItems,
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
